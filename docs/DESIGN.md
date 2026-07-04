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
| `--color-bg` | `#FBF6EC` | Page background — warm paper |
| `--color-surface` | `#EDE9E2` | Cards, containers, elevated elements — de-yellowed neutral |
| `--color-border` | `#DFC3DA` | Borders, dividers — lilac |
| `--color-text` | `#3B3239` | Primary text — warm near-black ink |
| `--color-muted` | `#6E6358` | Secondary text, captions, labels |

### Pop accents (rotate per element — no two adjacent cards same color)

Each accent has two variants: **bright** (fills, borders, big numbers — always paired with a dark label) and **ink** (the only variant legible as *text* on the light base). See Accessibility.

| Token | Bright | Ink (text) | Usage |
|---|---|---|---|
| `--color-coral` | `#EC6258` | `#AA473F` | Primary CTA, loss numbers, Gatinho accent |
| `--color-cyan` | `#6FE0CD` | `#377066` | Links, help resources, secondary actions |
| `--color-green` | `#64D444` | `#367225` | Gain numbers, positive outcomes |
| `--color-purple` | `#9D64D4` | `#8152AE` | Context stats, emphasis variety |
| `--color-yellow` | `#F4BB5C` | `#7F6130` | Highlights, warnings, warm attention |

Light tints (fills / backgrounds only, never text): `mint #A2EAC7`, `light-green #B4F6AD`, `light-purple #BD8EEC`, `salmon #F19D86`, `soft-yellow #F4D46C`.

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

1. **Body text = ink `#3B3239`** on paper/surface (11.5:1 / 10.2:1 — AAA). Pure black `#000000` is reserved for the logo outline and max-emphasis only, not body copy.
2. **Muted `#6E6358`** = secondary text only, **≥16px** (4.8:1 — AA, no margin below that size).
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

---

## Texture

- **Grain/noise overlay** on page background — high-priority nice-to-have (see SPRINT.md). Preferred implementation is a native SVG `feTurbulence` fractalNoise rendered to a `data:` URI CSS background: no asset, no gem, tileable, resolution-independent. Low opacity (`0.03–0.07` on the light base) with `background-blend-mode: multiply` to keep the warm tone. The same overlay is reused as a layer on BE 17 share cards.
- **Drop shadows** on all cards, buttons, hero text — hard offset, not soft blur
- **Hard square borders** — no border-radius anywhere

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

Footer-anchored. Muted text with cyan-**ink** (`#377066`) links to CVV 188, Jogadores Anônimos — ink variant so link text stays AA-legible on the light base.

---

## Gatinho Mascot

- Drawn by Gio (Procreate/Inkscape)
- Appears: footer, share cards, empty states, error pages
- Counterpoint to Tigrinho — friendly, knowing, not predatory

---

## Assets & Constraints

- **Fonts**: Google Fonts only
- **Icons**: Streamline Free or emoji
- **Images**: Gio's illustrations only, no stock
- **No paid assets** of any kind

---

## Preview

`docs/palette-compare.html` — open in browser to see the locked light palette beside the old dark set, with live WCAG contrast badges on every token. Local dev reference, not part of the app build.
