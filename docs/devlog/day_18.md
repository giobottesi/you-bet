# Day 18 — Opening the doors

**Date**: 2026-07-13
**Sprint phase**: Post-MVP hardening — SUB (submission) still pending
**Planned**: Per Day 17 — record the demo, finalize the AI-declaration, register and submit.

## TL;DR

- **Submission stayed parked another day.** Instead: model hardening, doc cleanup, and turning You-Bet into a project strangers can actually contribute to.
- Shipped `rebet_fraction` as a named, tested simulator parameter (PR #94) — the loss model now says explicitly how much of the bankroll gets re-staked each week.
- Synced the living docs (`SPRINT.md`, `DATA.md`, `PROPOSAL.md`) to match shipped reality, closing the gap between what the code does and what the docs claim (PR #95).
- Filed the whole scattered backlog as **16 tracked GitHub issues** (#96–112), then wrote a "How this is built" README section and a `CONTRIBUTING.md` to open the project up (PR #109, merged).

---

## What got done

### `rebet_fraction` gets a real name and a home

The model change from yesterday's cleanup — how much of a bettor's bankroll gets re-wagered each week instead of pocketed — landed as `rebet_fraction`. It started life as `recycling_coefficient` in the same PR and got renamed before merge: "recycling" was opaque, and "reinvest" wrongly reads as prudent. `effective_edge = rebet_fraction * house_edge`, default `0.5`, anchored to observed Brazilian turnover/deposit ratios (~1.6–2.3x); `1.0` reproduces the old pure let-it-ride behavior exactly. Full spec coverage in `monte_carlo_simulator_spec.rb`.

### Docs catch up to the code

`SPRINT.md` now says MVP delivered in plain terms, with every card reconciled to Done/Deferred/Cut/Partial and an honest scope-change log instead of silent drift. `DATA.md` picked up the `rebet_fraction` methodology and a renamed seed key (`netflix_spotify` → `music_video_stream`) to match what's actually seeded. `PROPOSAL.md` got a banner marking it historical — the original pre-build plan, not the shipped app — pointing readers at `ARCHITECTURE.md`/`DATA.md` for current behavior instead of quietly going stale.

### Backlog becomes 16 GitHub issues

The scattered "someday" list in `docs/BACKLOG.md` got filed as sixteen tracked issues (#96–112) on the GitHub Roadmap board, grouped by `area:*` label (results, i18n, sharing, design, simulation, whimsy, competition, process) with `research`/`copy` tags where relevant. `BACKLOG.md` itself shrank to a two-line signpost. This is a real process shift — the project had deliberately avoided a ticketing layer through the sprint; post-MVP, with contributors in mind, tracked issues won out.

### A front door for outside contributors

README grew a **"How this is built"** section — plain language, no GitHub jargon, no naming or knocking other entries in the competition: real engineering, always evolving, fully disclosed (numbers sourced at `/sources`, AI use declared at `/about`, build public at `/devlog`). Two stale README lines claiming "every timeframe at once" got fixed to match the actual single-horizon picker. Then a `CONTRIBUTING.md` — find a `good-first-issue`, set up, open a PR — pointing at README/CLAUDE.md instead of duplicating conventions. Merged as PR #109.

### Loose threads

A `/safe-bet` addition — a "Clean Ruby" checklist pulled from `uohzxela/clean-code-ruby` — is staged but uncommitted. A skeleton draft for a blog post arguing the Monte Carlo crowd and this project aren't actually disagreeing (tracked as issue #112) is sitting untracked, unfinished.

---

## Decisions & shifts

- **Backlog moved from a markdown parking lot to GitHub Issues + a Projects board.**
  - Why — the sprint intentionally avoided ticketing to stay light; post-MVP, with the project now inviting outside contributors, a scattered doc stops being legible to a stranger.
- **`recycling_coefficient` renamed to `rebet_fraction` mid-PR, then again in the docs.**
  - Why — the first name was opaque, the tempting alternative ("reinvest") was actively misleading about what the coefficient represents.
- **Per-bet-type `rebet_fraction` values stayed un-seeded.**
  - Why — a primary source exists for RTP-by-product but not for the turnover ratio that would pin `r` per type; shipped as one honest default (0.5) rather than illustrative numbers dressed up as data, tracked as issue #105 pending a real source.

---

## Gio's contributions

**Hardening day: fewer commits than launch day, but each one closes a gap instead of opening one.**

**Naming & data integrity**
- **Renamed `recycling_coefficient` to `rebet_fraction` before it shipped** → *the identifier now says exactly what it measures, no domain-knowledge tax to read the code*
- **Refused to seed per-bet-type `rebet_fraction` values without a primary source** → *the model stays honest about what it knows vs. assumes, tracked as a gated research issue instead of guessed numbers*

**Project positioning & process**
- **Adopted GitHub Issues + a Projects board for the backlog** → *reverses the sprint's ticket-free convention on purpose, because a public parking lot doesn't scale to strangers picking up work*
- **Set the explicit constraint: no GitHub jargon, no naming or knocking other competition entries** → *the "How this is built" pitch reads as confident, not defensive*
- **Built the contributor on-ramp (`CONTRIBUTING.md`) same day as the positioning copy** → *the "come contribute" pitch has somewhere to land instead of being aspirational*

## Sprint health

**On track?** Needs adjustment.
SUB (demo, AI-declaration, register, submit) was the explicit plan for today and didn't happen — the day went to model correctness and opening the project up instead. Nothing is broken, but the submission clock is still running.

**Planned vs actual**: Planned to close out with SUB. Actual: shipped a model fix, a docs sync, and a full contributor on-ramp — real work, wrong priority for a project with an unsubmitted entry.

## Tomorrow

- **SUB, for real this time** — record the demo, finalize the AI-declaration, register and submit. Nothing else should get scheduled ahead of it.
- Commit or discard the staged `/safe-bet` Clean Ruby addition — don't leave it uncommitted another day.

---

> **Betina says:** "hoje a gente deu nome pro `r`, arquivou o futuro em issues bonitinhas, e escreveu um convite pra estranhos entrarem no projeto. tudo isso e ainda não apertei o botão de inscrição. amanhã, sem desculpa — o SUB não vai se submeter sozinho. 🐱"
