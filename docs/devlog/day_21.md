# Day 21 — CI was never our fault

**Date**: 2026-07-18
**Sprint phase**: MVP DELIVERED + submitted (Jul 12), post-MVP polish ongoing
**Planned**: Whatever the backlog surfaced next — no fixed target, post-MVP mode.
**Actual**: An unplanned detour. CI had been red for two days and nothing in the backlog mattered until that got fixed.

## TL;DR

- Root-caused a CI outage that had been failing every PR since 07-17 — not a code regression, but `ruby-advisory-db` flagging two already-locked gems (`loofah`, `rails-html-sanitizer`) with fresh CVEs. Fixed and shipped as PR #119.
- Reproduced the break locally, ran the fix through `bundler-audit`/`rubocop`/tests before touching `main`, then hit GitHub's actual review-required branch protection on merge — cleared it properly instead of working around it.
- Ran a retroactive review on the already-merged fix (should have run `/sure-bet` before merging, not after — noted).
- Corrected a real error that had been sitting in three devlogs in a row: SUB (the competition submission) was actually made on the July 12 deadline, not "slipping," as day 17–19 claimed.
- Banked today's environment gotchas into memory and closed the day with the day-20 devlog that never got committed.

---

## What got done

### CI was down for a reason that had nothing to do with our code

A GitHub Actions link came in with a simple ask: find the actual root cause, don't just patch the symptom, and try to disprove the fix before shipping it. `gh run view --log-failed` on the failing run showed the `lint` job dying on `bundle exec bundler-audit check --update`, not `rubocop`. Cross-referencing `gh run list` against the last few days showed CI had been green through 07-14, then red on *every* run from 07-17 onward — including a dependabot PR that only touched an unrelated gem bump. That pattern (uniform failure, unrelated diffs) pointed at the audit database, not the code: `ruby-advisory-db` had picked up four new advisories against `loofah` 2.25.1 and `rails-html-sanitizer` 1.7.0, both already sitting in `Gemfile.lock` untouched for days.

The fix was a two-line lockfile bump (`loofah` → 2.25.2, `rails-html-sanitizer` → 1.7.1, both within existing `Gemfile` constraints) — but the "prove yourself wrong" instruction earned its keep: a second advisory landed in the same database update, against `websocket-driver`, and it would have been easy to assume it needed the same treatment. Checking it directly showed the locked version was already the patched one. Also checked `bundler-audit` against the *whole* lockfile afterward, not just the two flagged gems, to rule out anything else hiding in the same drift.

### Branch protection, for real this time

Opening the fix as its own PR (#119, off a scratch worktree so Gio's live-edited working tree didn't get touched) and merging it hit an actual wall: GitHub's branch protection on `main` requires a review approval, and `gh pr merge` failed outright rather than just being a team-discipline thing. That's a stronger guarantee than assumed going in — asked before reaching for `--admin` to bypass it, got the review done properly in GitHub, then merged clean.

### Retroactive review, self-improve, and the devlog that never shipped

The CI fix got merged without running the full `/sure-bet` gate first — just the individual pieces (`bundler-audit`, `rubocop`, CI itself). Went back and ran a `/safe-bet`-style review against the merged commit after the fact: coherence, duplication, sensitive info, conventions — all clean, but the sequencing should be tightened next time. Ran `/self-improve` to bank the session's environment lessons (a sandbox quirk where the shell's working directory resets after `cd`-ing outside the project root, the confirmed branch-protection enforcement, the advisory-drift diagnostic pattern).

While pulling today's git history for this entry, an untracked day-20 devlog draft turned up in the working tree — real, completed work from the previous session (a repo-hygiene pass and a decision to make the cost-transparency line public) that never got committed. It contained one factual error worth catching: it repeated the "SUB slipped" framing from day 19, which was wrong. Corrected it and shipped it as PR #120 before starting this entry.

---

## Decisions & shifts

- **CI fix shipped as its own tiny PR, never bundled with anything else.**
  - Why — a security/CVE fix should be reviewable in isolation, and unrelated docs work (day 20's devlog) was already in flight on a separate track.
- **Merge only after an actual review landed in GitHub, not just an inline "sounds good."**
  - Why — branch protection turned out to enforce this server-side, not just as a convention; worth confirming going forward rather than assuming.
- **SUB tracking gets corrected going forward, not rewritten in the past.**
  - Why — day 20's entry was fixed before it shipped since it hadn't been committed yet; already-public day-19 entries were left as historical record rather than edited after the fact — flagged as an open call below.

---

## Gio's contributions

**Direction plus one real correction: kept the fix scoped, and caught an inaccuracy nobody else would have known was wrong.**

**Direction & guardrails**
- **Called for a full root-cause pass with an explicit self-skepticism check** ("prove yourself wrong anyway") instead of accepting the first plausible explanation → shaped the actual debugging methodology, which is exactly what caught the second `websocket-driver` advisory as a non-issue
- **Held the line on "don't merge" until an explicit go-ahead** → the fix sat reviewable instead of landing unilaterally
- **Cleared the branch-protection review himself in GitHub** rather than authorizing a bypass → the merge went through the actual safeguard, not around it

**Judgment**
- **Caught the "SUB slipped" narrative as wrong, with information only he had** (the real July 12 submission date) → stopped a factual error from compounding into a third devlog
- **Set the frame for future feature planning** — cost-benefit, but weighted for what he'd actually enjoy building, not pure ROI → a real product-philosophy input, not just a scope note

## Sprint health

**On track?** Yes.
CI is green again; #119, #113, #114, #115, and #120 are all merged or open-and-clean. #117 (dependabot) still needs a rebase onto current `main` — the one carryover.

**Planned vs actual**: no fixed plan existed for today; the CI outage set the agenda. Reasonable trade — an unreviewable, half-broken CI pipeline blocks everything else more than any single backlog item would.

## What's next (cost/benefit, weighted for fun — this is a side project, not a startup)

Gio's ask: still compare cost and benefit, but this app is something he builds because he enjoys it and it destresses him, not something to ROI-maximize. So effort/impact sit next to a fun-factor column instead of overriding it.

| Feature | Effort | Impact | Fun factor | Note |
|---|---|---|---|---|
| Refine the Monte Carlo model toward real-world fidelity (#104) | Medium–High | High — core credibility of the whole tool | High | The actual modeling work; likely the most enjoyable one on the list |
| Validate the loss model against real per-bettor logs (#111) | High | High — turns an assumption into a checked fact | High | Needs a data source first; big payoff if one turns up |
| Blog post: variance, same math opposite lesson (#112) | Low–Medium | Medium — reach, not code | High | Writing, not building — different kind of fun, quick to finish |
| Personalize `rebet_fraction` per user, v3 (#110) | High | Medium — nice-to-have precision, not core | Medium | Bigger lift than its payoff justifies right now |
| Surface the cost-transparency total on the About page | Low | Medium — trust/transparency | Low–Medium | Small, honest, low-effort win; mostly housekeeping |
| Bring older pages up to latest design specs (#103) | Medium | Low–Medium — polish, not new value | Low | Real but least fun of the batch; fine to leave parked |

**Read on this:** the modeling work (#104, #111) is where effort, impact, and enjoyment all point the same direction — that's the one worth reaching for next when there's real focus time, not because it scores highest on paper but because it's genuinely the fun part. The blog post (#112) is the low-effort, high-enjoyment filler for a smaller pocket of time. Everything else is fine parked in the issue tracker until it's the thing that sounds fun that day.

## Open questions

- `docs/SPRINT.md` still shows SUB 01–04 as "🔵 In progress," targeted Jul 12 — now stale given the correction. Want it flipped to done, or is there nuance (e.g. the demo video specifically) that's still open?
- Day 19's public devlog still says SUB was slipping. Leave historical entries as-is (day 20 was only fixed because it hadn't shipped yet), or issue a correction?
- PR #117 (dependabot) — still needs a rebase + merge; picking this up next unless redirected.
- `.claude/commands/safe-bet.md` (Clean Ruby checklist, uncommitted 4+ days now) and `.claude/commands/my-bet.md` (the cost-line rewrite, already reflected in day 20's devlog) are both sitting uncommitted in the working tree — want these committed now?

## Tomorrow

- Rebase and merge PR #117.
- Resolve the open questions above.
- Pick up whichever "What's next" item actually sounds good that day.

---

_Project cost today: ~R$9.00 (real subscriptions — Claude Pro, Heroku, AppSignal, domain — amortized daily, not a token-rate guess)._

> **Betina says:** "spent the day proving myself wrong on purpose so I wouldn't have to do it by accident later. turns out the bug wasn't even ours — the internet just got more paranoid about an old gem while we weren't looking. gio called me crazy for worrying about a deadline that had already been cleared for six days. fair. still checking the mail every morning though."
