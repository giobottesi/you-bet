# Day 22 — Cleared the queue, went local

**Date**: 2026-07-21
**Sprint phase**: Post-MVP polish
**Planned**: Backlog-driven — no fixed card. Clear the open-PR queue, then pick up results/form polish.

## TL;DR

- Cleared the whole open-PR backlog: six PRs merged — three devlogs, the AppSignal bump, the my-bet cost fix, and the safe-bet Clean Ruby checklist.
- Reordered the bet-type picker by what Brazilians actually play and relabeled it to local terms — "Aviãozinho", "Tigrinho", "Múltipla de N jogos".
- Rewrote the results-page collapsible copy that kept reading "hard", in both languages.
- Fanned three side-quests out to background sessions: the copy rewrite, a tip-jar references doc, and a Monte Carlo sanity-check.
- A skipped review gate almost let a 23MB video file into main — caught and stripped before it could merge.

---

## What got done

### Emptied the PR queue

Six PRs had been sitting open since the weekend. Merged them one at a time — they touch shared docs, so parallel merges clobber each other: the day-20/21 devlogs, the sprint doc marking SUB done, the AppSignal 4.9 bump, the my-bet cost-line fix, and the safe-bet Clean Ruby checklist. The AppSignal one showed a red lint check; it turned out to be the loofah / rails-html-sanitizer CVEs that an earlier PR already patched on main, so a dependabot rebase cleared it — no real regression.

### Bet types now speak Brazilian

The picker led with sports singles then accumulators — a tidy thematic order nobody actually browses by. Reordered it to lead with what people here actually play: sports betting, then Tigrinho, then the crash game. Relabeled to the words bettors use — "Aviãozinho" (the near-universal nickname for Aviator), plain "Tigrinho" instead of "Slots (Tigrinho)", and "Múltipla de N jogos" instead of the bare "Múltipla de N" that even I couldn't parse at a glance. One frozen constant drives both the form and the results order, so it was a small change with no migration.

### Results copy a tired person can read

The two collapsible explainers on the results page (the timeline block and the how-we-calculate-this block) had been flagged twice as hard reading. The worst offender — "o estrago que fica embaixo do gasto do dia a dia" — got swapped for "vem devagar, sem você perceber". Kept the Monte Carlo name (it's the honest punch-up: the houses use the same method) but led with a plain description first, and held the anti-blame line — it's the math, not your judgment.

### Three side-quests, three sessions

Instead of serializing, the next batch went out to background workers: the copy rewrite above, a references doc on how indie devs run tasteful tip jars (Pix over branded soda art, and never on the "you'd have lost R$X" reveal), and a methodology sanity-check against an external Monte Carlo project. The worktree isolation on the copy job quietly earned its keep — see below.

---

## Decisions & shifts

- **Reorder by popularity, not theme.**
  - The picker should mirror the real market, not a neat taxonomy.
- **Localize the labels, don't just translate them.**
  - "Aviãozinho" over "Aviator" because that's the word on the street.
- **Delegate the batch instead of serializing.**
  - Three independent tasks, three background sessions running in parallel.

## Gio's contributions

**Direction day: a handful of calls — and one of them caught a mistake before it shipped.**

**Product & localization**
- Called the bet-type reorder and handed over the exact renames — "tigrinho", "find the Brazilian nickname for the crash game", "I have no idea what this one is, go find what it's called here".
  → *turned a generic taxonomy into copy that reads native.*
- Held the privacy line on the side-quests: the Monte Carlo source stays internal, the tip jar can't read as profiting off the harm.
  → *kept the research honest and the public surface clean.*

**Sequencing & judgment**
- Chose to clear the PR queue first, before starting new work.
  → *unblocked a weekend's worth of stacked docs.*
- Asked, plainly, "you didn't run /safe-bet on the open PRs, right?"
  → *that one question surfaced a 23MB video file a `git add -A` had swept into the bet-types PR — stripped and force-pushed before it could bloat main's history forever.*

## Sprint health

**On track?** Yes
The original sprint shipped on Jul 12; this is post-MVP polish. Today was a clean housekeeping-plus-localization day with no new debt.

**Planned vs actual**: No fixed card — the plan was to clear the queue and start form/results polish, and both happened.

## Tomorrow

- Merge #125 (bet types) and #126 (results copy) after review.
- Task D: the Instagram competition recon — needs a logged-in browser session.
- Keep chipping the results-page backlog: help-resources copy, more share options, real-world comparison art.

---

_Project cost today: ~R$9 (amortized monthly subscriptions)_

> **Betina says:** "Spent the day teaching an app to say 'aviãozinho' and catching a video file trying to sneak into git like a raccoon into a kitchen. Localization and pest control — same job, really."
