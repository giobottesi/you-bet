# 🎲 You-Bet

**The house always wins. We just show you the receipts.**

A betting simulator that runs the real financial math of gambling in Brazil — no moralizing, just numbers. You tell it what you'd bet and how much per week; it runs **1,000 Monte Carlo simulations** and shows what happens over the timeframe you pick — 1 month to 5 years — then turns your projected losses into things you could've bought or saved instead. 💸

> Built for the **Desafio Contra Bets** competition ("IA em Campo" category). 🇧🇷

---

## ✨ What it does

- 🎰 **Monte Carlo engine** — 1,000 runs per simulation, any horizon from 1 month to 5 years
- 📓 **Notepad-style results** — your outcomes, handwritten on the page
- 💰 **Opportunity cost** — losses translated into groceries, savings, real life
- 📤 **Shareable cards** — post your result with `#DesafioContraBets`
- 🆘 **Always-visible help** — support resources on every results view
- 📚 **Sources page** — every number cited, verifiable (en + pt-BR)
- 🤖 **About page** — full AI-assistance declaration + the story
- 📔 **Devlog** — the build, day by day

No login. No income questions. No identifying data. Simulations stored anonymously so we can surface aggregate impact.

---

## 🛠️ How this is built

A real engineering project, built and looked after by a software engineer — and always evolving. Nothing's hidden: every number links to where it came from (`/sources`), every use of AI is spelled out (`/about`), and the whole build is public, day by day (`/devlog`). Made to be as careful as the industry it's questioning.

---

## 🚀 Quick start

```bash
docker compose up -d
# → http://localhost:3000
```

Tests:

```bash
docker exec you-bet-web-1 bundle exec rspec
```

---

## 🛠️ Stack

Ruby on Rails · PostgreSQL · RSpec + FactoryBot · Tailwind · Docker · Ruby 4.0.1

**Pipeline:** unidirectional — controller → `*Upsert` command → model → `MonteCarloSimulator` → `SimulationResult`. CQS, column-based, typed reference values. No abstraction for its own sake.

---

## 🗂️ Layout

```
app/services/   # MonteCarloSimulator, OpportunityCostMapper, PoupancaCalculator, DevlogReader
app/models/     # Simulation, SimulationResult, ReferenceValue, *Upsert commands
docs/           # the living docs ↓
```

| Doc | What's in it |
|-----|--------------|
| [PROPOSAL](docs/PROPOSAL.md) | what it is, who it's for, why |
| [ARCHITECTURE](docs/ARCHITECTURE.md) | models, pipeline, security |
| [DATA](docs/DATA.md) | reference data, Monte Carlo, caching |
| [DESIGN](docs/DESIGN.md) | palette, type, components |
| [SPRINT](docs/SPRINT.md) | cards, roadmap, constraints |
| [TECH_DEBT](docs/TECH_DEBT.md) | what we know we owe |
| [devlog/](docs/devlog/) | daily journal |

---

## ✨ Future iterations

The MVP shipped — but the dream is bigger. Where this could go next: 🌱

- 🔬 **Sharper Monte Carlo** — push the model closer to real-world fidelity
- 🎨 **Richer comparisons** — pixel-art + icons on the real-world cost cards, so a lost bet *looks* like the groceries it was
- 📤 **More ways to share** — `html → png` cards, more formats, more reach
- 🗣️ **Plainer words** — bet-type copy in human terms, zero jargon
- 🧃 **Pague um refri pro dev** — a little Pepsi-pixel *buy-the-dev-a-pop* corner 🥤
- 📊 **Know the field** — an overview of the other `#DesafioContraBets` simulators, sourced honestly
- 🧹 **Contributor-friendly** — the [TECH_DEBT](docs/TECH_DEBT.md) ledger has starter-sized tasks with your name on them

Full parking lot lives in [docs/BACKLOG.md](docs/BACKLOG.md). Ideas welcome — open an issue. 💛

---

## 🤖 AI assistance

Built with heavy AI assistance, declared in full on the [About page](/about) per competition rules.

## 📄 License

[AGPL-3.0](LICENSE) — © 2026 Giovanna Bottesi. Free to use, remix, and self-host. Run a modified version as a service and you must publish your source too — so the industry can't fork this into the dark.

## 📬 Contact

- **Repo:** https://github.com/giobottesi/you-bet — open an issue for questions, bugs, or a formal LGPD erasure request.
<!-- GIO: add your public contact email below once set, then delete this comment -->
- **Instagram:** [@magicagem](https://www.instagram.com/magicagem/)
