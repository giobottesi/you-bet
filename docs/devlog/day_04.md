# Day 04 — Read/write split, guardrails up

**Date**: 2026-06-29 (into early 06-30)
**Sprint phase**: Data Infrastructure → Simulation Engine (BE 09 prep)
**Planned**: BE 02 (CI), BE 05 (CLAUDE.md), BE 09 (MonteCarloSimulator core), resolve the `BETTING_TYPES` rename

## TL;DR

- Didn't write BE 09 — spent the session making BE 09 *safe to write*: a CQS read/write split and a documented pipeline contract
- `reference_values` got a real `bet_type` column with partial unique indexes; house edges are now `(bet_type, key)` pairs, not stringly-typed `bet_type.x.house_edge` keys
- Renamed `BetTypeUpsert → ReferenceValueUpsert` — one generic write command for all reference data; `BetType` is now a pure read value object
- Hardened the workflow: `/safe-bet` review skill, a pre-commit hook that actually gates, `bin/docker-up`, and a `TECH_DEBT.md` ledger
- 50 specs green; whole-chain, no stubs — the spec suite is now the tripwire for the forward-only pipeline

---

## What got done

### Tooling guardrails before more code (#13)

Three process fixes that had been biting silently:

- **`/safe-bet` review skill** — codifies the pre-PR pass: coherence, duplication, sensitive-info, conventions. The branch-to-PR gate is now a checklist, not vibes.
- **Pre-commit hook fix** — the old hook used a non-functional `"if"` field, so RuboCop + RSpec never actually gated. Replaced with a `jq` command-match so the checks run on `git commit` and nowhere else (they were firing on every Bash call).
- **`.gitignore` `settings.local.json`** — this is a public repo; machine paths, permissions, and MCP servers were one `git add .` away from leaking.
- **`bin/docker-up`** — codifies the manual "port already allocated / server.pid exists" recovery dance: kill conflicting containers, clear the stale pidfile, `compose up -d`.

### TECH_DEBT.md — a debt ledger

Started a running ledger of knowingly-deferred items so "we know, it's on the list" has a source of truth. Four rows on day one: single-file seeds that collide across PRs, the hook's docker-down blind spot, the undecided float-vs-BigDecimal precision policy, and the still-skipped BE 02 CI (the one 🔴 — no automated gate on push yet).

### BE 09 prep — the read/write split (the real work)

BE 09 (Monte Carlo) reads house edges on every request. Before building it, the data layer needed a backbone so the hot path stays lean. This refactor:

- **`bet_type` column + partial unique indexes** — `unique (key) where bet_type IS NULL` for comparison data, `unique (bet_type, key) where NOT NULL` for bet metrics. A bet type can grow more metrics (min/max edge, variance) later without key collisions.
- **`ReferenceValueUpsert`** — renamed from `BetTypeUpsert` and generalized. One `ActiveModel` write command for *all* reference data: validates presence + `value_type` inclusion, upserts via `find_or_initialize_by(key:, bet_type:)`. All seeds route through it.
- **`BetType` is now a pure read object** — tableless, reads `house_edge_value` via the `bet_type` column. `BetType.create` is a thin facade onto the upsert. Reads flow through the pipeline; writes live off the request path.
- **`SeedData`** — every seed set extracted into one place; `db/seeds.rb` is now loops over `ReferenceValueUpsert`.

This is CQS made concrete: the objects that travel the request flow can't bloat, because writing is somebody else's job.

### ARCHITECTURE.md — the pipeline contract

Documented the constraint the code now enforces: a **unidirectional, forward-only pipeline**. Data only travels forward, leaves (`ReferenceValue`, `AppConfig`) are pure reads, composition is free but back-references are banned. Traced the whole simulation request as one line, codified read-vs-write (CQS), and chose audit-log over event-sourcing (full pub-sub is YAGNI for a synchronous simulator). The contributor rule: new behavior is a new forward stage or a pure leaf — never a callback upstream. Specs stress the whole chain, no stubs.

---

## Decisions & shifts

- Pivoted off "write BE 09 today" to "make BE 09 safe to write"
  - Why — building Monte Carlo on stringly-typed `bet_type.x.house_edge` keys and a seed-file write path would have baked coupling into the hot path. Cheaper to fix the foundation now than refactor through the simulator later.
- `bet_type` as a first-class column, not a key prefix
  - Why — `(bet_type, key)` pairs let a bet type own multiple metrics without key collisions; the prefix scheme couldn't.
- Resolved the `BETTING_TYPES` vs `TYPES` rename — kept `BETTING_TYPES` as the constant on `BetType`
  - Why — it was the open blocker on the be-07 PR; `BETTING_TYPES` reads unambiguously.

## Gio's contributions

- Pushed for the tech-debt ledger instead of letting deferrals live in our heads
  - Impact: 4 tracked items, including the 🔴 CI gap that's easy to forget until launch
- Drove the public-repo hygiene catch (`settings.local.json`)
  - Impact: closed a credential/path leak before it could happen on a public repo

## Sprint health

**On track?** Yes — foundation work, not scope creep.
One sentence: BE 09 slipped a day, but it's now unblocked on a clean read/write contract instead of being built on sand.

**Planned vs actual**: BE 02 and BE 05 still pending; BE 09 not started but de-risked. Traded raw card velocity for a foundation that keeps the simulation chain (BE 09–13) from inheriting coupling.

## Tomorrow

- BE 09: MonteCarloSimulator core — now genuinely unblocked; `BetType#house_edge_value` is the single read it needs
- BE 02: CI pipeline (the 🔴 in the ledger — land it before launch)
- Open the be-07 PR now that the rename is resolved
- Update the SPRINT.md roadmap — it still shows only BE 01 as done

---

> **Betina says:** "Passei o dia desenhando regras pra dados não andarem pra trás, num app sobre dinheiro que só anda pra trás. Pelo menos o pipeline tem disciplina que o apostador não tem."
