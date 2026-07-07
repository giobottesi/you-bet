# Day 12 — Making the paper paper

**Date**: 2026-07-07
**Sprint phase**: Landing Page (FE cards)
**Planned**: Nothing scheduled — FE-03/FE-04 were next on the board. Today became an unplanned fix: the palette had quietly drifted, and one look at the real cards proved it.

## TL;DR

- The light palette had gone **muted and yellow** — every accent desaturated, the green tilted toward yellow, the "ink" turned cold magenta, cards washed out under a near-white `#FFFDF8`.
- Pulled the true values back off the `vibe.svg` board, de-yellowed the base, re-saturated the accents to their neon selves, and re-derived AA-passing ink text variants.
- Chased a real **paper texture** across half the day — from notebook lines, through a sandpaper misfire, to a warm hatch-plus-noise that finally reads as paper, not stripes.
- Replaced the boxed `CASA %` badges with a **hand-swiped highlighter marker**, and stood up a documented **trinket system** (whimsy-vs-importance zones + a catalog with placement rules).
- Took a correction on **over-autonomy in design** — and turned the whole back-and-forth into living preview docs.

---

## What got done

### The palette had been lying

A side-by-side against the source board showed it: the app's palette wasn't the `vibe.svg` neon set anymore. An HSL diff named the exact crime — every accent had lost 6–20 points of saturation, the green had rotated 14° toward yellow, and the ink had flipped from a warm brown-black to a cold magenta-grey. The cards sat on a `#FFFDF8` wash that read as bleached, not warm.

Fix was mechanical once diagnosed: reset each token to the board's values, drop the base saturation so `bg` reads as paper (`#F8F6F2`) instead of cream, restore the warm ink (`#1E1714`), and re-derive the ink text-variants darkened just enough to clear 4.5:1 on the light base. The card wash became a `--color-card` token instead of a magic literal hardcoded in three places.

### Killing the Windows 98 panel

De-yellowing the base surfaced the next offender: the form panel, a flat grey slab sitting six points darker than the page. It read like OS chrome. Lifting it to a low-saturation paper a whisper above the background — and letting the border, not a tonal jump, define its edge — put it back in the paper family.

### The long road to texture

The texture took the most iterations, and every one was a real signal, not thrash. Notebook lines read as *lines*. A fractal-noise pass at high frequency came out as **TV static** — plainer and grubbier, not richer. The fix was the opposite of intuition: keep the fine fiber lines, add a *whisper* of warm noise, and let the two layers **overlap** so the eye stops tracing stripes and reads texture. Warm-toned, not black — because black lines on paper just make grey. Extracted the whole thing to one `--paper-grain` custom property, now applied to body, panel, and cards alike.

### Trinkets, with rules

The badges looked too clerical, so `CASA %` became a highlighter marker — the card's own accent, dark ink text, feathered uneven ends and a slight tilt so it reads hand-swiped. That opened a broader question: where does whimsy belong without distracting from the actual decision? The answer got written down as a **whimsy-vs-importance map** (action path stays quiet, chrome gets craft, ambient zones get to play) and a **trinket catalog** — grain, highlighter, perforation, washi tape, dashed border — each with a placement constraint. The hard rule: interactive cards stay clean paper; decoration lives on static surfaces.

---

## Decisions & shifts

- **`vibe.svg` is the palette source of truth**, superseding the earlier sampled hex.
  - Why — the sampled set had drifted muted-and-yellow; the board is the ground truth.
- **Design refinements get proposed, not inferred.**
  - Why — auto-picking tones and texture params burned iterations and drifted; taste is Gio's call. Options now ship as rendered previews.
- **Trinkets are a documented system, not ad-hoc flourishes.**
  - Why — whimsy is load-bearing but must never compete with the primary action; constraints keep it honest.
- **Grain lives on all paper**, with a stacked-paper-piles refinement parked for later.

---

## Gio's contributions

**Direction day: Gio drove every design call, the AI just held the brush.**

**Product & taste:**
- **Pointed at `vibe.svg` as the real palette** instead of letting a stale sample stand → reset the whole system to ground truth.
- **Diagnosed the rot by feel — "muted, yellowish, and not just the bg"** → triggered the saturation/hue analysis that found all three drifts.
- **Named the "Windows 98 background"** → the panel lift.

**Precision feedback:**
- **"Reads grey, not paper — maybe bigger layers"** and later **"we lost the small overlapping aspect that reads as texture, not lines"** → the exact fix for the grain, in two sentences.
- **Brought a paper reference to mix from** → grounded the texture in a real look instead of guesswork.

**Judgment & guardrails:**
- **Called out over-autonomy on design refinements** → the process correction of the day, now a standing rule.
- **Set the trinket constraints** — tape not on drop-shadowed boxes, perforation *on* them, highlighter can retire an over-informational badge, action-cards stay clean → a coherent system instead of scattered effects.
- **Coined "trinkets"** and green-lit the highlighter, dropped the dog-ear, parked the stacked-paper idea → kept scope sharp.
- **Filed an easter egg for later** (Pepsi Black can, striped paper straw) → future Zone-C delight, logged not lost.

## Sprint health

**On track?** Yes, with an asterisk.
This wasn't a planned FE card — it was a palette-drift fix that would have compounded across every future card if left alone. Worth the detour; the design system is now documented rather than tribal.

**Planned vs actual**: FE-03/FE-04 were next; instead the palette got corrected and the trinket system got built and written down. FE-03/04 now inherit a clean, documented base.

## Tomorrow

- Review + PR the palette/trinket work (safe-bet already ran clean).
- Back to the board: FE-03 (weekly amount input) and FE-04 (timeframe slider).
- Optional: extend grain into the stacked-paper-piles look when there's a slow moment.

---

_AI assist cost today: $17.47, 18,813,287 tokens (you-bet only)._

> **Betina says:** "Spent a full day teaching a betting app's paper to look more like paper, which is either the most honest work I've done or the least — a warm off-white pretending to have fibers, so the numbers about how the house always wins land on something that feels handmade. We de-yellowed the palette by the same logic the app runs on: the small drift you don't notice is the one quietly taking everything."
