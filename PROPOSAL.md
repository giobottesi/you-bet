# You-Bet — MVP Proposal

**Competition**: Desafio Contra Bets — "IA em Campo" category
**Deadline**: Jul 12, 2026 (17 days from start)

---

## What It Is

A betting simulator that shows people the real financial math of gambling in Brazil — before they start, or while they're in it.

You input what you'd bet on and how much per week. The app runs 1,000 Monte Carlo simulations and shows you what happens across every timeframe — 1 month, 6 months, 1 year, 2 years, 5 years — all at once. Then it converts your losses into things you could've bought or saved instead.

Every simulation is stored anonymously — no login, no income questions, no identifying data — so we can surface aggregate impact ("this week, 5,000 people simulated R$12M in projected losses"). Each result generates a shareable card you can post to social media with #DesafioContraBets, turning every user into a content amplifier.

No login. No income questions. No moralizing. Just math.

---

## Why This Exists

Betting in Brazil went from near-zero to R$30 billion/month in 3 years. 52% of bettors earn up to 2 minimum wages. 42% have debts overdue by more than 90 days. 5 million Bolsa Família families sent money to betting platforms.

The industry's marketing only shows who won. We show the other side — through math, not lectures.

The brief says: "show the losses", "use the concrete", "don't blame the bettor." This app does exactly that.

---

## Who It's For

Two audiences, same engine:

| Audience | Entry framing | Example |
|---|---|---|
| **Never bet** | "Imagine you start betting R$50/week on múltiplas..." | Prevention — show the math before they start |
| **Already betting** | "You bet R$50/week on múltiplas. Here's what the math says." | Awareness — show the math they're living |

---

## User Experience (2 Steps → Results)

### Step 1: "O que você apostaria?"

Select one or more bet types:

| Bet Type | House Edge | Display Name (PT-BR) |
|---|---|---|
| Sports singles (futebol) | 6% | Apostas esportivas |
| 3-leg accumulator | 15% | Múltiplas (3 jogos) |
| 5-leg accumulator | 23% | Múltiplas (5 jogos) |
| Tigrinho / slots | 5% (conservative) | Tigrinho / Caça-níquel |
| Crash games (Aviator) | 4% | Aviator / Crash |
| Lottery (Mega-Sena) | 54% | Loteria |
| Roulette | 5.26% | Roleta |

Note: Tigrinho's claimed RTP is 96.81% (3.2% edge), but unregulated platforms can configure lower RTPs. We use 5% as a conservative middle ground and explain this transparently.

### Step 2: "Quanto por semana?"

Anchored radio buttons based on **real DataSenado spending tiers** — not arbitrary amounts:

| Option | Anchor | Based on |
|---|---|---|
| R$12/semana (~R$50/mês) | "uma assinatura de streaming" | DataSenado: 4% of pop bets up to R$50/month (6.3M people) |
| R$25/semana (~R$100/mês) | "o preço de duas pizzas" | DataSenado: lower bound of R$100-499 tier |
| R$50/semana (~R$200/mês) | "uma parcela de celular" | Near CNC avg monthly spend of R$216 |
| R$125/semana (~R$500/mês) | "quase uma parcela de moto" | DataSenado: 3% of pop bets R$500+/month (4.5M people) |
| Outro valor: [___] | | For exact amounts |

No timeframe selection — results show ALL timeframes at once.

### Results: "O que a matemática diz"

**The Timeframe Cascade** — all 5 periods, no user selection needed:

```
┌─────────────────────────────────────────────────────────┐
│  Apostando R$50/semana em múltiplas, em 1.000           │
│  simulações o resultado mediano foi:                    │
│                                                         │
│  1 mês .......... -R$32   (42% tiveram algum lucro)     │
│  6 meses ........ -R$195  (11% tiveram algum lucro)     │
│  1 ano .......... -R$390  (3% tiveram algum lucro)      │
│  2 anos ......... -R$780  (<1% tiveram algum lucro)     │
│  5 anos ......... -R$1.950                              │
└─────────────────────────────────────────────────────────┘
```

The short-term profit percentage is honest and builds trust. The cascade IS the persuasion — the eye scans down and the math compounds visually.

**Range Fan** — distribution of 1,000 simulated outcomes per timeframe:
- Red zone (P5-P25): worst scenarios
- Orange zone (P25-P75): most likely range
- Gray zone (P75-P95): "lucky" scenarios

**Comparison Cards** — 3 random from a pool + poupança always shown:

```
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│ 31 pizzas│ │ 1 iPhone │ │17m Netflix│ │ R$845 na │
│          │ │          │ │ + Spotify │ │ poupança │
└──────────┘ └──────────┘ └──────────┘ └──────────┘
              [ Ver todas as comparações ▼ ]
```

Expand button loads all comparisons via Turbo Frame. Pool includes: pizzas, cesta básica, smartphone, iPhone, passagem de avião, geladeira, motorcycle, rent, streaming, vocational course. Comparisons scale to loss amount — small losses get small items, large losses get aspirational ones.

**Context Cards** — data-backed stats from verified sources:

| Stat | Number | Source |
|---|---|---|
| Apostadores que ganham até 2 SM | 52% | DataSenado 2024, p.24 |
| Apostadores com dívidas 90+ dias | 42% | DataSenado 2024, p.25 |
| Impacto das apostas vs juros no endividamento | 3x maior | Ibevar/FIA 2026 |
| Apostadores online com comportamento problemático | 66.8% | LENAD III / UNIFESP |
| Famílias do Bolsa Família que mandaram $ para bets | 5 milhões | BCB Estudo Especial nº 119 |

**Every number MUST be double-checked against primary sources before launch.**

**Share Your Result** — each simulation gets:
- Downloadable/shareable image card with summary + #DesafioContraBets
- Unique permalink (`/s/:uuid`) with OG meta tags for rich link previews
- Direct share to Instagram/Twitter/WhatsApp

**Help Resources** — always visible:
- Autoexclusão por CPF (plataformas reguladas .bet.br)
- CVV 188 (gratuito e sigiloso)
- SUS e CAPS
- Jogadores Anônimos

---

## Data Sources

Every number in the app is backed by a verified source, rendered as a `/sources` page.

| Source | What It Provides | Key Numbers |
|---|---|---|
| **Banco Central — Estudo Especial nº 119** | Financial flows, market size | R$18-21 bi/month via Pix, ~24M bettors, R$3 bi from Bolsa Família |
| **DataSenado — Panorama Político 2024** | Bettor demographics, spending, debt | 52% earn ≤2 SM, 42% have 90+ day debt, spending tiers |
| **CNC — PEIC** | Family debt trends | +500% spending growth in 3 years, ~270K families defaulted |
| **UNIFESP / LENAD III** | Clinical gambling behavior | 10.9M at-risk, 66.8% digital bettors show problem behavior |
| **Ibevar/FIA (2026)** | Debt regression analysis | Betting impact 3x greater than interest rates |
| **INSS via Intercept Brasil** | Ludopatia benefits | +2,300% growth in gambling disorder benefits |
| **AtlasIntel / Latam Pulse (Apr 2026)** | Public perception | 86% consider bets harmful, 70% support ban |

### Methodological Notes
- **BCB vs DataSenado bettor count**: BCB says ~24M (Pix data), DataSenado says 22M (survey). We use "22-24 million" and explain the difference.
- **Tigrinho house edge**: PG Soft claims 96.81% RTP, but unregulated platforms can set lower RTPs. We use 5% and disclose this.

---

## Competition Alignment

### Submission Strategy

The challenge requires content formats: video, reels, carousel, meme, or image. A web app URL alone may not qualify.

**Our approach (A + B combined):**
- **Strategy A**: Create a short video/reel demoing the app → formal submission
- **Strategy B**: The app generates shareable result cards → every user becomes a content amplifier with #DesafioContraBets

The app is the creative work. The video is the submission format. The shareable cards are the viral loop.

### "IA em Campo" Requirements
- [x] Declare AI usage visibly in the app (footer badge + `/about` page)
- [x] Declare AI usage in submission post
- [x] No deepfakes or false attributions
- [x] No fabricated screenshots, audio, or "evidence"
- [x] Content is permanent and linkable
- [x] Published on public profile with #DesafioContraBets

### AI Declaration

Visible in: app footer, `/about` page, README, submission post caption.

### The `/about` Page

**"Como a IA foi usada"** (mandatory for IA em Campo):
- Research: AI analyzed 7+ data sources, cross-referenced numbers, surfaced discrepancies
- Code: AI assisted with code generation, architecture, simulation math
- Copy: AI drafted text, developer reviewed for tone and accuracy
- What AI did NOT do: final editorial decisions, data validation against primary sources, design, UX judgment

**"Quem construiu isso"** (developer advocacy):
- The human developer's role: product vision, UX decisions, data source selection, design, editorial judgment, quality control
- Why AI + developer > AI alone: AI can research 7 sources in parallel, but a developer decides which numbers matter. AI can write code fast, but a developer ensures it respects LGPD and serves the user.
- AI is a force multiplier for developers, not a replacement. That's what "IA em Campo" means.
- Link to GitHub repo (open source) + devlog

### Tone (Hard Rules from Brief)

| DO | DON'T |
|---|---|
| Target the industry and its math | Blame or ridicule the bettor |
| Show losses concretely | Moralize ("certo e errado") |
| Welcome with empathy | Use professorial/"lecture" tone |
| Use relatable examples | Sensationalize or expose real people |

### Responsibility
- Help resources always visible (CVV 188, SUS/CAPS, Jogadores Anônimos)
- Autoexclusão por CPF on .bet.br platforms
- Feminine perspective acknowledged: 53.9% of those in betting debt are women

---

## Devlog — "/diario"

A public daily journal page inside the app. Each day of the sprint gets an entry: what was planned, what was built, what changed, what was learned.

**Why:**
- Proves this wasn't "built in 3 hours at Lovable" — it's a 17-day craft effort
- Shows the human decision-making behind every feature (exactly what "IA em Campo" values)
- Doubles as content: the devlog itself is shareable, adds depth to the submission
- Helps us compare planned vs actual sprint performance

Entries are simple markdown rendered as HTML — no CMS, just a static page that gets updated daily. Stored as i18n YAML or a simple view partial per day.

---

## App Name

**You-Bet** — short, ironic, bilingual, memorable. Keeps the current repo name.

Other options considered: "Quanto Você Perde", "Antes de Apostar", "A Conta da Aposta", "Se Eu Apostar".

---

## Next Steps

1. [ ] Align on this proposal
2. [ ] Break into implementation cards
3. [ ] Start Phase 0 (see SPRINT.md)

Technical details → [ARCHITECTURE.md](ARCHITECTURE.md)
Sprint plan → [SPRINT.md](SPRINT.md)
