# Day 11 — Seven takes on a slider

**Date**: 2026-07-06
**Sprint phase**: Landing Page (FE cards)
**Planned**: FE 02 — bet type picker (carousel/slider, reads from `BetType`, Stimulus controller; all types render, at least one required)

## TL;DR

- FE-02 shipped and merged (#54): a multi-select **paper-checkbox slider** for the seven bet types.
- The picker went through roughly seven live visual takes — radios became checkboxes, a progress bar became arrows became edge-straddling arrows, edge fades were added and then killed, a tooltip was born and buried.
- i18n happened **along the way**, not later — the picker is fully localized (en + pt-BR), strings and all.
- The Stimulus controller got hardened to idiom: `ResizeObserver` over a window listener, targets over `querySelector`, names that say what they do.
- Two review-flow gaps Gio spotted became standing conventions and merged on their own (#55).

---

## What got done

### The picker, take by take

The card asked for a "carousel/slider" reading from `BetType`. The scaffold from #50 was already there — a stub partial, a stub controller, a slot in the form — so the job was to fill it in. The visual, though, is where the day actually went.

We started from a paper-radio treatment parked in `DESIGN.md` (a Uiverse pen), rebuilt it in the You-Bet palette with square corners and the locked grain, and laid the seven types out as a horizontal scroll-snap carousel with an accent rotating per card. Then the iteration began: single-select radios turned into multi-select checkboxes; the scroll affordance cycled through a progress bar, then arrows, then arrows that straddle the slider's edges to read as "there's more past here"; edge fades went in, looked like a rendering glitch on the last card, and came back out. Each turn was a screenshot from Gio and a one-line delta back.

### i18n, not later

Midway, the call: localize as we build, so there's less translation debt to reconcile later. Every picker string moved into `simulations.bet_type_picker` (en + pt-BR) — heading, hint, house-edge prefix, aria-labels — including the JS-side selection count and validity message, which ride in as Stimulus `values` so the copy stays in the locale files. What's left (the FE-01 hero, still English) got its own tech-debt card rather than a half-done sweep.

### Making the Stimulus controller reviewable

Gio's note on the controller was blunt and fair: Stimulus controllers are the worst to review. So we researched the conventions, fact-checked them, and reworked it — the window `resize` listener became a `ResizeObserver` on the carousel (catches reflows a window event misses), `sync` became `updateArrows`, every method got a one-line intent comment, and a stray `querySelector(".bet-card")` became a proper `card` target.

### Turning review notes into rules

Two of those lessons didn't belong to one PR. The PR description had drifted stale three times as the branch kept moving, and the Stimulus fixes were the kind of thing you want caught every time. Both became standing conventions — a "re-sync the PR body to the final diff" step in `/sure-bet`, and a Stimulus block in `/safe-bet` (Rails-idiomatic method names, one job each, `ResizeObserver`, i18n via values, targets over manual DOM) — on their own docs branch, merged as #55.

---

## Decisions & shifts

- **Multi-select bet types, not single.**
  - Why — Gio wanted people to pick every kind of bet they make. It collides with an engine that takes one `bet_type_key`; that decision was parked as a local note, not a tracked ticket, since it's FE-05/BE scope.
- **Killed the progress bar, the fades, and the tooltip.**
  - Why — the bar read as bulky, the fades as a glitch, and the tooltip was dead on touch (the app is mobile-first). Peek plus edge-straddling arrows carry the scroll cue on their own.
- **i18n along the way.**
  - Why — smaller translation cognition later. Localize each surface as it lands instead of one big deferred pass.
- **Review lessons codified, not just applied.**
  - Why — a stale PR body and an un-idiomatic Stimulus controller are recurring, not one-off. They belong in the gate, on their own branch.

---

## Gio's contributions

**Direction day: design by screenshot, and two of his own review notes became house rules.**

**Product & scope**
- **Made the picker multi-select.** → *Surfaced a real engine decision (one `bet_type_key` vs many) before FE-05 hit it blind.*
- **Called i18n as a build-along, not a phase.** → *Turned a looming full-page translation pass into small, per-surface work.*

**Design judgment**
- **Rejected the progress bar and the fades, wanted arrows that overflow the edges.** → *Landed on a scroll affordance that actually reads as scrollable.*
- **Caught the tooltip as mobile-hostile.** → *Killed a hover-only explainer that would never fire on touch.*
- **Steered the small things** — red instruction line, chevron that fills its box, smaller arrow box. → *The picker looks intentional, not defaulted.*

**Engineering & process**
- **Named the Stimulus review pain and pushed for Rails-idiomatic method names.** → *A controller that says what it does, plus a reusable convention for the next one.*
- **Asked to codify the PR-body re-sync and Stimulus rules.** → *One review turned into a standard every contributor now meets.*

## Sprint health

**On track?** Yes
FE-02 is merged with tests, i18n, and a hardened controller; two of the five Landing Page cards are now done.

**Planned vs actual**: Planned FE-02, shipped FE-02 — plus an unplanned but worthwhile detour codifying the review conventions it exposed.

## Tomorrow

- FE-03 — weekly amount input (radio cards on DataSenado anchors + custom field, Stimulus validation).
- Carry the paper-card + Stimulus patterns from FE-02 forward; they're now the house style for these widgets.

---

_AI assist cost today: $49.96, 53,602,982 tokens (you-bet only)._

> **Betina says:** "Sete versões de um botão de rolar. O tigrinho radicaliza a cabeça de alguém em milissegundos, e eu aqui debatendo se a setinha cabe na caixa. Mas é justo: se a gente vai dizer que a casa sempre ganha, o mínimo é que o botão pra descobrir isso seja bonito de doer."
