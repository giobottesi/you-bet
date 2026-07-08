# Day 12 — Fix the paper, then price the bet

**Date**: 2026-07-07
**Sprint phase**: Landing Page (FE cards)
**Planned**: FE-03 (weekly amount input) was the board card. It shipped in the afternoon — but the morning got hijacked by an unplanned palette fix: the colors had quietly drifted, and one look at the real cards proved it. Two acts, one day.

## TL;DR

- **Morning — palette rescue.** The light palette had gone **muted and yellow** — every accent desaturated, the green tilted toward yellow, the "ink" turned cold magenta, cards washed out under a near-white `#FFFDF8`. Pulled the true values back off the `vibe.svg` board, de-yellowed the base, re-saturated the accents, re-derived AA-passing ink text variants.
- Chased a real **paper texture** across half the morning — notebook lines → a sandpaper misfire → a warm hatch-plus-noise that finally reads as paper, not stripes.
- Replaced the boxed `CASA %` badges with a **hand-swiped highlighter marker**, and stood up a documented **trinket system** (whimsy-vs-importance zones + a catalog with placement rules). Took a correction on **over-autonomy in design** — turned the whole back-and-forth into living preview docs.
- **Afternoon — FE-03 shipped (PR #59).** The weekly-amount step: four DataSenado spending-tier radio cards (R$12/25/50/125) plus a custom reais field, a `weekly-amount` Stimulus controller, en/pt-BR keys, helper + request specs. Second of the form's steps, in the FE-02 bet-card idiom.
- **Native `required` over JS** — a radio group expresses "pick one" for free, so the controller only owns what the platform can't: reais→cents sync and the above-zero check. Design pass shipped **dot-pop parity** with FE-02; the cool→hot spend-ladder ramp got **parked** pending a DESIGN.md nod.

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

### FE-03 — pricing the bet (PR #59)

With the base clean, the afternoon went to the planned card: *how much a week?* The scaffold followed the FE-02 shape — flat partial, per-section Stimulus controller, `@theme` tokens — so the shape was known; the questions were about validation and copy. Four DataSenado spending-tier anchors (R$12 / R$25 / R$50 / R$125) render as radio cards, a sibling of `.bet-card`: paper, accent-on-select, and an `amount-pop` beat so the dot springs like the FE-02 checkmark (reduced-motion suppresses it). A custom reais field lets people name their own number.

The validation split fell out of the platform's own grain: a radio group already means "pick exactly one," so native `required` on the shared `weekly_amount_cents` group carries that constraint for free — where FE-02's ≥1-checkbox case had to hand-roll it with `setCustomValidity`. The Stimulus controller only owns what HTML can't: typing in the custom field selects its radio, syncs reais→cents, and — the one spot FE-03 still reaches for `setCustomValidity` — blocks submission until that custom amount clears zero. Helper specs cover the anchor map and the `R$12` label; request specs assert a required radio per anchor plus the custom row. The form's still unwired (`url: "#"`) — binding `weekly_amount_cents` to a persisted attribute is a later BE card.

---

## Decisions & shifts

- **`vibe.svg` is the palette source of truth**, superseding the earlier sampled hex.
  - Why — the sampled set had drifted muted-and-yellow; the board is the ground truth.
- **Design refinements get proposed, not inferred.**
  - Why — auto-picking tones and texture params burned iterations and drifted; taste is Gio's call. Options now ship as rendered previews.
- **Trinkets are a documented system, not ad-hoc flourishes.**
  - Why — whimsy is load-bearing but must never compete with the primary action; constraints keep it honest.
- **Grain lives on all paper**, with a stacked-paper-piles refinement parked for later.
- **FE-03 leans on native `required`, not JS validation.**
  - Why — a radio group encodes "pick one" natively; hand-rolling it in Stimulus would duplicate the platform. The controller keeps only the reais→cents sync and above-zero guard.
- **Spend-ladder accent ramp parked, card-hierarchy flip dropped.**
  - Why — the cool→hot ramp bends the locked no-adjacent-clash accent rule, so it needs a DESIGN.md nod first; leading each card with the human comparison over the R$ hurts scan-ability, so it lost the trade. Dot-pop parity shipped; the rest waits.

---

## Gio's contributions

**Two-act direction day: Gio drove every design call in the morning, then set the validation and scope guardrails on FE-03 in the afternoon.**

**Product & taste (palette):**
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

**Validation & scope (FE-03):**
- **Kept validation on native `required`, off JS** → the controller owns only the reais→cents sync and above-zero guard, nothing the platform already does.
- **Parked the cool→hot spend ramp behind a DESIGN.md nod, dropped the card-hierarchy flip as a weak trade** → dot-pop parity shipped clean; the rule-bending polish waits for an explicit call instead of sneaking in.

## Sprint health

**On track?** Yes.
Two acts landed: an unplanned palette-drift fix that would have compounded across every future card, and the planned FE-03 card on top of it. Three of five Landing Page cards are now done.

**Planned vs actual**: FE-03 was the plan and shipped (PR #59, open for review) — plus the morning's unscheduled palette correction and trinket system. FE-03/04 inherit the clean, documented base the morning bought.

## Tomorrow

- Review + merge #59 (FE-03) and #57 (this devlog); the palette/trinket PR runs clean.
- FE-04 (timeframe slider) off fresh `main` — same house style (flat partial, per-section Stimulus, `@theme` tokens, i18n via values).
- Optional: the parked spend-ladder ramp, if the DESIGN.md nod comes; extend grain into stacked-paper-piles when there's slack.

---

_AI assist cost today: $31.91, 30,653,993 tokens (you-bet only)._

> **Betina says:** "Fixed the paper so it feels handmade, then spent the afternoon pricing how much someone bets a week — R$12, R$25, R$50, R$125, the DataSenado ladder of small money that never feels like much until you stack fifty-two of them. Two acts, same lesson as the palette: it's the small weekly drift you don't clock that quietly takes the whole year."
