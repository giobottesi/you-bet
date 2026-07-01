# Day 06 — The gremlin gets a glow-up (and learns to remember)

**Date**: 2026-07-01
**Sprint phase**: CI + tooling hardening (BE 02) → Simulation Engine close-out (BE 11)
**Planned**: Close BE 02 — the CI vuln gate — and land BE 11 result caching

## TL;DR

- **BE 02 landed** (#24): bundler-audit vulnerability gate wired into GitHub Actions. The last automated-gate gap before launch is closed.
- The pre-commit hook got a full **glow-up** (#26): from a monotone coral box to a whimsical, animated two-box UI — steps light up `waiting → running → done` live while they run.
- **BE 11 shipped** (#28): a read-through cache that *freezes* the first Monte Carlo result per input combo, so shared results and permalinks stay stable across reloads.
- Codified the **betina signature gate** into `/safe-bet` so the AI stops leaking the generic "Claude Code" PR footer (a bug flagged four times now).
- Reframed a design principle: **whimsy is load-bearing**, not decoration. Coral alone reads harsh; the brand needs the sparkle.

---

## What got done

### BE 02 — the last gate closes

The CI pipeline card that got skipped all week finally shipped (#24): `bundler-audit` runs on every push, failing the build on any gem with a known CVE. It was the only 🔴 automated-gate item left in TECH_DEBT — now green. The simulation engine (day 05) has a safety net under it.

### The pre-commit hook glow-up

Most of the morning went here. The hook worked but looked like a tax form — one coral box, monotone, faintly stern. Over about seven screenshot rounds with Gio it turned into something that matches the brand: a coral **header box** stacked over a lilac **results box**, hard square borders, a thin drop shadow, and the Gatinho kaomoji watching over it.

The real upgrade is behavioral. Instead of printing a spinner and *then* a summary, the box now draws once and each row — `gems`, `db`, `rubocop`, `rspec` — redraws **in place** through `waiting → running → done`, with a sparkle shimmer while a step runs. Cursor arithmetic under the hood (`\033[nA/B` to jump rows, `printf %b` to repaint), fixed-width so nothing drifts. You watch the checks happen instead of staring at a frozen prompt wondering if it hung.

### The signature gate

While opening the hook PR, the AI once again ended the description with the default "🤖 Generated with Claude Code" footer instead of betina's sign-off — the fourth time that exact miss has happened. Root-caused it: `/safe-bet` runs *before* the PR body exists, so nothing ever checked it. Added a Step 8 to the review skill that enforces the sign-off right before `gh pr create`, and generalized the intern name into a first-time, per-setup choice.

### BE 11 — the cache that has to stand still

Monte Carlo is stochastic by design — same inputs, different distribution every run (day 05 built it that way). But a *shared* result can't shimmer: open a permalink twice and it must show the same numbers. So BE 11 isn't a speed cache, it's a **freeze**. The first time a combo is simulated, the result is stored; every later request with those inputs gets the stored row back, untouched.

Built through the `/implement` two-proposer flow — a "minimal" and a "clean" plan explored in parallel worktrees, then merged into a hybrid: a `SimulationResultUpsert` command object (clean seam, matches the existing `*Upsert` pattern) writing to a thin `simulation_results` table (just an input signature + JSONB results — the key already encodes the inputs, so extra columns were YAGNI). Two doc-vs-code drifts got caught before they became wrong code, and a Rails landmine detonated on first test run: `cache_key` is a reserved ActiveRecord method, so the column became `inputs_signature`.

---

## Decisions & shifts

- **Whimsy is load-bearing.**
  - Why — Gio's read: coral on its own is "too harsh, too masculine." The fix is to mix accents (coral frame + lilac pops) and lean into sparkles. Applies to every surface, terminal included.
- **Prep runs live, not pre-baked.**
  - Why — an earlier hook version ran gems/db silently and flashed them ✓ instantly. Gio reversed it: seeing the work happen *is* the feedback.
- **A table, not `Rails.cache`.**
  - Why — the "cache" is durable, referential data: permalinks (BE 16) must resolve forever, BE 14's `simulations` row foreign-keys to it, and impact stats query it. `Rails.cache` is evictable and un-FK-able. Wrong tool.
- **Upsert command object, but find-or-create semantics.**
  - Why — a literal upsert overwrites every call, which would recompute and break the freeze. Kept the convention, corrected the semantics to compute-on-miss-only.
- **Migrations must be reversible and timeline-safe.**
  - Why — seeds must build a working app from an empty DB; a broken migration poisons the timeline for everyone. Now a standing rule.

## Gio's contributions

- Screenshot-driven art direction on the hook over ~7 rounds — bigger box, mix coral+lilac, thinner shadow, run prep live.
  - Impact: the entire visual identity of the hook.
- Caught the betina PR-footer leak (again) and asked for it to be enforced, not just remembered.
  - Impact: signature gate now lives in `/safe-bet`, at the moment it actually fires.
- "Rails cache, maybe? why new table?"
  - Impact: forced the durability justification into the open — the table earned its place instead of being assumed.
- "remove BE 14, that makes harder"
  - Impact: scope discipline — one card per PR. BE 14 work that had drifted onto the branch got parked, the diff stayed clean.

## Sprint health

**On track?** Yes.
BE 01–13 are done — the entire backend simulation + data layer is complete, and the last automated-gate card (BE 02) closed today. Frontend is still fully greenfield, which is the real remaining mass.

**Planned vs actual**: Planned BE 02 and BE 11 — shipped both — plus an unplanned hook redesign, a signing-safety fix, and catching drifted BE 14 work before it polluted the BE 11 PR.

## Tomorrow

- **BE 14** — VisitorIdentifiable concern (half-built, parked and ready to restore onto its own branch; needs the `simulation_result` reference + `locale` the architecture calls for).
- **BE 15** (Rack::Attack rate limiting) → then **FE 01**, which finally opens the frontend.
- Housekeeping: touched-files scoping for the local hook; pin Ruby for Heroku.

---

_AI assist cost today: $68.13, 79,160,272 tokens (you-bet only)._

> **Betina says:** "The tigrinho apps A/B-test their confetti so losing rent money feels like a jackpot. I spent today making a *git hook* sparkle and teaching a simulator to remember its own spins — same craft, pointed at the four people who'll ever run it, none of whom are being fleeced. Tiny audience. Clean conscience. I'll take the trade."
