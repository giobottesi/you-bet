# You-Bet — Design Spec

Status: **LIVE — light palette locked (WCAG-verified, 2026-07-03), fonts still placeholder**

---

## Direction

Festival zine meets data dashboard with pop art / pixel art energy. Warm **light** paper base with saturated color pops that rotate per element — not monotone, not financial. Hard square borders, drop shadows, grain/noise texture. Anti-Tigrinho: welcoming, playful, not aggressive.

**References**: competition kit (palette seeds, poster aesthetic), Gio's "Guia do Festival" zine (warmth, hand-lettered feel), composer.trade (big number hero), timespent.so (data viz), @cigarrogratuito (satirical marketing critique angle).

---

## Color Palette

All colors are Tailwind CSS custom properties — one-file swap. Light theme, warm paper base. Hex values are locked (for now) — sampled from Gio's palette board and WCAG-verified.

### Base (warm light)

| Token | Hex | Usage |
|---|---|---|
| `--color-bg` | `#F8F6F2` | Page background — low-sat warm paper (not cream wash) |
| `--color-surface` | `#EDE8DE` | Elevated neutral — de-yellowed |
| `--color-border` | `#DFC3DA` | Borders, dividers — lilac |
| `--color-text` | `#1E1714` | Primary text — warm brown-black ink |
| `--color-muted` | `#7E6E5D` | Secondary text, captions, labels |
| `--color-card` | `var(--color-bg)` | Cards = page paper; border + shadow define them (no wash) |

### Pop accents (rotate per element — no two adjacent cards same color)

Each accent has two variants: **bright** (fills, borders, big numbers — always paired with a dark label) and **ink** (the only variant legible as *text* on the light base). See Accessibility.

| Token | Bright | Ink (text) | Usage |
|---|---|---|---|
| `--color-coral` | `#FF5550` | `#E00700` | Primary CTA, loss numbers, Gatinho accent |
| `--color-cyan` | `#2DE3CD` | `#117E71` | Links, help resources, secondary actions |
| `--color-green` | `#15D718` | `#0D820F` | Gain numbers, positive outcomes |
| `--color-purple` | `#A661DB` | `#9848D5` | Context stats, emphasis variety |
| `--color-yellow` | `#FFB846` | `#9E6100` | Highlights, warnings, warm attention |

Light tints (fills / backgrounds only, never text): `mint #8BEDC4`, `light-green #A0F8A5`, `light-purple #C68CF2`, `salmon #FF9881`, `soft-yellow #FAD257`.

Bright accents match the `vibe.svg` source board (neon/pop). Only `coral` (2.9:1) and `purple` (3.6:1) approach UI-contrast on bg — the rest are **fills only**, legibility carried by the dark border/outline, never used as text.

### Semantic

| Token | Maps to | Usage |
|---|---|---|
| `--color-gain` | `--color-green` (ink for text) | Profit numbers — appears rarely and small |
| `--color-loss` | `--color-coral` (ink for text) | Loss numbers — appears often and big |

### Rules

- Loss color appears MORE than gain — this is the point
- Each card/stat rotates through accent colors — pop art energy
- Background is always light paper, no dark mode (dark mode is a nice-to-have)
- Hard drop shadows (`3-4px` offset, solid black 25-30% opacity) on cards and buttons

### Accessibility (WCAG 2.1, non-negotiable)

Every pairing below was contrast-checked. Rules, in priority order:

1. **Body text = ink `#1E1714`** on paper/surface (16.4:1 / 14.5:1 — AAA). Pure black `#000000` is reserved for the logo outline and max-emphasis only, not body copy.
2. **Muted `#7E6E5D`** = secondary text only, **≥16px** (4.55:1 bg — AA, drops to 4.0:1 on surface so keep it off cards).
3. **Accent as text** on the light base MUST use the **ink** variant (all ink variants ≈4.6–4.8:1 AA). The **bright** variants FAIL as text on light (1.0–3.3:1) — never use them for text.
4. **Accent fills** (buttons, badges) keep the **bright** hue with a **black/dark label** (5.2–14.5:1). A cream/paper label on any fill FAILS — never do it.
5. **Never** put text on the lilac border color, and never layer paper/cream on lilac (1.3:1 FAIL).
6. On the `surface` shade, saturated bright purple/coral drop toward AA-large — for body-size text always use their ink variants.

---

## Typography

**Gio decides fonts.** Three slots to fill:

| Slot | Usage | Placeholder |
|---|---|---|
| `--font-display` | Hero numbers, R$ values, big impact text | Anton |
| `--font-heading` | Section headers, card titles | TBD by Gio |
| `--font-body` | Body text, labels, descriptions | Libre Franklin |

### Scale (sizes are stable, fonts swap in)

| Name | Size | Line height | Slot |
|---|---|---|---|
| `hero` | 4rem (64px) | 1.0 | display |
| `title` | 2.5rem (40px) | 1.1 | display |
| `h1` | 2rem (32px) | 1.2 | heading |
| `h2` | 1.25rem (20px) | 1.3 | heading |
| `body` | 1rem (16px) | 1.5 | body |
| `small` | 0.875rem (14px) | 1.4 | body |
| `caption` | 0.75rem (12px) | 1.3 | body |

### Rules

- Numbers are ALWAYS big. R$ values use `display` at `hero` or `title` size
- Display font has `text-shadow` for depth (drop shadow on type)
- Constraint: Google Fonts only (free)

### `--font-heading` candidate (from #47 spike — needs Gio call)

The magicagem spike (PR #47, not-to-merge) used **Caveat** — a Google Fonts hand-lettered script — for headings/wordmark. It fits the "Guia do Festival" hand-lettered reference and is free/Google-hosted. Logged as a candidate for the still-TBD heading slot. Caution: Caveat reads soft/casual and may undercut the pop-art punch, so it's Gio's call. (The spike paired it with Quicksand for body, but body is already locked to Libre Franklin — not up for revisit.)

---

## Texture

- **Grain/noise overlay** on page background — **locked as the app texture** (see SPRINT.md). Native SVG `feTurbulence` fractalNoise rendered to a `data:` URI CSS background: no asset, no gem, tileable, resolution-independent. Tested recipe (`docs/texture-compare.html`): `baseFrequency='0.65'` + `numOctaves='3'` for coarse grain that survives on-screen (fine high-freq noise aliases to flat gray), a `feColorMatrix` collapsing the RGB noise to contrasty black-alpha speckle, over the light base with `mix-blend-mode: multiply`. Opacity `~0.12–0.25` (0.05 reads as invisible over the warm paper). The same overlay is reused as a layer on BE 17 share cards.
  - *Refinement (2026-07-06):* on **cards**, the grain is a fine fiber **hatch + a whisper of warm noise** (see the Paper-grain row in the Trinket catalog) — the two layers overlap so it reads as texture, not stripes, and the warm tint avoids grey striping. Extends to panel/page when "grain on all paper" lands.
- **Drop shadows** on all cards, buttons, hero text — hard offset, not soft blur
- **Hard square borders** — no border-radius anywhere
- **Dot-grid** (from #47 spike) — **not for this app.** `background-image: radial-gradient(<color> 1px, transparent 1px); background-size: 24px 24px;`. Asset-free and tileable like the grain, but a repeating *pattern* not *noise*. Decision (Gio call, 2026-07-06): grain wins for You-Bet; the dot-grid is reserved for a separate private magicagem-blog project, not tracked here. Retained as a comparison lane in `docs/texture-compare.html`.

---

## Layout

- Mobile-first, single column
- Max width: `48rem` (768px) — narrow and tall, like a zine page
- Horizontal padding: `1.25rem` mobile, `2rem` desktop
- Vertical rhythm: `2rem` between sections
- No wide-screen layout — vertical scroll, phone-first

| Breakpoint | Width | Notes |
|---|---|---|
| mobile | < 640px | Single column, stacked cards |
| tablet | 640px+ | Comparison cards 2x2, stat cards 2x2 |
| desktop | 768px+ | Max-width container, centered |

---

## Components

### Timeframe Cascade

Each period is its own card. Loss number grows as timeframe increases (font size scales up). Loss color deepens across the cascade.

### Comparison Cards

2x2 grid on tablet+, stacked on mobile. Each card gets a different accent color border + label. Last card is always poupança.

### Context Stat Cards

2x2 grid. Each card gets a different accent color for the big number. Pop art rotation.

### CTA Button

Full-width on mobile. Primary accent bg, dark text. Hard drop shadow. Square corners.

### Radio Cards (spending tiers)

Full-width, stacked. Selected state: accent-colored border. Unselected: border color.

### Help Bar

Footer-anchored. Muted text with cyan-**ink** (`#117E71`) links to CVV 188, Jogadores Anônimos — ink variant so link text stays AA-legible on the light base.

---

## Whimsy patterns (harvested from the #47 spike)

Concrete, reusable treatments pulled from the magicagem palette spike (PR #47, not-to-merge). Only the brand-agnostic *mechanics* are kept — the spike's soft pastel/rounded/blurred look is deliberately **not** adopted (rounded corners and soft-blur shadows contradict the locked hard-square, hard-shadow direction).

- **Corner sparkles** — absolutely-positioned `✦`/`✧` glyphs tucked into a container's corners, each in a *different accent **ink** variant* (cyan/yellow/purple/coral ink). Cheap pop-art energy, no asset, and using ink variants keeps the glyphs on-palette and AA-legible on the light base. Use sparingly — hero and empty states, not every card.
- **Accent rotation by index** — the locked "no two adjacent cards share a color" rule, implemented: cycle the border/accent class by `index % <accent-count>` when rendering a card list. Deterministic, no per-card config.
- **Card hover lift** — `transform: translateY(-2px)` on a `~0.15s` transition for clickable cards. Keep the *hard* drop shadow (don't swap to a soft blur as the spike did) — lift the card, not the shadow.

### Whimsy × Importance (governs every trinket)

Whimsy is cognitive lubricant, not decoration — but it must never compete with the primary action. Intensity scales **inversely** with an element's action-weight and frequency: the more critical or repeated the action, the quieter the decoration around it.

| Zone | Elements | Whimsy | Rule |
|---|---|---|---|
| **A · Action path** | CTA, inputs, bet-card *selected* state, result numbers | Low | Static, out-of-the-way only. No motion in the interaction path. |
| **B · Structural chrome** | card bodies, form panel, headings, labels | Medium | Static craft: grain, dog-ear, perforation, dashed borders. |
| **C · Ambient / low-stakes** | empty states, footer, results *reveal*, backgrounds, easter eggs | High | Free to play: animation, one-time celebration, easter eggs. |

### Trinket catalog

Asset-free CSS treatments (no gem, no image). A `trinket` Stimulus controller is planned for the animated/random ones — deferred until the first animated trinket lands; static ones stay pure CSS. Live options renderable in `docs/trinket-preview.html` + `docs/grain-texture.html`.

| Trinket | What | Where / constraint | Zone | Status |
|---|---|---|---|---|
| **Paper grain** | Fine fiber hatch (`2/3px`, `rgba(30,23,20,.045)`) + whisper of warm `feTurbulence` noise (`baseFrequency .5`, warm-tinted, `~.09` alpha). Noise + hatch **overlap** → reads as texture not stripes; warm tint avoids grey striping. Extracted to one `--paper-grain` custom prop, applied to body + panel + cards. Future: refine into stacked-paper-piles look (parked). | All paper surfaces | B | **Live** — body/panel/cards |
| **Highlighter marker** | Accent marker sweep behind text (`color-mix` ~60%, asymmetric feathered ends, `rotate(-1.2deg)`), dark ink text. Replaces dry boxed badges. **Static only** — animating per-hover annoys. | Over-informational labels (e.g. CASA%); one accent per card. | C-style, static | **Live** on CASA% |
| **Perforation** | Betting-slip edge notches — side-stub take (dashed tear + radial notches). | **Drop-shadowed** static boxes only (reads as a physical slip). Never on interactive cards. | B | Parked → result slips |
| **Washi tape** | Translucent pinned-tape strip. | **Flat / non-shadowed** surfaces only — a hard drop-shadow contradicts pinned tape. | B | Parked → landing |
| **Dashed border** | Draft / coming-soon / placeholder device. | Section placeholders, future dividers. | B | Live (placeholders) |
| **Coin / confetti burst** | Celebration pop. | Results *reveal* only — **never on selection** (noisy, breaks the no-blame tone). | C | Future (Stimulus) |
| **Easter eggs** | e.g. Pepsi Black can + striped paper straw. | Hidden, low-stakes. | C | Future (Stimulus) |

**Hard rule — action-cards stay clean paper.** No tape/perf/dog-ear on interactive cards: decoration fights selection and movement. Decoration lives on static surfaces only.

---

## Gatinho Mascot

- Drawn by Gio (Procreate/Inkscape)
- Appears: footer, share cards, empty states, error pages
- Counterpoint to Tigrinho — friendly, knowing, not predatory
- ASCII/text-art Gatinho is an acceptable lightweight placeholder before the illustrated mascot ships (the old landing used a text-art cat) — swap to Gio's illustration once available

---

## Assets & Constraints

- **Fonts**: Google Fonts only
- **Icons**: Streamline Free or emoji
- **Images**: Gio's illustrations only, no stock
- **No paid assets** of any kind

---

## Preview

Local dev references — open in a browser (`file://…`), not part of the app build:

- `docs/palette-compare.html` — current light palette with live WCAG contrast badges on every token.
- `docs/trinket-preview.html` — trinket options (grain, natural dog-ear, perforation + tape on a static result-slip, highlighter).
- `docs/grain-texture.html` — grain overlap comparison (why lines alone read as stripes; the overlap that reads as texture).

---

## Design-refinement references (unreviewed)

Candidate texture/whimsy demos gathered 2026-07-06 for a later refinement pass — **not yet vetted for fit or license**. Reimplement from scratch rather than copy-paste (see licensing note below); treat these as inspiration only. Reviewed + annotated 2026-07-06 (fit verdict against the locked hard-square / hard-offset-shadow / `feTurbulence`-grain direction):

| Pen | What it does | Fit verdict |
|---|---|---|
| [cssparadise/gbMdgOR](https://codepen.io/cssparadise/pen/gbMdgOR) | **Paper-radio group** (Uiverse, pharmacist-sabot). Hidden native input; hand-drawn circle with double inset+offset shadow (`inset -2px -2px 0`, `2px 2px 0`); dot scales in with a bounce on `:checked`; accent recolor + label shift; hard border + `4px 4px 0` offset shadow + hover lift. | ✅ **Adopted — FE-02 bet-type picker.** Palette swapped to You-Bet accents (rotated per card), square corners, dropped the pen's scanline/`repeating-linear-gradient` texture (our grain is the locked `feTurbulence` overlay). |
| [aitchiss/QWKmPqx](https://codepen.io/aitchiss/pen/QWKmPqx) | **Sellotaped corners** — translucent tape strips pinned via `::before`/`::after` rotated `-45deg` over a paper sheet. Skeuomorphic "taped to the wall" look. | 🔶 Candidate for **share/results cards** as a whimsy accent (cousin of corner sparkles). Not for form UI. |
| [slimsmearlapp/DqVqPy](https://codepen.io/slimsmearlapp/pen/DqVqPy) | **Torn/curled paper edge** — two pseudo-elements with directional `box-shadow` + `rotate(135deg)` fake a lifted torn edge. | ⚠️ Uses **soft-blur** shadow — contradicts the locked hard-offset direction. Skip unless reworked to a hard edge. |
| [martinwolf/GRaWPy](https://codepen.io/martinwolf/pen/GRaWPy) | **Page-lift/curl corners** — `::before`/`::after` skewed + rotated with a blurred shadow underneath; sheet appears to peel off the surface. | ⚠️ Soft-blur lift, same conflict. Whimsy candidate only if hardened. |
| [BastianAndre/eBBvVz](https://codepen.io/BastianAndre/pen/eBBvVz) | **Lifted paper strips** — stacked sticky-note strips (`linear-gradient` fill) that rotate + lift on hover with a blurred drop shadow. | ⚠️ Soft-blur + rounded feel. Direction candidate for a list/stack layout only if reworked. |
| [shaders.paper.design/paper-texture](https://shaders.paper.design/paper-texture) | Paper's **WebGL paper-texture shader**. | ⚠️ Heavier than the locked asset-free `feTurbulence` grain; runtime cost. Refinement candidate only. |

**Licensing:** CodePen demos default to MIT unless the pen states otherwise, but many state nothing — legally ambiguous to lift verbatim into a public competition repo. Rebuild the technique in our own code. WebGL/shader options also carry a runtime cost the current asset-free grain avoids — weigh before adopting.
