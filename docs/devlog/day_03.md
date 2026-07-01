# Day 03 — Data layer done, migration day

**Date**: 2026-06-28
**Sprint phase**: Data Infrastructure (BE 03–08)
**Planned**: BE 02 (CI), BE 03 (i18n), BE 06 (AppConfig), BE 07 (ReferenceValue)

## TL;DR

- Shipped BE 03, BE 04, BE 06, BE 07, and BE 08 — five cards in one session
- AppConfig and ReferenceValue models are live with seeds, type casting, and full test coverage
- BetType value object wraps house edges cleanly — no more raw DB lookups in caller code
- Seeds refactored to extract constants, making them readable at a glance
- Switched Claude profile from company to personal — migrated profile, memories, and settings

---

## What got done

### i18n and deploy (BE 03 + BE 04)

Set up pt-BR as the primary locale with RSpec configured. Stubbed the EN locale for when it's needed — no strings to translate yet, but the infrastructure is there.

First deploy shipped (PR #8). Note: ended up using a Heroku Procfile instead of Fly.io as originally planned in ARCHITECTURE.md. Worth confirming which host is actually live and updating the docs to match.

### AppConfig model (BE 06)

Model for system-level constants: Monte Carlo sim count, poupança rate, minimum wage, data retention period. Key features:

- `typed_value` — returns the right Ruby type (integer, float, BigDecimal, string) based on `value_type`
- `.fetch(key)` — raises `RecordNotFound` for missing keys, no silent nils
- `SEED_DEFAULTS` extracted to a constant — seeds read like a table, not imperative code
- Seeds are idempotent (`find_or_initialize_by`) — safe to run on any environment, any number of times
- Full RSpec coverage: validations, type casting, seed idempotency

### ReferenceValue model (BE 07)

Model for externally-sourced cited data: comparison prices and bet type house edges. Each row has a `data_source` — every number in the app cites its origin.

Two seed constants: `SEED_COMPARISON_VALUES` (10 prices from iFood, Apple BR, DIEESE, etc.) and `SEED_BET_TYPE_VALUES` (7 house edges with methodological notes). Same `find_or_initialize_by` idempotency pattern.

`.by_category` scope added for filtering comparison vs bet_type data.

### BetType value object (BE 08)

Plain Ruby class — no AR inheritance, no table. Wraps the 7 supported bet types and delegates house edge lookup to `ReferenceValue`. Exposes `display_name` via i18n with a sensible fallback.

`.all` and `.find` class methods follow ActiveRecord's interface so callers don't need to know it's not a DB model. `ArgumentError` on invalid key — fast fail, no silent behavior.

### Seeds refactor

Extracted all seed data to `SEED_*` constants on the models. `db/seeds.rb` went from a block of repetitive hashes to three readable loops. Idempotency is now the model's responsibility, not the seed file's.

### Claude profile migration

Moved the Claude setup from company profile to personal:
- `~/.claude-personal/CLAUDE.md` — full dev profile with coding style, response rules, tone
- `~/.claude-personal/settings.json` — model (`opus[1m]`), voice, theme (`dark-ansi`), ruby-lsp plugin
- `~/.claude-personal/statusline-command.sh` — git branch + model + ctx% in the status bar
- Imported 9 project memories from company profile into personal
- Extracted 4 new memories from codebase: sprint status, design system, gem stack, open issues

---

## Decisions & shifts

- Seeds as model constants, not in `db/seeds.rb`
  - Keeps seed data colocated with the model — easier to find, easier to update, no context switching
- BetType as a plain Ruby value object, not ActiveRecord
  - No table needed. House edges live in `reference_values` where they can be updated without a deploy.
- Heroku instead of Fly.io for deploy
  - Contradicts ARCHITECTURE.md — needs verification and doc update

---

## Gio's contributions

- Pushed for seeds extracted to constants ("I would like to see this cleaner") → much more readable seed data
- Initiated Claude profile migration → full setup portability between work and personal contexts
- Caught the need for memory import from company profile → 9 memories restored, 4 new ones extracted from codebase

## Sprint health

**On track?** Yes — slightly ahead on the data infrastructure phase.

**Planned vs actual**: Skipped BE 02 (CI pipeline) to move faster on the data layer. BE 02 (bundler-audit, GitHub Actions) is still pending. BE 07 and BE 08 got done in the same commit, saving a session. Sprint roadmap in SPRINT.md needs updating — it still shows only BE 01 as done.

## Tomorrow

- Resolve `BETTING_TYPES` vs `TYPES` constant rename before opening be-07 PR
- BE 02: CI pipeline — GitHub Actions + bundler-audit (unblocked, fast card)
- BE 05: CLAUDE.md — project-level instructions (unblocked, fast card)
- BE 09: MonteCarloSimulator core — the main event; unlocks the entire simulation chain
- Update SPRINT.md roadmap to reflect current state

---

> **Betina says:** "Hoje construí a fundação de dados do app: preços de pizza, bordas de cassino, e quanto custa um iPhone no Brasil. Não sei o que é mais absurdo — o iPhone custar R$5.500, ou uma indústria inteira apostando que você não vai sentir esse valor escorrer toda semana."
