# Day 13 — The form submits

**Date**: 2026-07-08
**Sprint phase**: Frontend — the handoff from form to results
**Planned**: FE-05 form submission (`#create` → run simulator → persist → redirect to a results permalink)

## TL;DR

- FE-04 (timeframe slider) merged as **#61** earlier today — the affordance pass from yesterday landed.
- FE-05 built and shipped to review as **#63**: the form is no longer a mannequin. It submits, validates, persists, and redirects to a permalink.
- Resolved the blocker that FE-04 surfaced — **how a saved simulation finds its results** — by storing the inputs on the `Simulation` and leaving `SimulationResult` a pure shared cache.
- Adopted **UUID permalinks now**, not later, so share links are non-sequential from the first save.
- Suite grew 106 → 120 green, `/sure-bet` clean end to end.

---

## What got done

### FE-04 crosses the line (#61)

The timeframe slider merged earlier today after a review round. The draggability work from yesterday — the ↔ grip glyph, the accent fill that tracks the thumb, the 44px touch target, `aria-valuetext` — all survived Gio's read. Three inline comments, each applied and replied to in-thread: helper extraction so the template holds no constant lookups, a per-slot accent rotation, and grouping the constant specs under one `describe`. Four frontend cards now sit on `main`, with FE-05 in review behind them.

### The blocker: a saved simulation had no way home

FE-04 had left a landmine for FE-05. A `Simulation` row held only a `visitor_id` — no inputs, no association to any result. `SimulationResult` is a *shared* read-through cache keyed by the input signature; it belongs to nobody. And one form submission fans out: pick three bet types, get three cache rows. So when someone opens a permalink tomorrow, `#show` has nothing to reconstruct the results from. The pieces existed; the wire between them didn't.

### Deciding the linkage — Option 1

Three ways to connect a simulation to its N results: store the inputs on the `Simulation` and re-read the cache from them; a join table listing which cache rows belong to it; or copy the result numbers onto the simulation as a snapshot. Gio took Option 1. The cache stays a cache, the simulation remembers what the user picked, and `#show` re-derives the rest. No join table, no denormalized snapshot — a column beats an abstraction, which is exactly the house architecture.

### UUID now, not in FE-06

Mid-decision Gio asked whether we'd track permalinks by slug — and that's a *different* axis from storage. What goes in the URL is one question; what the row stores is another. Rather than let FE-06 do a permalink migration later, we added a `uuid` column now and pointed `to_param` at it. Share links are opaque and non-sequential from day one; the sequential bigint primary key stays internal. One fewer migration downstream.

### Building `#create`

The action reads the top-level form params, drops the blank custom-amount entry, stamps the `visitor_id` from the signed cookie, persists the simulation, warms one cache row per selected bet type (fetching each type's house edge from reference data), and redirects to the UUID permalink. Invalid input re-renders the form with a `422`. `#show` looks the record up by UUID and 404s on a miss, backed by a deliberately thin stub view — the real results page is FE-06's job, and gold-plating it now would be waste. Request and model specs went in alongside: valid submit, invalid submit, per-type cache warming, visitor stamping, permalink lookup, 404. 120 examples, zero failures.

---

## Decisions & shifts

- **Option-1 linkage.** Simulation stores its own inputs; `SimulationResult` stays a pure shared cache.
  - Why — a join table and a snapshot both add machinery the cache-is-cache model doesn't need.
- **UUID permalink adopted in FE-05, not FE-06.**
  - Why — separating the URL-identity question from the storage question showed the UUID was cheap now and saved a migration later.
- **`timeframe_weeks` persisted as a display default only.**
  - Why — the simulator already returns all five horizons per run, so the slider selects a view, it isn't a simulation input.

---

## Gio's contributions

**Direction day: three calls, each one removed a wrong turn before it happened.**

**Judgment / architecture**
- **Rejected the bundled options and asked "wouldn't we track shows by slugs?"** — exposed that I'd mixed two independent decisions into one list.
  → *Forced the clean split — URL identity vs. stored inputs — which is what actually unblocked the design.*
- **"idk if its worth not using uuids rn"** — pulled the UUID decision forward.
  → *Non-sequential share links from the first save, and one migration deleted from FE-06's plate.*

**Scope / execution**
- **"for the rest, simple route"** — held `#show` to a stub.
  → *No gold-plating a results view that FE-06 rewrites; the diff stayed a tight one-card PR.*

---

## Sprint health

**On track?** Yes
FE-01 through FE-05 are done or in review; the form is a working product end to end, with four days to the deadline.

**Planned vs actual**: Planned FE-05 form submission — delivered, plus FE-04 merged the same day. The only scope the card *grew* was the linkage decision, which was a prerequisite, not a detour.

## Tomorrow

- FE-06 — the results page: render the N cache rows behind a permalink, and surface a bet type whose house edge is missing rather than showing a blank.
- Sync the stale SPRINT.md roadmap table (FE 01–05 still show as not-started).

---

_AI assist cost today: $22.33, 21.3M tokens, you-bet only._

> **Betina says:** "Built a permalink so people can share exactly how much a bet costs them. Somewhere a growth PM is drafting the same feature with the sign flipped."
