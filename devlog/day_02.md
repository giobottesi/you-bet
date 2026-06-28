# Day 02 — Branding, architecture overhaul, first code

**Date**: 2026-06-26
**Sprint phase**: BE 01 (Foundation)
**Planned**: Review docs, `rails new`, start Phase 0

## TL;DR

- Gio reviewed all docs, caught duplications and inconsistencies → trimmed PROPOSAL, overhauled ARCHITECTURE with 8 structural decisions
- Analyzed 40+ design references including Gio's personal art → locked design direction: "festival zine meets data dashboard", Gatinho mascot (anti-Tigrinho)
- Rewrote SPRINT as 43 card-based vertical slices with BE/FE/SUB split
- Got Rails 8.1.3 running in Docker with Tailwind — first PR open
- Squashed git history to remove exposed security details

---

### Morning — Doc review & cleanup

Gio reviewed PROPOSAL, ARCHITECTURE, and SPRINT with fresh eyes. Found real problems:

- **Duplications**: bet type house edges in both PROPOSAL and ARCHITECTURE, Tigrinho caveat twice within PROPOSAL, cache key formula twice within ARCHITECTURE
- **Inconsistencies**: ShareCardGenerator shown as active in ARCHITECTURE but deferred in SPRINT. "Ver todas" expand button in PROPOSAL mockup but explicitly deferred.
- **PROPOSAL too long** (233 lines): "200 lines is too much" — trimmed to 184 by removing stale next steps, devlog section (lives in SPRINT), app name section, range fan (deferred), duplicate help resources
- **ASCII diagrams crooked**: converted everything to Mermaid — renders correctly on GitHub

### Midday — Architecture overhaul

Gio sent 8 architecture considerations that reshaped the technical foundation:

1. **Single-page landing** instead of 2-step wizard — "first page needs to be super intuitive"
2. **Per-page controllers** — "each page should have its own controller, inherit from a generic one"
3. **Image card is MVP** — "not deferred, it's an important part of the whole campaign"
4. **Descriptive class names** — "it's too generic, what does it really do?" → `MonteCarloSimulator`, `OpportunityCostCalculator`
5. **Table naming** — "settings is too generic" → `reference_values` (cited external data), `app_configs` (internal constants)
6. **OWASP 2025** — researched via agent, confirmed new edition with 2 new entries (Supply Chain, Exceptional Conditions). Full coverage table added.
7. **Open source security** — "is exposing Rack::Attack safe?" → yes for throttle rules (GitLab, Mastodon do it), no for fail2ban patterns (moved to ENV)
8. **Sources on everything** — "like a scientific article, we need to build trust" → every Stack choice, design pattern, and security decision now has a rationale + link

### Afternoon — Design & branding

Gio opened 30+ browser tabs with design references. Fetched competition kit, Awwwards sites, product sites, tweets via parallel agents. Key findings:

- **Competition kit** has a strong identity: green/yellow/red palette, Anton + Rubik Mono One + Libre Franklin, poster/zine aesthetic with hard borders
- **@cigarrogratuito tweet**: satirical Turma da Mônica cigarette packs — same predatory marketing critique angle we're taking with betting
- **timespent.so**: data viz patterns (heatmaps, progress rings) that could map to loss visualization
- **composer.trade**: "big number" hero pattern — our version: `R$30 bi/mês`

Then Gio shared 37 images from his Photos library — personal art and aesthetic references. Clear through-line: retro-psychedelic warmth, bold typography that fills the space, dark backgrounds with saturated color pops, illustrated characters with soul. The "Gio & Léo — Guia do Festival" zine he made is the Rosetta Stone — hand-lettered display type, warm tones, vintage Brazilian festival vibe.

**Gatinho mascot**: Gio will draw a cat from his illustration style as counterpoint to Tigrinho (the slots tiger). Anti-betting mascot with personality.

**Design direction locked**: warm poster/zine (Gio's aesthetic) + competition palette for semantic callouts (green=gains, red=losses, yellow=warnings). Not copying the kit's aggressive style — being the warm counterpoint.

### Late afternoon — Sprint restructure & dev rules

Rewrote SPRINT.md from phase-based tasks to 43 vertical slices. Gio pushed for:
- BE/FE/SUB prefixes ("BE stands for BACKEND, use FE for frontend")
- Human-readable card names ("BE 01 - Description")
- Cards must be small functional deliveries, not horizontal layers
- Roadmap tracker table for progress visibility

Established dev rules: English code, PR workflow with review gates, RuboCop, no abbreviations ever, seeds always current, free assets only, Docker-first.

### End of day — Rails setup

Rails 8.1.3 + Ruby 4.0.1 + Tailwind + Docker. Gio pushed for Docker over local Postgres ("why install postgres? I want to dockerize everything"), dev/staging/prod environments, and auto-db-creation on container boot. Squashed main branch history to remove old ARCHITECTURE.md with exposed fail2ban regex.

Resolved remaining open questions: Tailwind (decided), HTML-to-image for share cards ("easier route, right?"), YAML devlog, Umami analytics ("easier to install and doesn't cost a fortune?").

First PR open: giobottesi/you-bet#2.

---

## Gio's contributions

- Caught doc duplications and inconsistencies that would have caused confusion during implementation
- 8 architecture decisions that reshaped the technical foundation before a single line of app code was written
- Personal art and 40+ design references that defined the app's visual identity — not generic, distinctly his
- Gatinho mascot concept — turning his illustration style into a brand asset that directly counterpoints the betting industry's Tigrinho
- Wireframes for landing and results pages (Procreate)
- Every dev rule came from Gio: English code, no abbreviations, PR workflow, Docker-first, free assets, seeds current
- Security instinct: "erase those security decisions from past commits" → squashed history

## Sprint health

**On track?** Yes — foundation day complete. No models yet but architecture is solid and Docker is running.

**Planned vs actual**: Spent more time on architecture/branding than expected, less on code. Worth it — these decisions would have been expensive to change later.

## Tomorrow

- Merge BE 01 PR
- BE 02: CI pipeline
- BE 06-07: AppConfig + ReferenceValue models with seeds
- Start simulation engine if time allows

---

> **Claudinho says:** "Hoje eu analisei 40 fotos, 7 sites premiados, 2 tweets, um PDF de 12 páginas, e o histórico artístico completo do Gio. Conclusão: o app precisa de um gato. Concordo plenamente."
