# Day 01 — Research, proposal, architecture

**Date**: 2026-06-25
**Sprint phase**: Pre-Phase 0 (planning)
**Planned**: Nothing — day 1 started from an empty repo and a PDF

---

## What got done

- Read and analyzed the full Desafio Contra Bets challenge brief (12 pages)
- Ran 4 parallel research agents: data sources, simulation math, anonymous sessions, hosting/open source
- Verified 7 Brazilian data sources (BCB, DataSenado, CNC, LENAD III, Ibevar/FIA, INSS, AtlasIntel)
- Built house edge reference table for all common bet types in Brazil
- Designed Monte Carlo simulation model (server-side, 1K sims, all timeframes)
- Designed anonymous session strategy (UUID cookie + localStorage)
- Chose hosting (Fly.io São Paulo) and license (MIT)
- Wrote PROPOSAL.md — core concept, user experience, data sources, competition alignment
- Wrote ARCHITECTURE.md — full technical spec (5 tables, settings infra, security, caching)
- Wrote SPRINT.md — 5-phase plan, 15.5 days of work, 1.5 days buffer
- Created /my-bet EOD skill for daily wrap-ups

## Gio's inputs

- "Asking for income is a sensitive topic in Brazil" → pivoted to data-based spending anchors from DataSenado tiers instead of income question
  - Fundamentally changed the input design from invasive to empathetic
- "I want people who never bet AND people who already bet" → expanded from single to dual audience
  - Same engine, two entry framings — stronger product
- "Copy is too harsh" on the loss number → shifted from "you will lose" to "in 1,000 simulations, the median result was"
  - Aligned with brief's "don't blame the bettor" rule
- "Add 1 month timeframe, Brazilians like faster results" → added short window showing honest variance
  - Then escalated to "remove timeframe selection entirely, show all" — reduced flow from 3 steps to 2
- "I would like a little better infra" → pushed for settings table from day 1
  - Then pushed further: app_constants as its own table, data_source column, PaperTrail
- "We will be targeted by attacks a lot" → prompted full security section (Rack::Attack, fail2ban, attack vectors)
- "I want a daily journal blog page" → devlog concept that proves craft and differentiates from Lovable
- "If we do TDD maybe we can get best of both?" → TDD throughout instead of separate testing phase
- "3 random comparisons with expand button" → keeps results fresh, cleaner UX
- Pushed for shareable cards as viral loop — "a and b is quick win and make it shareable in customer scale"

## Decisions & shifts

- Server-side Monte Carlo instead of client-side JS
  - Unlocks anonymized aggregate data collection, keeps house edge logic server-side
- No income question — weekly bet amount with relatable anchors
  - Income is sensitive in Brazil, especially for the 52% earning ≤2 minimum wages
- All timeframes shown every time — no selection step
  - Less friction, builds mystery, cascade IS the persuasion
- Submission strategy: app + video/reel (Strategy A) + shareable cards as viral loop (Strategy B)
  - Challenge requires video/reel/carousel/image format, web app URL alone may not qualify
- LGPD approach: cookies for UX (visitor_id) + cookies for security (request logs), separate streams, both disclosed
  - Full transparency, legitimate interest basis
- Scope cut: range fan, image gen, EN, expand button, retention job deferred — saves 3.5 days
  - 18 → 15.5 days of work, 1.5 days buffer
- Docs split: PROPOSAL (what/why), ARCHITECTURE (how), SPRINT (when)
  - Gio's call — proposal was getting too technical

## Sprint health

**On track?** Yes — planning day complete, all research done, docs written.

**Planned vs actual**: No plan existed before today. We went from empty repo to full proposal + architecture + sprint plan in one session. Phase 0 (foundation) starts tomorrow.

## Time

- Approximate working time today: ~3 hours of active conversation
- Plus ~1.5 hours of parallel agent research (ran during Pilates)

## Tomorrow

- Phase 0: `rails new`, GitHub repo, CI, settings infra, anonymous sessions, Rack::Attack
- Gio reviews PROPOSAL.md with fresh eyes
- Break into implementation cards
- Design work can start (Figma/Inkscape)

---

> **Betina says:** "Passei o dia inteiro calculando quanto as pessoas perdem apostando. Perdi zero reais e ganhei zero reais fazendo isso. Ou seja, já tô no lucro comparado com 97% dos apostadores."
