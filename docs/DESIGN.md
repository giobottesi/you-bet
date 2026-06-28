# You-Bet — Design Spec

Status: **LIVE — palette and fonts are placeholder tokens, Gio fills in final values**

---

## Direction

Festival zine meets data dashboard with pop art / pixel art energy. Warm dark base with saturated color pops that rotate per element — not monotone, not financial. Hard square borders, drop shadows, grain/noise texture. Anti-Tigrinho: welcoming, playful, not aggressive.

**References**: competition kit (palette seeds, poster aesthetic), Gio's "Guia do Festival" zine (warmth, hand-lettered feel), composer.trade (big number hero), timespent.so (data viz), @cigarrogratuito (satirical marketing critique angle).

---

## Color Palette

All colors are Tailwind CSS custom properties — one-file swap.

### Base (warm darks)

| Token | Hex (placeholder) | Usage |
|---|---|---|
| `--color-bg` | `#1F1714` | Page background — warm charcoal-brown |
| `--color-surface` | `#2A2119` | Cards, containers, elevated elements |
| `--color-border` | `#3D2E24` | Borders, dividers |
| `--color-text` | `#F5E6D3` | Primary text — warm cream, not white |
| `--color-muted` | `#A89585` | Secondary text, captions, labels |

### Pop accents (rotate per element — no two adjacent cards same color)

| Token | Hex (placeholder) | Usage |
|---|---|---|
| `--color-coral` | `#FF6B6B` | Primary CTA, loss numbers, Gatinho accent |
| `--color-cyan` | `#4ECDC4` | Links, help resources, secondary actions |
| `--color-yellow` | `#FFE66D` | Highlights, warnings, warm attention |
| `--color-purple` | `#C792EA` | Context stats, emphasis variety |
| `--color-mint` | `#A8E6CF` | Gain numbers, positive outcomes |
| `--color-tangerine` | `#FF8A5C` | Warm accent variety |

### Semantic

| Token | Maps to | Usage |
|---|---|---|
| `--color-gain` | `--color-mint` | Profit numbers — appears rarely and small |
| `--color-loss` | `--color-coral` | Loss numbers — appears often and big |

### Rules

- Loss color appears MORE than gain — this is the point
- Each card/stat rotates through accent colors — pop art energy
- Background is always dark, no light mode
- Hard drop shadows (`3-4px` offset, solid black 25-30% opacity) on cards and buttons

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

- **Grain/noise overlay** on page background (CSS or SVG filter)
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

Footer-anchored. Muted text with cyan-colored links to CVV 188, Jogadores Anônimos.

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

`palette-preview.html` in repo root — open in browser to see current palette + components. Not committed to git, local dev reference only.
