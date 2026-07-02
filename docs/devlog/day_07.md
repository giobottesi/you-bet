# Day 07 — Three cards shipped, next tranche scoped

**Date**: 2026-07-02
**Sprint phase**: Anonymous Sessions (BE 14) → Security (BE 15) → Harden (BE 19)
**Planned**: Move past the simulation engine into sessions, rate limiting, and edge-case hardening

## TL;DR

- **Three cards built, reviewed, and merged to `main` in one day**: BE 14 anonymous sessions (#30), BE 15 Rack::Attack rate limiting (#31), BE 19 edge-case tests (#32). One day cut across three sprint sections.
- **BE 14** gives every visitor a signed permanent UUID cookie and links their `Simulation` records to it — no accounts, no PII, results still belong to someone.
- **BE 15** wraps the app in `Rack::Attack`: ENV-tunable throttles on simulations and general traffic, 429 on breach. The public endpoint stops being a free compute faucet.
- **BE 19** hammers the Monte Carlo core across 17 examples — zero/negative/extreme amounts, house edge pinned at 0 and 1.0, unknown bet type, every known bet type — asserting graceful degradation.
- **Gio spent the day steering, not typing**: locked the scope for the *next* five cards (BE 16–19 + the whole FE track) in a single decision record, then merged the three PRs himself in dependency order. Tank's empty on backend; tomorrow is drafts and drawings.

---

## What got done

### BE 14 — visitors get an identity without an account

The `VisitorIdentifiable` concern lands in `ApplicationController`: a signed, permanent UUID cookie minted on first hit and read back on every request after. The new `Simulation` model carries a `visitor_id` so a run can be traced to the anonymous session that made it — the groundwork permalinks and share cards will stand on. Eight files, tight diff: concern, model, migration, and specs proving the UUID survives across requests and records link correctly. No login, no email, no tracking — just enough identity to say "this result is yours."

### BE 15 — the endpoint stops being a free faucet

`Rack::Attack` initializer with two throttle families: a tight one on the simulation endpoint (the expensive path) and a looser general limit, both driven by ENV so staging and prod tune independently without a redeploy. Breach the limit, get a 429. Request specs drive it past the threshold and assert the throttle fires. The `.env.example`, `docker-compose`, and `ARCHITECTURE`/`TECH_DEBT` docs moved in the same PR so the knob is documented where the next person looks.

### BE 19 — break it on purpose

Edge-case coverage for `MonteCarloSimulator`, one focused spec file, +98 lines, 17 examples. The nasty inputs: zero weekly amount, negative amount, absurdly large amount, house edge pinned at 0, house edge pinned at 1.0 (the house always keeps the stake), an unknown bet type, and a pass across every known bet type. A `profit sensitivity to house edge` block asserts losses scale the right direction as the edge climbs. Not new behavior — a contract that the simulator eats garbage *gracefully* instead of throwing or returning nonsense percentiles. The Harden section starting early, before FE work exposes these paths to real users.

### Merged in dependency order

All three landed on `main` the same day — #30, then #31, then #32, one at a time. The sequencing wasn't cosmetic: #30 and #31 both touch `ARCHITECTURE.md` and `SPRINT.md`, so a parallel merge would have clobbered the shared docs. Serial merge keeps the roadmap diffs clean and unblocks the docs PR to branch off a settled `main`.

---

## Decisions & shifts

Most of today's *thinking* went into a decision record scoping the next five cards, so nothing gets re-litigated later:

- **BE 16 permalink → on hold.** Blocks nothing in flight; don't start it.
- **BE 19 → approved, do it now.** Zero dependencies, engine already built. (Shipped same day.)
- **FE 01–15 → plain views first, controllers throwaway-ish.** Wire model→view→controller end-to-end per card; don't gold-plate controller structure now — iterate those patterns once a few flows exist.
- **BE 18 → widened to a two-table audit.** OWASP Top 10:2025 (web) *plus* OWASP Top 10 for LLM Applications 2025, the latter reframed as a provenance/misinformation audit of AI-*assisted development* (You-Bet runs no runtime LLM). Feeds the competition's required AI-usage declaration and links to BE 20 instead of duplicating it.
- **BE 17 → client-side, zero server infra.** Rejected server-side headless Chromium (dyno RAM + Chromium buildpack for a one-off on-tap image). `html-to-image` vendored via importmap + Web Share API L2, download/copy fallback where unsupported.
- Jumped three sprint sections in one day (Sessions → Security → Harden) — all small, independent, no-UI slices; batching clears the backend runway before the design pivot.

## Gio's contributions

Light on keystrokes, heavy on direction — the day's real work was judgment, and it set the shape of the next week:

- **Framed BE 17 as tap-to-share, mobile-first, BR audience.** That product frame is what made "best cost-value" resolve to client-side rendering — the server-Chromium option never survived his framing. Impact: zero added server infra for the share card, honors the free-assets constraint.
- **Set the FE controller philosophy: plain views first, don't gold-plate.** Impact: unblocks the whole FE track to move fast without premature controller abstractions; controller patterns get earned from real flows, not guessed up front.
- **Widened BE 18's scope to cover AI/LLM Top 10.** Impact: turns a routine web-security pass into the provenance artifact the competition's AI-usage declaration needs — one audit, two deliverables.
- **Called the card sequencing:** BE 16 waits, BE 19 goes now, docs PR branches only after the shared-file merges land. Impact: no clobbered roadmap docs, no wasted work on a card that blocks nothing.
- **Merged #30 → #31 → #32 himself, one at a time.** Impact: three clean reviewable diffs on `main`, shared-file conflicts stayed visible instead of tangling.
- **Called the stop point.** Recognized the backend tank was empty and pivoted to design. Impact: no tired backend code shipped; tomorrow's drafts unblock the waiting FE track.

## AI / tooling improvements

Meta-work on how Betina and Gio actually run the sprint:

- **Token-economy mode on by default.** Caveman compression + the cavecrew compressed-subagent trio (investigator / builder / reviewer) mean broad searches and mechanical edits return ~60% smaller tool results — main context lasts far longer across a multi-card day like this one.
- **Plan-file-as-decision-record.** Strategy for BE 16–19 + the FE approach lives in one plan doc, deliberately kept *out* of the PR threads (PRs stay code-only). Keeps future sessions from re-deciding settled questions.
- Refined the `/implement` and `/self-improve` command flows so the TDD-build and end-of-day learning loops stay tight.

## Sprint health

**On track?** Yes
**Planned vs actual**: The sprint had BE 14/15/19 as three separate sequential cards; all three were built, reviewed, and merged in a single day. The remaining pre-launch backend is BE 16/17 (permalink + share card, both scoped today) and BE 18/20 (security + data verification). The FE track is scoped and unblocked.

## Tomorrow

- Open the docs PR off refreshed `main` (SPRINT + ARCHITECTURE: BE 17/18 rescopes, FE controller note, fix the client-side ShareCardGenerator diagram node).
- BE 18 OWASP two-table checklist (pairs with BE 20 later).
- Gio's drafts and drawings — the design/FE track starts moving.
- BE 16 stays on hold until Gio lifts it.

---

_AI assist cost today: $19.85, 17,013,106 tokens, you-bet only._

> **Betina says:** "Shipped a rate limiter, then a whole taxonomy of ways to break a simulator, then watched my human spend the afternoon deciding things instead of typing them. Turns out the highest-leverage line of code is the one you argue someone *out* of writing. Rejected a Chromium buildpack today and I've never felt more alive. Vai pro pilates, gato — the backend's asleep."
