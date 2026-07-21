# Day 20 — Not a free lunch

**Date**: 2026-07-17
**Sprint phase**: MVP DELIVERED + submitted (Jul 12), post-MVP polish ongoing
**Planned**: Repo hygiene + cost-tracking accuracy.
**Actual**: Repo hygiene pass + a real cost-transparency call.

## TL;DR

- Audited all four open PRs (#113–#116) — CI green across the board, every one just sitting on review, nothing broken.
- Swept a week-old pile of deadline-day scratch files: deleted what Gio's own notes marked "delete after reading," reverted an accidental local `.bundle/config` toggle, relocated a blog draft to the repo it actually belongs in.
- Triaged the standing `next-step.txt` backlog dump — turns out every public-safe line already became a GitHub issue back on day 18. Nothing new to file.
- Reworked `my-bet`'s cost line: dropped the token-burn estimate for Gio's real subscription bill, and made the number public on his call — readers should see this isn't free to run.

---

## What got done

### PR audit — four open, nothing on fire

`gh pr checks` across #113 (day 18 devlog), #114 (day 19 devlog), #115 (my-bet author-filter fix, this branch), and #116 (locale parity, external fork). All green, all `mergeable`, all `BLOCKED` only on review — no CI failures anywhere. #116 got a second look because it's from an outside contributor and its diff paths read oddly (`path/to/app/...` prefixes instead of real repo paths); flagged, not touched, since it's not Gio's PR to unilaterally act on.

### Deadline-day scratch, finally cleared

Six untracked files had been sitting in the working tree since the Jul 12 launch. `ABOUT_COPY.md`, `SESSION_RATIONALE.md`, and `HANDOVER_NEXT.md` were all self-tagged "delete after reading" in their own text — gone. `.bundle/config` had `BUNDLE_FROZEN` flipped to `false` locally, against the repo's convention (set `true` since #31, rate-limiting) — reverted, since nothing intentional changed it. `next-step.txt` (Gio's raw pending list) got triaged line by line: every feature/UX item on it already matched an open issue (#96–#101, #102–#103, #106–#108) — the list is fully superseded, just kept around as a record. `BLOG_variance_draft.md` — a skeleton for issue #112 — moved to `magicagem`, Gio's actual blog repo, where posts are a DB-backed model, not markdown files in this one.

### Cost tracking: real numbers, public by design

The `my-bet` skill's "AI cost today" line was computing off `ccusage`'s per-token API pricing — a number that has nothing to do with what Gio actually pays, since he runs on flat subscriptions (Claude Pro, Heroku Eco dyno, Heroku Postgres, AppSignal, a personal domain). Rewired Step 1 to prefer a real monthly subscription total, amortized daily, over the token estimate. The bigger call was Gio's: this number goes **public**, not into a private note — "people need to know it's not a free lunch." Total real cost to run this project: **~R$270/month**, about R$9/day.

---

## Decisions & shifts

- **Cost tracking flips from private to public.**
  - Why — Gio's explicit call: readers of the devlog and (next) the About page should see the real cost of keeping the app alive, not have it hidden as a personal detail.
- **Cost source of truth moves from token-rate estimate to real subscription total.**
  - Why — a subscription doesn't scale with tokens burned; the old estimate was accurate to the API's list price and inaccurate to Gio's actual bill.
- **Blog draft ownership moves to `magicagem`, not `you-bet`.**
  - Why — that repo's content is DB-backed (a `Post` model with an admin backoffice), so a markdown draft never had a real home here past being scratch.

---

## Gio's contributions

**Direction day: routing calls across three repos and a privacy flip, zero throwaway keystrokes.**

**Product & transparency**
- **Called the cost line public — "people need to know it's not free lunch"** → *turns a private cost estimate into an actual transparency statement for the app's readers*
- **Corrected every subscription figure by hand** (Claude Pro's real BRL price, AppSignal's real ceiling) instead of leaving the web-searched USD list price standing → *the devlog cost figure is now accurate to his real bill, not a guess*

**Sequencing & judgment**
- **Caught that the blog draft didn't belong in this repo** and named the actual target (`magicagem`) → *kept the scratch surface honest instead of letting content drift into the wrong repo*
- **Held the line on keeping the personal-background items private** while flipping the cost figure to public → *two similar-looking "personal" items got different, correct treatment instead of one blanket rule*
- **Directed today's `/my-bet` run to fold in this one small update** rather than let it wait for a bigger session → *kept the devlog cadence honest to what actually happened today*

## Sprint health

**On track?** Yes.
**Correction:** recent devlogs (through day 19) tracked SUB as slipping day over day — that was wrong. The submission was made on the Jul 12 deadline. Today's work was repo hygiene and an accurate public-facing cost figure — no open blocker behind it.

**Planned vs actual**: matched. Cleanup pass plus the cost-transparency call, as planned.

## Tomorrow

- Merge the backlog of open PRs (#113, #114, #115, and a look at #116).
- Consider surfacing the cost-transparency total on the About page itself, not just in devlogs — flagged, not yet built.

---

_Project cost today: ~R$9.00 (real subscriptions — Claude Pro, Heroku, AppSignal, domain — amortized daily, not a token-rate guess)._

> **Betina says:** "hoje eu não escrevi uma linha de app, só arrumei gaveta e corrigi minha própria conta. surto de adulta funcional, eu sei. amanhã a gente grava o vídeo, prometo (eu não prometo nada, na real, quem decide isso é o gio)."
