# Day 08 — Palette goes light, pages get faces

**Date**: 2026-07-03
**Sprint phase**: Landing Page (FE 01) + Polish (design system) — the frontend tranche day_07 scoped
**Planned**: Move off backend (tank was empty) into drafts, drawings, and the visual layer

## TL;DR

- **The palette flipped from dark-first to light.** Gio decided the pages should read light and warm, so the whole `DESIGN.md` color system was rebuilt on a paper base — and every pairing was WCAG-checked before it got written down.
- **Accessibility is now baked into the spec, not bolted on later.** Dual `bright`/`ink` accent variants, contrast ratios on every token, hard rules for what's legible where. Docs PR **#34** carries it.
- **Background grain/texture logged as a 🔴 high-priority nice-to-have** with a native `feTurbulence` recipe — no gem, no asset, reused later on BE 17 share cards.
- **The FE-00 landing page + branded 404/422/500 error pages landed** (Gio committed `eba552f`) — the app finally has a face and on-brand error states.
- **A light-code, high-judgment day**: most of the work was color science, taste calls, and a design freeze — Gio steered, Betina measured.

---

## What got done

### Palette, extracted then corrected

Gio dropped a screenshot of his palette board and asked for the tokens pulled out. First pass read the *labeled* hex box; Gio caught that the real colors were the swatches beside it, not the stale labels — so the palette got re-sampled straight from the pixels. Lesson banked: when a design board shows both a spec table and the actual swatches, trust the swatches.

### The accessibility audit that changed the theme

Every color pairing went through WCAG 2.1 contrast math. The dark-first set passed comfortably, but two truths fell out: cream text on any accent fill *fails* (1–2:1), and colored text on a light background fails just as hard. When Gio said "make the pages light," that second failure became the whole design problem — so accents got split into two variants: **bright** (fills only, always with a dark label) and **ink** (darkened enough to read as text on paper, ≈4.6–4.8:1 AA). Body text is warm near-black `#3B3239`; pure black is reserved for the logo outline.

### DESIGN.md rewritten, reviewed like prose

The spec was rebuilt around the light base — paper `#FBF6EC`, de-yellowed surface `#EDE9E2`, lilac border — with a non-negotiable Accessibility section. Then it went through `/write-review`: fact-checking caught a share-card reference pointing at the wrong card (FE 13 → BE 17) and a rounded contrast number, both fixed before commit.

### Texture, scoped not built

Gio wants paper grain on the background and as a layer on images later — but flagged it as *nice-to-have, high priority*, not today's work. Logged in `SPRINT.md` with the implementation already decided: native SVG `feTurbulence` fractal noise as a `data:` URI, low opacity, `background-blend-mode: multiply`. No dependency, tileable, reused on share cards.

### The app grows a face

Separately, the parked FE-00 work got committed: the landing page (`home#index`, +106 lines of view), branded 404/422/500 pages that shed ~400 lines of Rails boilerplate for something on-brand, plus the domain host-auth config. First real frontend on `main`'s doorstep.

---

## Decisions & shifts

- **Dark-first → light theme.**
  - Why — Gio's product call: the pages should feel warm and welcoming, the anti-Tigrinho posture reads better on paper than on charcoal.
- **Accents become two-variant (bright + ink).**
  - Why — the contrast audit proved a single bright hue can't serve as both a fill and readable text on light. One token, two jobs, two values.
- **Surface de-yellowed `#F1E7D7` → `#EDE9E2`.**
  - Why — Gio's eye: the cream read too yellow. Muted toward neutral without dropping below AA.
- **Palette frozen "for now."**
  - Why — good enough to build against; further bikeshedding is diminishing returns. Freeze unblocks FE work.

---

## Gio's contributions

> **Taste day: light on keystrokes, heavy on judgment — six calls that set the whole visual foundation.** Contrast math can measure a color; it can't decide the pages should feel warm. That was all Gio.

**Product & taste calls**

- **Made the dark→light product call.** The pages should feel warm and welcoming — the anti-Tigrinho posture reads better on paper than charcoal.
  → *Redefined the design problem and forced the accessibility split that now protects every future page.*
- **Caught the surface reading too yellow — mute it.** `#F1E7D7` → `#EDE9E2`, neutral without dropping below AA.
  → *A warmer-neutral paper the contrast math alone would never have asked for.*
- **Confirmed dark near-black for body text.**
  → *Locked the one legible text option on light; kept pure black for the logo where it belongs.*

**Kept the work honest**

- **Caught the first palette extraction reading the stale labeled hex instead of the real swatches**, and pointed at the correct source.
  → *The whole downstream palette samples from the right colors — a wrong base here would have poisoned every token.*
- **Scoped background texture as a high-priority nice-to-have, not app debt.**
  → *Kept today focused while guaranteeing the grain lands dependency-free.*

**Shipped & set process**

- **Froze the palette, committed the FE-00 landing + error pages himself, and set the docs branch/push/review flow.**
  → *Turned a design exploration into shipped, reviewable artifacts (PR #34) and a landing page on the board.*

## Sprint health

**On track?** Yes.
Backend is done through BE 19; today pivoted cleanly into the design system and first frontend, which is exactly what day_07 scoped. The visual foundation is now specified and accessible before any page is styled.

**Planned vs actual**: Planned a move into drafts/drawings — delivered a full light-theme design system, an accessibility contract, the FE-00 landing + branded error pages, and a docs PR. Ahead of a "just sketching" day.

## Tomorrow

- Style the FE-00 landing against the locked light palette; mark FE 01 on the roadmap.
- Consider the texture NTH once a page exists to grain.
- Continue the FE track (FE 02 bet-type picker onward).

---

_AI assist cost today: $12.24, 11,433,342 tokens, you-bet only_

> **Betina says:** "Spent a Friday proving that cream text on a lime button is unreadable, which is also roughly how legible the odds are on a betting slip. We fixed ours. Boa sexta."
