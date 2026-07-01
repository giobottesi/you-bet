# Day 05 — The guardrail that cried wolf

**Date**: 2026-06-30
**Sprint phase**: Simulation Engine (BE 09–13)
**Planned**: Land the simulation engine, keep moving on backend cards

## TL;DR

- Simulation engine shipped — BE 09/10/12/13 merged (#11): Monte Carlo sims, poupança, opportunity cost, all as `app/services` objects
- Yesterday's "guardrails" turned out to be a trap: the pre-commit hook false-blocked *every* commit whenever a container was down. Tore it out.
- Rebuilt pre-commit as a native git hook — runs host-side, and requires our postgres (offers to bring the stack up if it's down) rather than skipping tests
- Found the real culprit: another project's postgres squatting on port 5432. Gave ours a dedicated port (5433) so it can't happen again.
- Closed a zombie PR (#12) that was ~1,300 lines behind and would have reverted the whole simulation engine

---

## What got done

### The simulation engine landed

BE 09/10/12/13 merged as #11 — three plain service objects in `app/services/`: `MonteCarloSimulator` (1K-run sims across five timeframes, percentiles P5–P95, expected value), `PoupancaCalculator` (compound interest per timeframe), and `OpportunityCostMapper` (turns a loss into "that's N pizzas" comparisons + poupança). All follow the same `.run` shape, subject+let+FactoryBot specs. Reviewed them against the new conventions — clean, with a couple of minor notes logged (a conditional test assertion, unseeded RNG in the statistical specs).

### The guardrail was booby-trapped

Day 04 ended with "guardrails up" — a pre-commit hook running RuboCop + RSpec. Today that guardrail spent the whole session denying commits. Root cause was ugly: it lived as a Claude Code `PreToolUse` hook shelling into `docker compose exec web`, and it read *"container is down"* as *"your code failed."* Every commit blocked, for an infra reason. Worse, Claude hooks snapshot at session start and don't hot-reload, so editing the config didn't even help mid-session.

Wrong layer, wrong failure mode. Pre-commit checks are a git concern, so they moved to where git looks: `.githooks/pre-commit`, installed via `bin/setup`.

### Host-side, and honest about the database

The rebuild runs RuboCop + RSpec on the host — no `web` container needed. RuboCop is static, so it always runs. RSpec needs a database, and testing exposed why that was flaky: `pg_isready` on `localhost:5432` kept succeeding because *another project's* postgres was squatting on the port — the same squatter that kept our own container from starting. Gio's call: give ours a dedicated host port. Postgres now maps to **5433**, the collision is gone for good, and host-side RSpec talks to the right database. Because the DB is now reliably ours, the hook *requires* it — offering to bring the stack up if it's down — instead of skipping. `database.yml`'s default stays 5432 so CI (which drives postgres on 5432) is untouched.

### Making it look like ours

Once it worked, the hook got dressed in the You-Bet palette — a coral pop-bar header, a pixel-block spinner, a boxed pass/fail summary with a hard drop shadow, mint for green and coral for red. First attempt leaned on jokey persona copy; that was correctly vetoed as cringe. "Cool" means terminal design, not a mascot narrating your build.

### Closing the zombie

PR #12 (an old day-03 branch) was ~1,300 lines behind `main` — merging it would have reverted the simulation engine, the CQS command objects, and the day 04 devlog. Closed it, rescued the one thing worth keeping (the day 03 devlog) into #17, which merged clean.

---

## Decisions & shifts

- **Pre-commit → native git hook.** RuboCop + RSpec out of the Claude `PreToolUse` hook into `.githooks/pre-commit` (`core.hooksPath`, installed by `bin/setup`). Host-side; requires postgres and offers to bring the stack up if it's down. The Claude hook read docker-down as a test failure and couldn't hot-reload — wrong layer.
- **Postgres host port 5432 → 5433.** Dedicate the port so a foreign postgres can't block our container from binding or fool `pg_isready`; `database.yml` default stays 5432 to leave CI untouched.
- **Deploy target: Heroku, not Fly.io.** Match the shipped Procfile; no PII, so Fly.io's BR data-residency rationale is moot. Doc sweep pending.
- **Ruby stays 4.0.1.** Rejected the 4.0.5 Heroku bump — not worth dev/prod churn.
- **`/write-review` skill**, wired into `/safe-bet`: fact-check vs code, dedup, cohesion, and brief-tone pass on public docs.

## Gio's contributions

- Diagnosed the fix direction: "can't we run it locally?" → pushed the hook host-side
  - Impact: RuboCop no longer needs Docker at all; faster, simpler
- Proposed remapping the postgres port instead of working around the collision
  - Impact: root-cause fix — the 5432 wedge is permanently gone
- Vetoed the cringe persona copy, pointed at the design system for the terminal styling
  - Impact: the hook now reads as You-Bet, not as a generic CLI
- Steady process coaching (say things once, ask when unclear, "choose from" for options)
  - Impact: tighter loop for the back half of the sprint

## Sprint health

**On track?** Yes — backend is ahead; the whole simulation chain is merged.
**Planned vs actual**: Planned to land the simulation engine — done. Unplanned: a full day of DX/tooling repair, but it unblocked clean commits and killed a recurring Docker wedge. BE 02 (CI) is still the one red flag — no automated gate before launch.

## Tomorrow

- Fly.io → Heroku doc sweep (ARCHITECTURE + SPRINT)
- `/write-review static` pass over the static docs
- Refine the pre-commit hook visual — Gio bringing terminal design examples
- BE 02 — CI pipeline (still the only automated-gate gap)
- BE 11 — simulation result caching (next simulation card)

---

> **Betina says:** "Passei o dia consertando um segurança de porta que barrava todo mundo — inclusive o dono da casa — sempre que o vizinho fazia barulho. Construí um app pra avisar as pessoas quando elas estão perdendo dinheiro, e hoje o código me avisou a mesma coisa sobre o meu tempo. A ironia continua morando aqui de graça."
