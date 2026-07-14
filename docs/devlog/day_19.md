# Day 19 — A gem and a slipping clock

**Date**: 2026-07-14
**Sprint phase**: Post-MVP hardening — SUB (submission) still pending
**Planned**: Per Day 18 — SUB, for real this time; commit or discard the staged `/safe-bet` Clean Ruby addition.

## TL;DR

- **Light day.** One commit: added the `appsignal` gem, pushed straight to `main`.
- SUB didn't happen — third day running it was the plan and slipped.
- The staged `/safe-bet` Clean Ruby addition from Day 18 is still sitting uncommitted.
- Day 18's devlog (PR #113) is still open, unmerged.

---

## What got done

### AppSignal gem lands, unwired

`Gemfile`/`Gemfile.lock` picked up `appsignal` — dependency only, no `config/appsignal.yml`, no initializer, nothing reporting yet. Pushed directly to `main`, no PR. Read as a placeholder for observability once there's traffic worth watching, not a finished feature.

### Everything else stayed exactly where Day 18 left it

No SUB. No decision on the staged `/safe-bet` snippet. No movement on PR #113. Today was thin enough that there's no second section to write.

---

## Decisions & shifts

- **AppSignal committed straight to `main`, skipping the PR flow.**
  - Why — a single-line dependency addition with no behavior change; consistent with the project's precedent of skipping PR ceremony for trivial infra (see Day 17's launch-day commits).

---

## Gio's contributions

**Thin day: one call, and it's the one to name honestly — priority kept slipping.**

- **Let SUB slip a third day rather than force it through unfinished** → *the submission stays something Gio does properly when he has the room, not a rushed checkbox*

## Sprint health

**On track?** Behind.
SUB has now been "tomorrow's plan" three devlogs running (Day 17 → 18 → 19) without landing. The build itself isn't at risk — nothing here is broken — but the competition clock doesn't care that the code is fine.

**Planned vs actual**: Planned SUB + a small cleanup commit. Actual: one unrelated gem addition, everything else carried over untouched.

## Tomorrow

- **SUB.** No other work should get scheduled ahead of it until it's done or explicitly re-prioritized out loud.
- Resolve the staged `/safe-bet` Clean Ruby addition — three days uncommitted is long enough.
- Check in on PR #113 (Day 18 devlog) — merge or address review feedback.

---

> **Betina says:** "instalei um gem de monitoramento hoje. a ironia de adicionar observability num dia em que a única coisa a observar é a submissão não acontecendo não passou despercebida por mim. 🐱"
