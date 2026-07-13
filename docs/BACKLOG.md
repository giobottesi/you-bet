# Backlog

Post-MVP parking lot. The MVP shipped 2026-07-12 (live at youbet.gio.show); this tracks what comes next. Not a committed roadmap — a parking lot for ideas, grouped so a fresh session (or contributor) can pick one up.

## 🎯 Results page
- Rewrite the collapsible copy — currently hard to read
- Review the help-resources block
- Add icons / art to the real-world comparison cards
- Make comparison cards occupy full width when only one is shown

## 🌍 i18n & copy
- Review `en` against the `pt-BR` locales that changed (parity sweep)
- Rewrite bet-type copy into user-friendly terms (drop jargon)

## 📤 Sharing
- More share options after the `html → png` render lands

## 🎨 Design consistency
- Review older pages against the latest specs — results + about are polished; **devlog** would benefit most

## 🔬 Simulation realism
- Refine the Monte Carlo model toward real-world fidelity — external reading: [Monte Carlo vs reality (2026)](https://supercalcpro.com.au/blog/monte-carlo-vs-reality-2026.html)
- Research whether `rebet_fraction` should vary by bet type. Fast auto-repeat products (tigrinho, aviator) plausibly recycle near 1.0; discrete ones (sports singles, lottery) lower. Today it's one conservative class default (0.5), overridable per call but not seeded per type. Find a primary basis (RTP-by-product exists; the turnover÷deposits ratio that would pin `r` does not — see DATA.md) before seeding any per-type table; otherwise it stays one honest default. Ship per-type values flagged as illustrative assumption, never as data.

## 🧃 Whimsy
- "Pague um refri pro dev" — a Pepsi pixel-art *buy-the-dev-a-pop* trinket somewhere

## 📊 Competition
- Overview scan of the `#DesafioContraBets` Instagram tag — compare our verified-source sim against the other simulation platforms out there. Overview, not scoreboard — no judgment of others' methods before understanding them.

## 🧹 Process
- Open the `TECH_DEBT.md` rows as tracked issues (decide: GitHub issues vs. keep the ledger)
