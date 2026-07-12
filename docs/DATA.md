# You-Bet — Data Layer

End-to-end: how numbers enter the system (reference data), how they're validated and written (manipulation), how the simulation turns them into results (Monte Carlo), and how those results are stored and cached.

- [Reference Data Infrastructure](#reference-data-infrastructure) — config + cited external numbers
- [Schema](#schema)
- [Seeded Data](#seeded-data)
- [Research Source Citations](#research-source-citations-sources-page) — verified figures + deep links
- [Write Path — Validation & Idempotency](#write-path--validation--idempotency)
- [Typed KV — Storage & Read Cast](#typed-kv--storage--read-cast)
- [Access Pattern](#access-pattern)
- [PaperTrail (planned)](#papertrail-planned)
- [Simulation Data](#simulation-data) — calculation model, Monte Carlo rationale, results, caching
- [Future Modifier Feature](#future-modifier-feature)
- [Backoffice (future phase)](#backoffice-future-phase)

---

## Reference Data Infrastructure

Two tables — `app_configs` for system-level constants, `reference_values` for externally-sourced cited data (prices, house edges). Both carry a `data_source` for traceability.

**Why two tables?** `app_configs` are internal decisions (how many simulations to run, retention policy). `reference_values` are external facts that change independently and need citations (pizza prices, house edges). Different update cadence, different ownership. ([Separation of Concerns — Martin Fowler](https://martinfowler.com/bliki/SeparationOfConcerns.html))

## Schema

Both tables are typed key-value stores: `value` is always a `string`, and `value_type` names how to cast it on read.

```ruby
# --- app_configs (system-level constants — Monte Carlo params, rates, retention) ---
create_table :app_configs do |t|
  t.string :key, null: false, index: { unique: true }
  t.string :value, null: false
  t.string :value_type, null: false, default: "string"  # string, integer, float, decimal
  t.string :description
  t.string :data_source                                  # where this number comes from
  t.timestamps
end

# --- reference_values (externally-sourced cited data — prices, house edges) ---
create_table :reference_values do |t|
  t.string :key, null: false
  t.string :value, null: false
  t.string :value_type, null: false, default: "string"  # string, integer, float
  t.string :category, null: false, index: true           # comparison, bet_type
  t.string :bet_type                                     # set only for category=bet_type
  t.string :description
  t.string :data_source                                  # citation for this value
  t.timestamps
end
```

`reference_values` uniqueness is two **partial** indexes, not a single column:

- unique on `key` where `bet_type IS NULL` — comparison values
- unique on `(bet_type, key)` where `bet_type IS NOT NULL` — bet-type metrics

So a bet type can own more metrics later (`min`/`max` edges) without key collisions, while comparison keys stay globally unique.

## Seeded Data

### `app_configs`

```
monte_carlo_sims       = 1000     | source: "internal"
poupanca_monthly_rate  = 0.0067   | source: "BCB Selic/TR"
minimum_wage_cents     = 162100   | source: "Decreto federal 2026"
data_retention_days    = 180      | source: "internal (LGPD policy)"
```

### `reference_values` (category: `comparison`)

```
pizza_price_cents        = 4000     | source: "iFood avg delivery, Jun 2026"
iphone_price_cents       = 550000   | source: "Apple BR store, Jun 2026"
smartphone_price_cents   = 90000    | source: "Magazine Luiza Moto G, Jun 2026"
cesta_basica_cents       = 80000    | source: "DIEESE Jun 2026"
music_video_stream       = 5500     | source: "Official pricing, Jun 2026"
motorcycle_price_cents   = 1000000  | source: "OLX Honda CG 160 avg, Jun 2026"
rent_monthly_cents       = 120000   | source: "FipeZap national avg, Jun 2026"
flight_price_cents       = 80000    | source: "Google Flights domestic avg"
fridge_price_cents       = 200000   | source: "Americanas avg, Jun 2026"
course_price_cents       = 250000   | source: "SENAC avg tech course"
```

### `reference_values` (category: `bet_type`)

The bet type lives in its own `bet_type` column; `key` names the metric (`house_edge`). Uniqueness is the pair `(bet_type, key)`.

```
bet_type=sports_singles  key=house_edge  = 0.06   | source: "Standard bookmaker vigorish"
bet_type=accumulator_3   key=house_edge  = 0.15   | source: "Compounding 5% per-leg margin"
bet_type=accumulator_5   key=house_edge  = 0.23   | source: "Compounding 5% per-leg margin"
bet_type=slots_tigrinho  key=house_edge  = 0.05   | source: "PG Soft RTP adjusted for unregulated"
bet_type=crash_aviator   key=house_edge  = 0.04   | source: "Operator-configurable, conservative"
bet_type=lottery         key=house_edge  = 0.54   | source: "Caixa prize pool rules"
bet_type=roulette        key=house_edge  = 0.0526 | source: "American: 38 pockets, pays as 36"
```

**House-edge rationale** — these drive the entire loss projection, so each is sourced and reasoned:

| Bet type         | Edge  | Why                                                                                                                         |
| ---------------- | ----- | --------------------------------------------------------------------------------------------------------------------------- |
| `sports_singles` | 6%    | Standard bookmaker vigorish (~1.91 odds on a coin-flip = ~4.5–6% margin).                                                   |
| `accumulator_3`  | 15%   | A 3-leg parlay compounds the per-leg margin: `1 − (1 − 0.05)³ ≈ 0.14`, rounded up for correlated legs.                      |
| `accumulator_5`  | 23%   | Same compounding at 5 legs: `1 − (1 − 0.05)⁵ ≈ 0.23`. Edge grows fast with legs — the core "accumulators are a trap" story. |
| `slots_tigrinho` | 5%    | PG Soft's published Fortune Tiger RTP is 96.81%, but unregulated clones run lower; 5% is the optimistic floor.              |
| `crash_aviator`  | 4%    | Operator-configurable RTP; 4% is a conservative public figure. Real edge can be far higher.                                 |
| `lottery`        | 54%   | Caixa retains ~54% of the prize pool — by far the worst expected value.                                                     |
| `roulette`       | 5.26% | American wheel: 38 pockets, payouts as if 36 → `2/38 = 0.0526`.                                                             |

Seed definitions live in `app/models/seed_data.rb`; `db/seeds.rb` feeds them through the upsert commands below.

## Research Source Citations (`/sources` page)

Every headline figure the app cites is verified against its primary source and deep-linked (not the publisher homepage). Figures were audited against each study directly — a few were re-attributed or reworded from the challenge kit's framing (noted below). `SourcesController::DATA_SOURCES` is the runtime copy of this table.

| Source                                        | Verified figures                                                                                                           | Deep link                                                                                                                                                                                     | Note                                                                                                                                                                                                 |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **BCB — Estudo Especial nº 119**              | R$18–21 bi/mo via Pix (2024 avg); 5M *people* in Bolsa Família households sent R$3 bi to bets (4M benefit-holder families) | [bcb.gov.br — EE119 PDF](https://www.bcb.gov.br/conteudo/relatorioinflacao/EstudosEspeciais/EE119_Analise_tecnica_sobre_o_mercado_de_apostas_online_no_Brasil_e_o_perfil_dos_apostadores.pdf) | Kit framed "5M families" — corrected to *people*. R$30 bi/mo is a CNC figure, re-attributed away from BCB.                                                                                           |
| **DataSenado — quem aposta no Brasil (2024)** | 13% of Brazilians 16+ (22.13M) bet in the last 30 days; 52% earn ≤2 min wages; 42% carry 90+ day debt                      | [senado.leg.br — interactive](https://www.senado.leg.br/institucional/datasenado/relatorio_online/pesquisa_aposta_esportiva/2024/interativo.html)                                             | Report prints "13% = 22,13 mi" (last 30 days). 42% is the complement of the reported "58% *don't* have 90+ day debt" (press prints 42%; the report prints 58%).                                      |
| **CNC — bets & family debt**                  | monthly-spending growth over R$30 bi; ~270K families in possible severe (90+ day) default                                  | [portaldocomercio.org.br](https://portaldocomercio.org.br/diario-executivo/para-cnc-bets-agravam-endividamento-das-familias-brasileiras/)                                                     | R$30 bi is the *growth* in monthly spending over the period, not a flat total. 270K is conditional ("podem ter levado"). Magnitude publicly contested by IBJR — flagged in the methodological notes. |
| **UNIFESP / LENAD III (FAPESP)**              | 10.9M at-risk gamblers (6.8% of 14+)                                                                                       | [revistapesquisa.fapesp.br](https://revistapesquisa.fapesp.br/quase-11-milhoes-de-brasileiros-apostam-de-modo-a-por-em-risco-a-saude-e-as-financas/)                                          | —                                                                                                                                                                                                    |
| **Ibevar/FIA**                                | debt-driver regression coefficients: bets 0.2255; consumer interest 0.0709; credit-to-income 0.0440                        | [infomoney.com.br](https://www.infomoney.com.br/politica/apostas-online-superam-juros-como-fator-de-endividamento-no-brasil-mostra-estudo/)                                                   | Replaces the kit's unquantified "weigh more than interest". Cite all three coefficients, not the bets/interest ratio.                                                                                |
| **INSS / Intercept — "Do tigrinho ao INSS"**  | +2,300% monthly ludopatia sick-leave benefits (Jun 2023 → Apr 2025); 73% of beneficiaries are men                          | [intercept.com.br](https://www.intercept.com.br/2025/06/25/bets-auxilios-doenca-vicio-em-jogos-brasil/)                                                                                       | —                                                                                                                                                                                                    |
| **AtlasIntel / Latam Pulse (Apr 2026)**       | 86.7% say bets harmful; 70% support a total ban; 76% want ad limits; 85.2% link bets to family debt                        | [atlasintel.org — poll](https://atlasintel.org/poll/latam-pulse-brazil-april-2026-2026-04-30)                                                                                                 | Ad-limit and family-debt figures live in the poll PDF, not the HTML.                                                                                                                                 |

**Not carried on the page (dropped — re-source before reuse):**
- "53.9% of debtors are women" — a Procon-SP figure, not DataSenado; dropped rather than mis-cite.
- **CNC "+500% spending growth in 3 years"** — not found in the cited CNC article. Parked 2026-07-12; needs a primary source before it can be used.
- **UNIFESP "66.8% of bettors show risky-or-problem gambling"** — not in the cited FAPESP article (which reports 66.5% as a *male ratio*, a different figure). Parked 2026-07-12; re-source from the original LENAD III report if it exists there.

**Primary verification (2026-07-12):** the automated fetch hit 403/500 on the BCB PDF, Intercept, and AtlasIntel pages, so those were **confirmed manually against the primary sources** by the maintainer. All figures on this table are first-party verified.

## Privacy Notice — Plain-Language Sources (parked for `/privacy`)

The `/privacy` copy is written as plain-language privacy *education* — a visitor with zero tech literacy should finish knowing what a cookie is and how to erase their data. These are the primary sources behind that register, parked here for a future "further reading" block on the page (not yet surfaced in the UI).

| Source                                                                       | Why it's cited                                                                                                                                                                                   | Link                                                                                                                                                                 |
| ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **ANPD — Guia Orientativo: Cookies e Proteção de Dados Pessoais** (Oct 2022) | pt-BR register + native cookie framing ("arquivos instalados no dispositivo" / mainstream "pequeno arquivo de texto que o site salva no navegador"); explicitly written to teach a lay audience. | [gov.br/anpd — PDF](https://www.gov.br/anpd/pt-br/centrais-de-conteudo/materiais-educativos-e-publicacoes/guia-orientativo-cookies-e-protecao-de-dados-pessoais.pdf) |
| **ANPD — Aviso de Privacidade**                                              | LGPD transparency: "linguagem simples e compreensível", avoiding siglas/jargões/estrangeirismos; states what data, why, how long.                                                                | [gov.br/anpd — aviso](https://www.gov.br/anpd/pt-br/acesso-a-informacao/aviso-de-privacidade)                                                                        |
| **ICO — Cookies and privacy notices**                                        | Explain each cookie in the reader's terms; users must grasp the consequences, not decode jargon.                                                                                                 | [ico.org.uk](https://ico.org.uk/for-organisations/advice-for-small-organisations/privacy-notices-and-cookies/cookies-and-privacy-notices-in-detail/)                 |
| **GDPR Art. 12 — clear and plain language**                                  | The legal baseline: "concise, transparent, intelligible", vocabulary tailored to the audience.                                                                                                   | [gdpr-info.eu](https://gdpr-info.eu/art-12-gdpr/)                                                                                                                    |
| **digital.gov — Plain Language** (ex `plainlanguage.gov`)                    | Second-person voice, common words over jargon, concrete over abstract, short sentences.                                                                                                          | [digital.gov](https://digital.gov/guides/plain-language)                                                                                                             |
| **NN/g — Privacy policies & cookie permissions**                             | UX evidence: users feel policies "aren't written for them"; bullet each purpose, make choices scannable.                                                                                         | [nngroup.com](https://www.nngroup.com/articles/privacy-policies-terms-use-pages/)                                                                                    |

## Write Path — Validation & Idempotency

All writes go through ActiveModel command objects (`AppConfigUpsert`, `ReferenceValueUpsert`), never `Model.create` directly. The AR record stays a dumb typed-KV row; every rule lives in the command at the boundary. This is the CQS **write side** — the query side (`fetch`, `typed_value`) trusts the data because the command already validated it.

```ruby
class ReferenceValueUpsert
  include ActiveModel::Model
  include ActiveModel::Attributes
  # validates :key, :value, :category presence
  # validates :value_type, inclusion: %w[string integer float]

  def upsert
    return false unless valid?
    reference_value.assign_attributes(value:, value_type:, category:, description:, data_source:)
    reference_value.save
  end

  def reference_value
    @reference_value ||= ReferenceValue.find_or_initialize_by(key:, bet_type:)
  end
end
```

Three properties this buys:

- **Validated at the boundary.** `value_type` must be in the whitelist; `key`/`value` (and `category` for reference values) must be present. Malformed data never reaches the table — the column-level `null: false` constraints are a backstop, not the gate.
- **Idempotent.** `find_or_initialize_by` on the natural key (`key`, or `(key, bet_type)`) updates in place on re-run. Seeds are safe to run any number of times in any environment — no duplicates.
- **Form-bindable.** `upsert` returns `false` + `errors` on invalid input, truthy on save — the exact contract a backoffice form needs to re-render or persist (see [Backoffice](#backoffice-future-phase)).

**The `value_type` whitelists differ by table, on purpose:**

- `AppConfigUpsert` allows `decimal` — `poupanca_monthly_rate` is cast with `BigDecimal` for precise compounding; floats drift over many periods.
- `ReferenceValueUpsert` allows only `string/integer/float` — prices are integer cents, house edges are floats. No decimal money math lives here; comparison values are display-only.

## Typed KV — Storage & Read Cast

`value` is stored as a `string` in both tables. `value_type` names the type; `typed_value` casts on read:

```ruby
def typed_value
  case value_type
  when 'integer' then value.to_i
  when 'float'   then value.to_f
  when 'decimal' then BigDecimal(value)  # AppConfig only
  else value
  end
end
```

**Why string storage + cast?** One schema holds heterogeneous types (ints, floats, decimals, strings) without a column per type. The write-side validation is the type gate; the read-side cast is deterministic. `AppConfig.fetch(key)` wraps `find_by!(key).typed_value` — it raises on a missing key, because config reads are required, not optional. `ReferenceValue` reads use `find_by` (nil-tolerant) since a missing comparison price degrades gracefully.

## Access Pattern

```ruby
AppConfig.fetch("monte_carlo_sims")                                 # => 1000
ReferenceValue.find_by(key: "pizza_price_cents").typed_value         # => 4000
BetType.new(key: "sports_singles").house_edge_value                 # => 0.06
ReferenceValueUpsert.upsert(bet_type: "...", key: "house_edge", ...) # write side
```

## PaperTrail (planned)

Not yet wired — `paper_trail` is not in the Gemfile. When added, both tables get `has_paper_trail`:

```ruby
class ReferenceValue < ApplicationRecord
  has_paper_trail
end
```

Every change then records what changed, when, and the `data_source` behind it — a full audit trail. If a price changes, we know its old value, when it changed, and which source justified the update.

---

## Simulation Data

How reference data becomes a loss projection. The engine (`MonteCarloSimulator`) reads `house_edge` per bet type and `app_configs` params, runs all 5 timeframes in one pass, and writes a `simulation_results` row.

### Calculation Model

**Layer 1 — Expected Value (closed form):**

```
expected_loss = total_wagered × house_edge
```

The deterministic headline number. With a 6% edge, R$100 wagered loses R$6 on average.

**Layer 2 — Monte Carlo (1,000 simulations):**

- Simulate each week's bets by type, amount, and house edge
- Track cumulative P&L per simulation run
- Extract percentiles across runs: P5, P25, P50, P75, P95

**Why Monte Carlo over closed-form?** Accumulators have non-normal distributions — many small losses, rare large wins. The mean (Layer 1) hides that skew. Monte Carlo captures it and lets us show realistic percentile ranges: "half the time you end below P50, 1-in-20 times below P5." Closed-form gives the expected value; Monte Carlo gives the *distribution story* that makes the loss tangible. ([Monte Carlo methods in finance — Glasserman, 2003](https://link.springer.com/book/10.1007/978-0-387-21617-1))

**Why 1,000 runs?** `monte_carlo_sims` is an `app_config`, not a constant — tunable without deploy. 1,000 is enough to stabilize the P5–P95 band for these distributions while staying inside a single synchronous request (no background job). Raise it via config if percentile noise shows.

**Layer 3 — Poupança comparison (opportunity cost):**

```
monthly_deposit = weekly_amount × 4.33          # avg weeks per month
balance compounds at poupanca_monthly_rate monthly
```

Reframes the loss as forgone savings: "the same R$50/week in poupança would be R$X." Rate comes from the `poupanca_monthly_rate` config (BigDecimal, precise compounding).

### Results JSONB Structure

One `simulation_results` row holds all five timeframes as JSONB — read-optimized, no join per timeframe:

```json
{
  "4_weeks": {
    "expected_loss_cents": 6000,
    "percentiles": { "p5": -18000, "p25": -10000, "p50": -6000, "p75": -2000, "p95": 5000 },
    "profit_percentage": 38.2,
    "poupanca_alternative_cents": 1740
  },
  "26_weeks": { "..." },
  "52_weeks": { "..." },
  "104_weeks": { "..." },
  "260_weeks": { "..." }
}
```

### Caching

Same inputs → statistically equivalent results, so each bet type is cached under a signature of its inputs:

```
inputs_signature = "#{bet_type_key}:#{house_edge}:#{weekly_amount_cents}:#{simulation_count}"
```

- **Cache miss** → run `MonteCarloSimulator`, store in `simulation_results`
- **Cache hit** → reuse the stored results, but still create a new `simulations` record for aggregate tracking
- Popular combos (R$50/week accumulators) are computed once, served many times

The split matters: `simulation_results` is the cache (dedup by `inputs_signature`); `simulations` is the per-visitor audit row (one per request, for impact stats). Each bet type is simulated and cached on its own signature.

---

## Future "Modifier" Feature

Users get range sliders for house edge (conservative/aggressive). Add `_min`/`_max` keys per reference value. No migration needed.

## Backoffice (future phase)

An admin UI for managing bet types and reference values — creating/editing house edges and comparison prices without a deploy. The write path is already shaped for it: `ReferenceValueUpsert` is the [form-bindable](#write-path--validation--idempotency) command a backoffice form binds to. To support this future phase, bet types are **not** a closed set: the `inclusion` whitelist was removed so admins can add new types as data. The current `BETTING_TYPES` list is just the seeded/known set, not a constraint.
