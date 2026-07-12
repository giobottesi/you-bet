# You-Bet — MVP Proposal

**Competition**: Desafio Contra Bets — "IA em Campo" category
**Deadline**: Jul 12, 2026 (17 days from start)

---

## What It Is

A betting simulator that shows people the real financial math of gambling in Brazil — before they start, or while they're in it.

You input what you'd bet on and how much per week. The app runs 1,000 Monte Carlo simulations and shows you what happens across every timeframe — 1 month, 6 months, 1 year, 2 years, 5 years — all at once. Then it converts your losses into things you could've bought or saved instead.

Every simulation is stored anonymously — no login, no income questions, no identifying data — so we can surface aggregate impact ("this week, 5,000 people simulated R$12M in projected losses"). Each result generates a shareable card you can post to social media with #DesafioContraBets.

No moralizing. Just math.

---

## Why This Exists

Betting in Brazil went from near-zero to R$30 billion/month in 3 years. 52% of bettors earn up to 2 minimum wages. 42% have debts overdue by more than 90 days. 5 million people in Bolsa Família households sent money to betting platforms.

The industry's marketing only shows who won. We show the other side — through math, not lectures.

The brief says: "show the losses", "use the concrete", "don't blame the bettor." This app does exactly that.

---

## Who It's For

Two audiences, same engine:

| Audience            | Entry framing                                                | Example                                      |
| ------------------- | ------------------------------------------------------------ | -------------------------------------------- |
| **Never bet**       | "Imagine you start betting R$50/week on múltiplas..."        | Prevention — show the math before they start |
| **Already betting** | "You bet R$50/week on múltiplas. Here's what the math says." | Awareness — show the math they're living     |

---

## User Experience (2 Steps → Results)

### Step 1: "O que você apostaria?"

Select one or more bet types:

| Bet Type                 | House Edge   | Display Name (PT-BR)   |
| ------------------------ | ------------ | ---------------------- |
| Sports singles (futebol) | Low          | Apostas esportivas     |
| 3-leg accumulator        | Moderate     | Múltiplas (3 jogos)    |
| 5-leg accumulator        | High         | Múltiplas (5 jogos)    |
| Tigrinho / slots         | Low–Moderate | Tigrinho / Caça-níquel |
| Crash games (Aviator)    | Low          | Aviator / Crash        |
| Lottery (Mega-Sena)      | Very high    | Loteria                |
| Roulette                 | Low–Moderate | Roleta                 |

Exact house edge values and methodological notes are in [ARCHITECTURE.md](ARCHITECTURE.md) (settings seed data).

### Step 2: "Quanto por semana?"

Anchored radio buttons based on **real DataSenado spending tiers** — not arbitrary amounts:

| Option                    | Anchor                        | Based on                                                  |
| ------------------------- | ----------------------------- | --------------------------------------------------------- |
| R$12/semana (~R$50/mês)   | "uma assinatura de streaming" | DataSenado: 4% of pop bets up to R$50/month (6.3M people) |
| R$25/semana (~R$100/mês)  | "o preço de duas pizzas"      | DataSenado: lower bound of R$100-499 tier                 |
| R$50/semana (~R$200/mês)  | "uma parcela de celular"      | Near CNC avg monthly spend of R$216                       |
| R$125/semana (~R$500/mês) | "quase uma parcela de moto"   | DataSenado: 3% of pop bets R$500+/month (4.5M people)     |
| Outro valor: [___]        |                               | For exact amounts                                         |

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

**Comparison Cards** — 3 random from a pool + poupança always shown:

```
┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐
│ 31 pizzas│ │ 1 iPhone │ │17m Streaming │ R$845 na │
│          │ │          │ │ bundle │ │ poupança │
└──────────┘ └──────────┘ └──────────┘ └──────────┘
```

Pool includes: pizzas, cesta básica, smartphone, iPhone, passagem de avião, geladeira, motorcycle, rent, streaming, vocational course. Comparisons scale to loss amount — small losses get small items, large losses get aspirational ones.

**Context Cards** — data-backed stats from verified sources:

| Stat                                                       | Number    | Source                     |
| ---------------------------------------------------------- | --------- | -------------------------- |
| Apostadores que ganham até 2 SM                            | 52%       | DataSenado 2024, p.24      |
| Apostadores com dívidas 90+ dias                           | 42%       | DataSenado 2024, p.25      |
| Impacto das apostas vs juros no endividamento              | 3x maior  | Ibevar/FIA 2026            |
| Apostadores online com comportamento problemático          | 66.8%     | LENAD III / UNIFESP        |
| Pessoas em lares do Bolsa Família que mandaram $ para bets | 5 milhões | BCB Estudo Especial nº 119 |

**Every number MUST be double-checked against primary sources before launch.**

**Sharing** — unique permalink (`/s/:uuid`) with OG meta tags + direct share to WhatsApp/Instagram/Twitter. Image card generation deferred to post-MVP.

---

## Data Sources

Every number in the app is backed by a verified source, rendered as a `/sources` page.

| Source                                     | What It Provides                    | Key Numbers                                                       |
| ------------------------------------------ | ----------------------------------- | ----------------------------------------------------------------- |
| **Banco Central — Estudo Especial nº 119** | Financial flows, market size        | R$18-21 bi/month via Pix, ~24M bettors, R$3 bi from Bolsa Família |
| **DataSenado — Panorama Político 2024**    | Bettor demographics, spending, debt | 52% earn ≤2 SM, 42% have 90+ day debt, spending tiers             |
| **CNC — PEIC**                             | Family debt trends                  | +500% spending growth in 3 years, ~270K families defaulted        |
| **UNIFESP / LENAD III**                    | Clinical gambling behavior          | 10.9M at-risk, 66.8% digital bettors show problem behavior        |
| **Ibevar/FIA (2026)**                      | Debt regression analysis            | Betting impact 3x greater than interest rates                     |
| **INSS via Intercept Brasil**              | Ludopatia benefits                  | +2,300% growth in gambling disorder benefits                      |
| **AtlasIntel / Latam Pulse (Apr 2026)**    | Public perception                   | 86% consider bets harmful, 70% support ban                        |

### Methodological Notes
- **BCB vs DataSenado bettor count**: BCB says ~24M (Pix data), DataSenado says 22M (survey). We use "22-24 million" and explain the difference.
- **Tigrinho house edge**: PG Soft claims 96.81% RTP, but unregulated platforms can set lower RTPs. We use 5% as a conservative middle ground and disclose this transparently.

---

## Competition Alignment

> **Disclaimer**: Media outlets (BNLData) report the "Desafio Contra Bets" R$100k prize pool may lack required SPA-MF authorization under Lei 5.768/1971. Any liability falls on the organizer (Projeto Brief/Quid), not entrants — but prize payout could be delayed or contested. Doesn't block submission.

> **Naming note**: "UBET"/"YouBet" is used by live commercial betting brands (Tabcorp's UBET, youbet.com) — fine for this non-commercial demo at `youbet.gio.show`, but revisit the name before any commercial launch. Lei 14.790/2023 (SPA authorization) doesn't apply here since the app takes no real bets or money.

### Submission Strategy

The challenge requires content formats: video, reels, carousel, meme, or image. A web app URL alone may not qualify.

**Our approach (A + B combined):**
- **Strategy A**: Create a short video/reel demoing the app → formal submission
- **Strategy B**: The app generates shareable result cards → every user becomes a content amplifier with #DesafioContraBets

### "IA em Campo" Requirements
- [x] Declare AI usage visibly in the app (footer badge + `/about` page)
- [x] Declare AI usage in submission post
- [x] No deepfakes or false attributions
- [x] No fabricated screenshots, audio, or "evidence"
- [x] Content is permanent and linkable
- [x] Published on public profile with #DesafioContraBets

### The `/about` Page

AI declaration (footer badge + `/about` page + README + submission post). Two sections:
- **"Como a IA foi usada"**: research, code, copy — and what AI did NOT do (editorial, data validation, design, UX)
- **"Quem construiu isso"**: developer advocacy — AI accelerated the build, it didn't replace the developer. Links to GitHub + devlog.

### Tone (Hard Rules from Brief)

| DO                               | DON'T                                |
| -------------------------------- | ------------------------------------ |
| Target the industry and its math | Blame or ridicule the bettor         |
| Show losses concretely           | Moralize ("certo e errado")          |
| Welcome with empathy             | Use professorial/"lecture" tone      |
| Use relatable examples           | Sensationalize or expose real people |

### Responsibility
- Help resources always visible (CVV 188, SUS/CAPS, Jogadores Anônimos)
- Autoexclusão por CPF on .bet.br platforms
- Feminine perspective acknowledged (women are heavily represented among indebted bettors; the specific 53.9% figure is a Procon-SP number, not our DataSenado source, so it is not cited on the page)

---

## Related Docs

- Technical details → [ARCHITECTURE.md](ARCHITECTURE.md)
- Sprint plan → [SPRINT.md](SPRINT.md)
