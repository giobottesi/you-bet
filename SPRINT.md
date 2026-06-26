# You-Bet — Sprint Plan v1

**Duration**: 17 days | Jun 25 → Jul 12, 2026
**Purpose**: This is the initial sprint plan. Keep it as-is throughout the project to compare planned vs actual. Track reality in the devlog (`/diario`).
**Approach**: TDD throughout — tests are written with features, not after. No separate "testing phase."

---

## Sprint Phases

### Phase 0: Foundation (Days 1-2) — Jun 25-26

**Goal**: Deployable skeleton with CI, i18n, settings infra, anonymous sessions, security baseline

```
Tasks:
├── rails new you-bet (Postgres, Hotwire)
├── GitHub repo setup (MIT LICENSE, README, .github/workflows/ci.yml)
├── i18n config (pt-BR primary, locale toggle)
├── AppConstant model + Setting model (PaperTrail, data_source)
├── Seed data (all comparison prices, house edges, app constants)
├── VisitorIdentifiable concern + cookie/localStorage sync
├── Simulation + SimulationResult models + migrations
├── Rack::Attack rate limiting config
├── Initial Fly.io deploy (smoke test)
└── CLAUDE.md for the project
```

**Deliverable**: Empty app on Fly.io, CI green, settings seeded, visitor tracking active.

**Estimated**: 2 days

---

### Phase 1: Engine (Days 3-5) — Jun 27-29

**Goal**: Monte Carlo simulation running, tested, cached. TDD — tests first.

```
Tasks:
├── BetType value object (reads house edge + variance from settings)
│   └── TDD: test expected house edge values, variance categories
├── SimulationRunner service object
│   ├── TDD: test expected value calculation against known math
│   ├── Monte Carlo loop (1K sims × all 5 timeframes in one pass)
│   ├── TDD: test percentile extraction, profit percentages
│   ├── Poupança alternative calculator
│   │   └── TDD: test compound interest against manual calculation
│   └── Cache key generation + simulation_results storage
│       └── TDD: test cache hit/miss behavior
├── ComparisonPicker service (reads prices from settings, picks 3 random + poupança)
│   └── TDD: test filtering by loss amount, randomness, poupança always present
└── Verify math against known expected values (manual cross-check)
```

**Deliverable**: `SimulationRunner.call(bet_types:, weekly_amount_cents:)` returns correct, tested, cached results for all timeframes.

**Estimated**: 3 days

---

### Phase 2: UI Flow (Days 6-8) — Jun 30 - Jul 2

**Goal**: Full input → results flow working in browser. TDD on controller.

```
Tasks:
├── SimulationsController
│   └── TDD: test new → create → show flow, param validation, cache behavior
├── Landing page (two entry points: "never bet" / "already bet")
├── Step 1: Bet type selection (Turbo Frame)
├── Step 2: Weekly amount (data-based anchored radio buttons + custom input)
├── Results page
│   ├── Timeframe cascade (all 5 periods)
│   ├── 3 random comparison cards + poupança (inline, no expand — DEFERRED)
│   ├── Context cards (data-backed stats)
│   └── Help resources section (always visible)
└── Stimulus controllers (form nav, validation)
```

**Deferred from this phase (post-MVP):**
- Range fan visualization (P5→P95) — cascade numbers are enough
- "Ver todas" expand button — show 3+poupança inline, expand is trivial to add later

**UI design (Figma/Inkscape) runs in parallel:**
- Landing page layout
- 2-step input flow
- Results page cards + cascade
- Comparison card design
- Mobile breakpoints

**Deliverable**: Full flow working end-to-end. Ugly but functional.

**Estimated**: 3 days

---

### Phase 3: Share & Polish (Days 9-12) — Jul 3-6

**Goal**: Shareable permalinks, responsive design, visual polish, static pages

```
Tasks:
├── Shareable result permalinks (/s/:uuid)
│   ├── OG meta tags (title, description, image placeholder)
│   ├── Share buttons (WhatsApp, Instagram, Twitter — link sharing)
│   └── TDD: test permalink routing, OG tag rendering
├── Responsive design pass (mobile-first)
│   ├── Apply Figma/Inkscape designs
│   ├── Touch-friendly inputs
│   ├── Card layouts for small screens
│   └── Test on Chrome Android + Safari iOS
├── /sources page (data documentation with citations)
├── /about page (AI declaration + developer story)
├── /privacy page (LGPD notice)
├── /diario page (devlog — daily journal entries)
├── Footer (AI badge, privacy link, help resources)
└── Visual polish (typography, colors, spacing)
```

**Deferred from this phase (post-MVP):**
- Shareable image card generation (HTML→image) — OG meta on permalink gives 80% of sharing value
- Image download button — add when image gen is ready

**Deliverable**: App looks good on mobile, results are shareable via link, all pages done.

**Estimated**: 4 days

---

### Phase 4: Harden & Ship (Days 13-15) — Jul 7-9

**Goal**: Production-ready, edge cases covered, deployed

Since we've been doing TDD throughout, test coverage already exists. This phase is about edge cases, performance, and verification — not writing tests from scratch.

```
Tasks:
├── Edge case tests (zero amount, extreme values, all bet types combined)
├── Performance check (simulation speed on Fly.io)
├── Accessibility pass (semantic HTML, contrast, screen reader labels)
├── Verify all context card stats against primary sources (pre-launch checklist)
├── Final Fly.io deploy
├── README polish (screenshots, how to run locally)
└── Smoke test full flow on production
```

**Deferred (post-MVP):**
- Data retention job (manual cleanup if needed for ~1 month of competition use)

**Deliverable**: App is live, edge-case-tested, accessible, data verified.

**Estimated**: 3 days

---

### Phase 5: Submit (Days 16-17) — Jul 10-11

**Goal**: Competition submission ready

```
Tasks:
├── Record demo video/reel of the app
├── Write submission caption with #DesafioContraBets
├── Declare AI usage in the post
├── Publish on public profile
├── Register link via competition form
├── Final devlog entry
└── Final sanity check on live app
```

**Deliverable**: Submitted.

**Estimated**: 1 day (buffer day Jul 12 if needed)

---

## Parallel Workstreams

```
         Jun 25──26──27──28──29──30──01──02──03──04──05──06──07──08──09──10──11──12
              │        │              │         │              │           │  │     │
 CODE    ████████ P0   ██████ P1     ██████ P2 ████████ P3    ██████ P4  █P5│     │
 (TDD)        │        │              │         │              │           │  │     │
 DESIGN       │   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │              │           │  │     │
              │   Figma/Inkscape: landing,      │              │           │  │     │
              │   steps, results, cards, mobile │              │           │  │     │
              │        │              │         │              │           │  │     │
 DEVLOG  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │     │
              daily entries throughout                                    │  │     │
              │        │              │         │              │           │  │     │
 CONTENT      │        │              │         │    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │     │
              │        │              │         │    Video/reel script + rec │     │
              │        │              │         │              │           │  │     │
 BUFFER       │        │              │         │              │           │  │ ████│
                                                                          Jul 12
```

---

## Scope Summary

### MVP (17 days)

| Feature | Phase | Days | Notes |
|---|---|---|---|
| Rails setup (Postgres, Hotwire, i18n scaffold, CI) | P0 | 1 | i18n PT-BR only, EN deferred |
| Settings + AppConstants (PaperTrail, seed, data_source) | P0 | 0.5 | |
| Security (Rack::Attack, CSP, UUID permalinks) | P0 | 0.5 | |
| Anonymous sessions (cookie + localStorage) | P0 | 0.5 | |
| Monte Carlo engine + TDD (server-side, all timeframes, caching) | P1 | 2.5 | Tests built with features |
| ComparisonPicker service + TDD | P1 | 0.5 | |
| Input flow + TDD (2 steps, Turbo Frames) | P2 | 1.5 | |
| Results page (cascade, 3+poupança inline, context, help) | P2 | 1.5 | No fan chart, no expand |
| Shareable permalinks + OG meta | P3 | 0.5 | No image gen — link sharing only |
| Responsive design (mobile-first) | P3 | 2 | |
| Static pages (/sources, /about, /privacy, /diario) | P3 | 1 | |
| Visual polish | P3 | 0.5 | |
| Fly.io deployment | P0+P4 | 0.5 | |
| Edge cases + hardening + a11y | P4 | 2 | TDD coverage already exists |
| Data verification (pre-launch checklist) | P4 | 0.5 | |
| Submission video + submit | P5 | 1 | |
| **Total** | | **~15.5 days of work** |

**Buffer: ~1.5 days.** Comfortable.

### Deferred to Post-MVP

| Feature | Why deferred | Future effort |
|---|---|---|
| Range fan visualization (P5→P95 chart) | Cascade numbers work without it | ~1 day, standalone component |
| Shareable image card generation | OG meta gives 80% of sharing value | ~1 day, additive |
| EN translations | PT-BR audience, i18n scaffold ready | ~0.5 day, just add en.yml |
| "Ver todas" expand button for comparisons | 3+poupança inline is enough | ~0.25 day, trivial Turbo Frame |
| Data retention job | Manual cleanup for ~1 month use | ~0.25 day, cron task |
| Animated trajectory visualization | Visual polish, not core | ~1 day |
| "Compare bet types" mode | Feature expansion | ~2 days |
| Aggregate stats dashboard | Needs traffic first | ~1 day |
| User-facing modifier sliders | Settings infra ready | ~1 day |
| Dark mode | Nice to have | ~0.5 day |
| PWA | Nice to have | ~0.5 day |

---

## Open Questions

1. **CSS framework**: Tailwind (fast to build, heavier) vs Pico CSS (lightweight, semantic)?
2. **Chart library**: For range fan — CSS-only? Chart.js? Lightweight alternative?
3. **Image generation**: Shareable cards — server SVG? HTML-to-image? Simple HTML screenshot?
4. **Landing page**: Single page with scroll vs separate entry points?
5. **Domain**: Custom domain or Fly.io subdomain for MVP?
6. **Devlog format**: Static view partials per day, or YAML data rendered by a single view?

---

## How to Use This Document

This is the **plan as of Day 1**. Don't edit it as the sprint progresses.

Track reality in the devlog (`/diario` page in the app). At the end of the sprint, compare this plan to what actually happened:
- Which phases took longer/shorter than estimated?
- What was added that wasn't planned?
- What was cut?
- What surprised us?

This comparison is part of the `/about` page story — showing the real process behind AI-assisted development.
