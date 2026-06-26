# You-Bet — Architecture

Technical architecture for the MVP. For motivation and product spec, see [PROPOSAL.md](PROPOSAL.md).

---

## Stack

- **Backend**: Rails 8, Ruby 3.3+
- **Database**: PostgreSQL (Fly.io managed)
- **Frontend**: Rails views + Hotwire (Turbo Frames for simulation flow, Stimulus for UI)
- **Audit trail**: PaperTrail (version tracking on settings + critical models)
- **Security**: Rack::Attack (rate limiting + fail2ban)
- **i18n**: Rails built-in I18n (PT-BR primary, EN secondary)
- **Hosting**: Fly.io — São Paulo region (`gru`)
- **CI**: GitHub Actions

---

## System Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        BROWSER (Mobile-first)                   │
│                                                                 │
│  ┌──────────┐   ┌──────────┐   ┌──────────────────────────────┐│
│  │  Step 1   │──▶│  Step 2   │──▶│         Results             ││
│  │ Bet Type  │   │  Amount   │   │ Cascade + Fan + Cards       ││
│  └──────────┘   └──────────┘   │ + Share + Help               ││
│       Turbo Frame swap          └────────────┬─────────────────┘│
│                                              │                  │
│                                    ┌─────────▼────────┐        │
│                                    │  Expand (Turbo)   │        │
│                                    │  All comparisons  │        │
│                                    └──────────────────┘        │
│                                                                 │
│  Stimulus: form validation, localStorage sync, share, locale    │
│  cookie ◄──► localStorage (visitor_id sync)                     │
└──────────────────────────┬──────────────────────────────────────┘
                           │ Turbo (HTML over the wire)
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                     RAILS 8 (Fly.io — São Paulo)                │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │                  ApplicationController                   │    │
│  │         include VisitorIdentifiable                      │    │
│  └─────────────────────────────────────────────────────────┘    │
│         │                     │                     │           │
│         ▼                     ▼                     ▼           │
│  ┌─────────────┐    ┌────────────────┐    ┌────────────────┐   │
│  │ Simulations │    │    Pages       │    │    Visitor      │   │
│  │ Controller  │    │  Controller    │    │   Controller    │   │
│  │             │    │                │    │                 │   │
│  │ new/create  │    │ /sources       │    │ /restore        │   │
│  │ show (/s/id)│    │ /about         │    │ /delete         │   │
│  │ comparisons │    │ /privacy       │    └────────────────┘   │
│  │  (turbo)    │    │ /diario        │                          │
│  └──────┬──────┘    └────────────────┘                          │
│         │                                                       │
│         ▼                                                       │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              SimulationRunner (Service Object)           │    │
│  │                                                         │    │
│  │  1. Check cache (simulation_results by cache_key)       │    │
│  │  2. If miss: run 1K Monte Carlo for ALL timeframes      │    │
│  │  3. Extract percentiles (P5, P25, P50, P75, P95)        │    │
│  │  4. Calculate poupança alternative                      │    │
│  │  5. Store in simulation_results (cache)                 │    │
│  │  6. Create simulation record (per-visitor)              │    │
│  │  7. Return results                                      │    │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              ComparisonPicker (Service Object)           │    │
│  │                                                         │    │
│  │  1. Load comparison prices from settings table          │    │
│  │  2. Filter to meaningful comparisons for loss amount    │    │
│  │  3. Pick 3 random + poupança fixed                     │    │
│  │  4. On expand: return all comparisons via Turbo Frame   │    │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              ShareCardGenerator (Service Object)         │    │
│  │                                                         │    │
│  │  OG meta tags for permalink (/s/:uuid)                  │    │
│  │  Downloadable image card (HTML→image or SVG)            │    │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  I18n: config/locales/{pt-BR,en}.yml                           │
│  Rack::Attack: rate limiting + fail2ban                         │
│  PaperTrail: audit trail on settings + app_constants            │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                     POSTGRESQL (Fly.io)                          │
│                                                                 │
│  app_constants ─── PaperTrail versioned                         │
│  ├── key, value, value_type, description, data_source           │
│                                                                 │
│  settings ─── PaperTrail versioned                              │
│  ├── key, value, value_type, category, description, data_source │
│                                                                 │
│  simulation_results ─── cached Monte Carlo                      │
│  ├── cache_key (unique), bet_types[], weekly_amount_cents       │
│  ├── results (jsonb: all 5 timeframes)                          │
│                                                                 │
│  simulations ─── per-visitor interaction                        │
│  ├── visitor_id (indexed), simulation_result_id, locale         │
│                                                                 │
│  versions ─── PaperTrail audit trail                            │
│  ├── item_type, item_id, event, whodunnit, object, changes     │
└─────────────────────────────────────────────────────────────────┘
```

---

## Database Schema

```ruby
# --- App constants (system-level, separate table) ---

create_table :app_constants do |t|
  t.string :key, null: false, index: { unique: true }
  t.string :value, null: false
  t.string :value_type, null: false, default: "string"  # string, integer, float
  t.string :description
  t.string :data_source                                  # where this number comes from
  t.timestamps
end

# --- Settings (comparison prices, bet type params) ---

create_table :settings do |t|
  t.string :key, null: false, index: { unique: true }
  t.string :value, null: false
  t.string :value_type, null: false, default: "string"
  t.string :category, null: false, index: true           # comparison, bet_type
  t.string :description
  t.string :data_source                                  # citation for this value
  t.timestamps
end

# --- Cached Monte Carlo results ---

create_table :simulation_results do |t|
  t.string :cache_key, null: false, index: { unique: true }
  t.string :bet_types, array: true, default: []
  t.integer :weekly_amount_cents, null: false
  t.jsonb :results, default: {}  # all 5 timeframes
  t.timestamps
end

# --- Per-visitor simulation records ---

create_table :simulations do |t|
  t.string :visitor_id, null: false, index: true
  t.references :simulation_result, null: false, foreign_key: true
  t.string :locale, default: "pt-BR"
  t.timestamps
end

# --- PaperTrail versions (auto-generated) ---
```

Cache key: `"#{bet_types.sort.join(',')}:#{weekly_amount_cents}"` — timeframe not included because all timeframes are calculated in one run.

### Results JSONB Structure

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

---

## Settings Infrastructure

Two tables — `app_constants` for system-level, `settings` for comparison/bet_type config. Both have `data_source` for traceability. Both PaperTrail-versioned.

### `app_constants`

```
monte_carlo_sims       = 1000     | source: "internal"
poupanca_monthly_rate  = 0.0067   | source: "BCB Selic/TR"
minimum_wage_cents     = 162100   | source: "Decreto federal 2026"
data_retention_days    = 180      | source: "internal (LGPD policy)"
```

### `settings` (category: `comparison`)

```
pizza_price_cents        = 4000     | source: "iFood avg delivery, Jun 2026"
iphone_price_cents       = 550000   | source: "Apple BR store, Jun 2026"
smartphone_price_cents   = 90000    | source: "Magazalu Moto G, Jun 2026"
cesta_basica_cents       = 80000    | source: "DIEESE Jun 2026"
netflix_spotify_cents    = 5500     | source: "Official pricing, Jun 2026"
motorcycle_price_cents   = 1000000  | source: "OLX Honda CG 160 avg, Jun 2026"
rent_monthly_cents       = 120000   | source: "FipeZap national avg, Jun 2026"
flight_price_cents       = 80000    | source: "Google Flights domestic avg"
fridge_price_cents       = 200000   | source: "Americanas avg, Jun 2026"
course_price_cents       = 250000   | source: "SENAC avg tech course"
```

### `settings` (category: `bet_type`)

```
sports_singles.house_edge  = 0.06   | source: "Standard bookmaker vigorish"
accumulator_3.house_edge   = 0.15   | source: "Compounding 5% per-leg margin"
accumulator_5.house_edge   = 0.23   | source: "Compounding 5% per-leg margin"
slots_tigrinho.house_edge  = 0.05   | source: "PG Soft RTP adjusted for unregulated"
crash_aviator.house_edge   = 0.04   | source: "Operator-configurable, conservative"
lottery.house_edge         = 0.54   | source: "Caixa prize pool rules"
roulette.house_edge        = 0.0526 | source: "American: 38 pockets, pays as 36"
```

### Access Pattern

```ruby
AppConstant.get("monte_carlo_sims")               # => 1000
Setting.get("comparison.pizza_price_cents")       # => 4000
Setting.get("bet_type.sports_singles.house_edge") # => 0.06
```

### PaperTrail

```ruby
class Setting < ApplicationRecord
  has_paper_trail
end

class AppConstant < ApplicationRecord
  has_paper_trail
end
```

Every change records: what changed, when, who, and the `data_source` update.

### Future "Modifier" Feature

Users get range sliders for house edge (conservative/aggressive). Add `_min`/`_max` keys per setting. No migration needed.

---

## Simulation Engine

### Server-Side Monte Carlo with Turbo

Form submission → Rails runs simulation → Turbo Frame swaps in results. All 5 timeframes calculated in one pass.

**Why server-side:**
1. Collect anonymized aggregate data
2. Turbo gives smooth no-reload UX
3. Shareable result permalinks with OG meta
4. House edge logic stays server-side (not inspectable/manipulable)
5. Simpler frontend — just Stimulus for UI

### Calculation Model

**Layer 1 — Expected Value:**
```
expected_loss = total_wagered × house_edge
```

**Layer 2 — Monte Carlo (1,000 simulations):**
- Simulate each week's bets by type, amount, and house edge
- Track cumulative P&L per simulation
- Extract percentiles: P5, P25, P50, P75, P95

**Layer 3 — Poupança comparison:**
```
monthly_deposit = weekly_amount × 4.33
balance compounds at poupança rate monthly
```

### Caching

Same inputs → statistically equivalent results. Cache by composite key:

```
cache_key = "#{bet_types.sort.join(',')}:#{weekly_amount_cents}"
```

- Cache miss → run Monte Carlo, store in `simulation_results`
- Cache hit → reuse results, create new `simulations` record for aggregate tracking
- Popular combos (R$50/week accumulators) computed once, served many times

---

## Anonymous Sessions

UUID in cookie + localStorage (dual-storage):

1. First visit → generate UUID, set `cookies.signed.permanent[:visitor_id]`
2. JS syncs to localStorage as fallback
3. If cookie cleared but localStorage has it → restore via API
4. All simulations linked by `visitor_id`
5. "Apagar meus dados" → destroys all records + clears cookie

### LGPD Compliance

- Privacy notice in footer
- Privacy policy page explaining: what we collect (anonymous ID + simulation data), why (save results + aggregate stats + security), retention (180 days), deletion (button)
- "Apagar meus dados" button
- 180-day auto-purge
- We collect cookies for security purposes (rate limiting, abuse prevention) — this is disclosed in the privacy policy as legitimate interest under LGPD Article 7(IX)
- Request logs (IP, path, status) are kept separately for security and NOT tied to visitor_id — they're standard web server logs for abuse detection, not user profiling
- Data is anonymized: visitor_id is a random UUID with no link to identity

---

## Security & Logging

This app will be targeted. Betting is a R$30 bi/month industry in Brazil. Plan accordingly.

### Rate Limiting (Rack::Attack)

```ruby
# Throttle simulation creation: 10 per minute per IP
Rack::Attack.throttle("simulations/ip", limit: 10, period: 60) do |req|
  req.ip if req.path == "/simulations" && req.post?
end

# Throttle general requests: 60 per minute per IP
Rack::Attack.throttle("requests/ip", limit: 60, period: 60) do |req|
  req.ip
end

# Fail2ban for suspicious patterns
Rack::Attack.blocklist("block sql injection attempts") do |req|
  Rack::Attack::Fail2Ban.filter("sql-#{req.ip}", maxretry: 3, findtime: 600, bantime: 3600) do
    req.query_string =~ /union|select|drop|insert|delete|update|;|--|'/i
  end
end
```

### Logging Strategy

| What We Log | Purpose | Retention |
|---|---|---|
| Request logs (IP, path, status, duration) | Security — abuse detection | 30 days |
| Rate limit hits (IP, throttle name) | Security — attack detection | 30 days |
| Blocked requests (IP, pattern) | Security — forensics | 90 days |
| Settings/constants changes (PaperTrail) | Audit trail — data integrity | Permanent |
| Simulation volume (aggregate hourly) | Monitoring — bot detection | 90 days |

| What We DON'T Do | Why |
|---|---|
| Tie visitor_id to IP in application logic | Data minimization — separate concerns |
| Log user-agent per visitor_id | Not needed for functionality |
| Store simulation inputs in access logs | Only in DB, not log files |

Security logs (IP-based) and user data (visitor_id-based) are separate streams. Security logs exist for legitimate interest in protecting the service. User data exists for functionality. They don't cross.

### Attack Vectors

| Vector | Mitigation |
|---|---|
| Simulation flood | Rate limit per IP |
| Scraping cached results | Rate limit + UUID permalinks (not enumerable) |
| SQL injection | Rails parameterized queries + input validation |
| XSS via amount field | Rails HTML escaping + CSP headers |
| DDoS | Fly.io built-in protection + rate limiting |
| Data tampering | PaperTrail audit trail, no public write except simulation creation |
| SEO spam / link injection | No user-generated text rendered publicly |

### Infrastructure

- **Rack::Attack** — day 1
- **Rails.logger** — structured JSON in production
- **Fly.io metrics** — built-in request monitoring
- **PaperTrail** — settings audit trail
- **Exception tracking** — TBD: Sentry free tier (nice-to-have)

---

## i18n

```
config/locales/
  pt-BR.yml    # Primary
  en.yml       # Secondary
```

Locale detection: browser `Accept-Language` header, with manual toggle in UI.

---

## Open Source

| Item | Choice |
|---|---|
| License | MIT |
| Files day 1 | LICENSE, README.md, .github/workflows/ci.yml |
| Branch strategy | `main` only (solo dev sprint) |
| CI | GitHub Actions — Rails tests + Postgres service |
