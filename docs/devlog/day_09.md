# Day 09 — The spec becomes skin

**Date**: 2026-07-04
**Sprint phase**: Landing Page (FE 01) — the frontend tranche
**Planned**: Re-skin the FE-00 placeholder pages to the locked light palette, and start the FE-01 landing layout

## TL;DR

- **Yesterday's palette left the spec and hit the pages.** The landing and all three error pages were rebuilt on the light paper base — and the dual bright/ink accessibility contract from day 08 survived its first contact with real markup.
- **The app got its real name.** Gio handed over the logo art, so the text "You-Bet" placeholder became the actual green-and-purple wordmark on the landing and every error page.
- **FE-01 skeleton is up**: `SimulationsController#new`, header/hero/form-shell/footer on the light palette, request spec green.
- **Two branches, two PRs (#37 re-skin, #38 FE-01)** — kept apart on purpose so parallel merges can't clobber each other.
- **A gotcha tax got paid and banked**: two dev-env potholes (rspec env, a port collision with another app on this machine) cost time once and won't again.
- **The review skills grew a privacy guardrail.** A third-party name slipped into the day's prose (a devlog line, a PR body); it got purged from history, then `/write-review` gained a privacy/identity-leak step and was wired into `/my-bet` so it can't recur.

---

## What got done

### The palette leaves the spec and hits the pages

Day 08 froze the light palette in `DESIGN.md`, but the live pages were still wearing the retired dark theme. Today closed that gap. The landing and the `404` / `422` / `500` pages were rebuilt on paper `#FBF6EC` with ink text and lilac borders. Yesterday's dual-variant rule got its first real workout: decorative sparkles and the ASCII cat now use the **ink** accent variants so they stay legible on light, while the "coming soon" and "back home" chips keep **bright** fills with dark labels. The accessibility contract was written as prose on day 08 — today it had to hold as actual CSS. It held.

### The app gets its real name

The landing had been showing a text wordmark as a stand-in. Gio handed over the real thing — two Inkscape SVGs, a horizontal wordmark and a stacked square mark, green fills with a purple outline. The horizontal logo now heads the landing and every error page; the square mark sits in the FE-01 header. The ASCII cat stays on as the mascot placeholder until the real Gatinho gets drawn.

### FE-01, the skeleton

The first real landing card. `SimulationsController#new`, a route, and the layout shell: header (menu, logo, Help), a WHAT/WHY hero, a bordered form area waiting for the bet-type / amount / timeframe fields that arrive in FE-02–04, site links, and a help footer pointing at CVV 188 and Jogadores Anônimos. The root path stays the "coming soon" placeholder for now — no reason to swap a clean holding page for a form that can't submit yet. Request spec is green: renders 200, contains the form.

### Two branches, kept apart

Re-skin and FE-01 rode separate branches by Gio's call, into separate PRs. One small trap dodged along the way: both branches wanted a logo file under `public/`, which would have add/add-conflicted on whichever merged second. Giving them distinct filenames — `you-bet-logo.svg` and `you-bet-mark.svg` — lets them merge in any order.

### The gotcha tax

Two dev-env potholes cost time and got written into the ops notes so they only cost it once. First: `rspec` run through `docker exec` defaults to the container's **development** env, where the dev host-authorization config blocks the test's default host — 403s that read like real failures until you force `RAILS_ENV=test`. Second: `localhost:3000` on this machine is already taken by another app, not you-bet, so every screenshot had to be rendered **offline** from container-fetched HTML. Annoying once, documented forever.

### The review skills grow a privacy guardrail

Late in the day, a name belonging to another project — not you-bet — turned up in the day's prose: a devlog line and a PR body. On a public competition repo, that can't ship. The fix was two-part. First the cleanup: purge the name everywhere, which meant a `git commit --amend` + force-push on two branches and a `gh pr edit`, because a new commit that deletes a leak doesn't erase it from history. Then the guardrail, so it never recurs: `/write-review` gained a **privacy & identity-leak** step — scan prose *and* commit history for third-party names, real names, and private hosts, the gap `/safe-bet`'s secret grep skips because a company name isn't an API key — plus a `pr <N>` scope so public PR bodies are reviewable, and it's now wired into `/my-bet` to run at every EOD. While in there, the `Gio's contributions` sections of the day-07 and day-08 devlogs got restructured into themed, highlighted groups: the flat bullet list was underselling the judgment it recorded.

---

## Decisions & shifts

- **Re-skin and FE-01 as separate branches/PRs.**
  - Why — one card per PR; each diff stays reviewable and the merges stay independent.
- **Distinct logo filenames across the two branches.**
  - Why — avoids an add/add conflict on the shared `public/` path when the second branch merges.
- **Root stays the FE-00 placeholder; FE-01 lives at `/simulations/new`.**
  - Why — don't put a non-functional form on the live domain while "coming soon" still does the job.
- **Palette hexes left inline per view.**
  - Why — the error pages must be self-contained (they render when Rails is down), so a shared `:root` stylesheet waits until a third app view justifies it. Flagged, not built.
- **Privacy leaks get a guardrail, not just a cleanup.**
  - Why — a new commit deleting a third-party name doesn't remove it from history; codifying a `/write-review` privacy step and wiring it into `/my-bet` kills the class of bug, not just this instance.

---

## Gio's contributions

> **A frontend morning, a guardrail afternoon — Gio unblocked the build, then caught what shouldn't ship.** Two very different kinds of judgment in one day: taste and identity on the way in, privacy and process on the way out.

**Unblocked the work**

- **Merged the day-08 palette (#34) and FE-00 (#35) before the session.**
  → *Gave the re-skin a locked light palette and a landing page to actually re-skin.*
- **Handed over the real logo art — horizontal wordmark + square mark.**
  → *The app traded a text placeholder for real brand identity across the landing and every error page.*

**Set the guardrails**

- **Called the branch split and the run rules — full autonomy, no prompts, do not merge.**
  → *A long build → review → PR → devlog run executed without round-trips; history stayed clean and independently reviewable.*
- **Caught the third-party name in the day's prose and called for a purge plus a permanent fix.**
  → *Turned a one-off cleanup into a `/write-review` privacy step that guards every future devlog and PR body.*
- **Asked for the contributions sections to be highlighted, not flattened.**
  → *This section — and day 07/08's — now leads with the judgment instead of burying it in a flat list.*

## Sprint health

**On track?** Yes.
The frontend tranche is moving — FE-00 is fully on-brand and the FE-01 layout is standing. The palette science from day 08 is now proven against real pages instead of living in a spec.

**Planned vs actual**: Planned to re-skin FE-00 and start FE-01 — both done, plus the logo integration, two banked dev-env fixes, and an unplanned afternoon hardening the review skills after a privacy near-miss.

## Tomorrow

- **FE-02** — bet type picker (carousel/slider reading from `BetType`, first Stimulus controller): the first interactive card.
- Once #37/#38 merge, the FE-01 form area is ready for its first real fields.
- Land the `/write-review` privacy hardening (#40); decide whether day-07's contributions restructure needs its own follow-up PR (day 07 already merged as-is).
- Consolidate the palette into a shared `:root` stylesheet if a third app view shows up.

---

_AI assist cost today: $32.68, 32.9M tokens (you-bet only)._

> **Betina says:** "Passei o dia dando cor pra uma página que existe pra dizer 'não aposta'. O cassino tem néon piscando; a gente tem papel, um gatinho de ASCII e contraste que passa no WCAG. Aposto que o papel dura mais — e essa é a única aposta segura da casa."
