# Day 10 — Sharpening the review gate

**Date**: 2026-07-05
**Sprint phase**: Frontend build-out (mid-sprint, day 11 of 17 calendar days)
**Planned**: FE 02 — the next frontend slice

## TL;DR

- Spent the day on the meta-layer instead of features: hardened the whole contributor review stack — `/write-review`, a new `/sure-bet` definition-of-done gate, and wired `/write-review` into `/my-bet`.
- Shipped a small DX win — `git-delta` as the git pager, documented in a new `docs/DEV_TOOLING.md` (PR #44) — so diffs on this prose-heavy repo stop reading like scratch-off tickets.
- Grew up the memory system: caught two live skill-vs-memory conflicts and codified the rule that stopped them from recurring.
- Put the new gate to its first real test — swept every open PR under the hardened rules. All compliant, zero fixes. The bar held on contact.
- FE 02 slipped a day on purpose. The tools that guard quality were the higher-leverage thing to fix first.

---

## What got done

### The review gate got teeth

The contributor skills stack moved from "nice checklist" to an enforced bar. `/write-review` — the prose-quality pass — got hardened: dead-anchor-link stripping, terminology-drift catches, a real privacy/leak step, and a fix so it stops flagging betina's own sign-off as a dead link. A new `/sure-bet` skill now acts as the single definition-of-done gate, orchestrating tests, lint, `/safe-bet`, `/write-review`, and PR hygiene into one pass a contributor runs before opening anything. And `/write-review` is now wired *into* `/my-bet`, so every devlog goes through the same prose bar automatically instead of on the honor system. The whole pass shipped as PR #40 (merged).

### Better diffs, cheaply

`git diff` is noise on a repo where half the changes are prose. Installed `git-delta` and set it as the global pager — syntax-highlighted, word-level, navigable diffs. Rather than leave it as tribal knowledge, it went into a new `docs/DEV_TOOLING.md` as the first entry in a contributor-tooling doc, shipped as PR #44. It's pager-only, so scripts and CI fall back to plain diff untouched.

### The memory system stopped lying to itself

The day's quiet win. Two live conflicts surfaced where memory had copied a skill's internals and then drifted: a stale betina sign-off format, and a `/safe-bet` step count that no longer matched the actual skill. Root cause named and codified — memory holds the *why* and the decision; the skill file stays the single source of truth for the *how*. Mirrors drift; pointers don't. That one principle retires a whole class of recurring bugs.

### The gate passed its own first test

A quality bar nobody has run on real work is a hypothesis. So the moment the rules merged, they got pointed at the live open set: every open PR — the prose ones (devlogs, the reflections series) and the two FE code PRs (#37 re-skin, #38 landing) — swept against the hardened `/write-review` and `/sure-bet` bar. Result: all compliant, zero fixes, zero force-pushes. The PRs written *after* the hardening self-complied; for the two that predated it, the one real leak that ever surfaced — a third-party name in the day-09 prose — had already been scrubbed to a neutral "another app" during that day's purge. Then some housekeeping fell out of it: deleted the now-redundant hardening branch (its commits were already squash-merged into main, so it was a duplicate) and pruned the stale remote-tracking refs. The gate didn't just exist — it held.

---

## Decisions & shifts

- **FE 02 deferred a day to harden tooling first.**
  - Why — the review skills are what keep every future PR at the team bar. Paying down that debt now compounds across every remaining sprint day; doing it after FE 02 would mean FE 02 shipped without the gate.
- **Tooling docs get their own home (`docs/DEV_TOOLING.md`), on their own branch off main.**
  - Why — DX tips are unrelated to in-progress feature work; bundling them onto a feature branch violates the small-PR hygiene the project runs on.
- **Memory stops mirroring skill internals.**
  - Why — two conflicts shipped wrong behavior because a memory copy of a skill's steps went stale. Point at the source of truth instead of duplicating it.
- **Verify the gate against live PRs the day it merges, not later.**
  - Why — a bar that's never run on real work is unproven. Sweeping the whole open set immediately turned "should hold" into "does hold" and found nothing to fix — the strongest possible signal the hardening was real.

---

## Gio's contributions

**Direction day: no features shipped, and that was the point — Gio spent his calls on the machinery that makes every future feature ship cleaner.**

**Scope & sequencing**
- Called the FE 02 deferral — hardened the review gate *before* the next feature, not after. → *Every remaining PR now passes through an enforced quality bar instead of a hopeful one.*
- Scoped the delta note to its own PR off main rather than piggybacking the hardening branch. → *Kept the diff docs-only and the branch history honest.*
- Called the PR sweep the moment the rules merged — validate the gate on the live open set, then clean up the dead branch. → *Confirmed the whole open set clears the new bar with zero rework; the hardening was proven, not assumed.*

**Judgment**
- Pushed for better *visual* diffs specifically because this repo is prose-heavy — connected a tooling choice to the actual shape of the work. → *`git-delta` chosen for the review loop, not for novelty.*
- Trusted the instinct that the memory system was "conflicting stuff" — which it was. → *Surfaced two live drifts and turned them into a durable rule.*
- Insisted the betina/levity rituals are load-bearing, not decoration. → *Whimsy stays in the system as a deliberate tool, not overhead to trim.*

## Sprint health

**On track?** Yes
One process-investment day mid-sprint; the FE track is one slice behind but the quality infrastructure is now ahead.

**Planned vs actual**: Planned FE 02; actually hardened the review skills + shipped delta tooling + matured the memory system + swept the open PR set clean against the new bar. A deliberate swap, not a slip.

## Tomorrow

- Pick up **FE 02** — the deferred frontend slice — now running through the hardened `/sure-bet` gate.
- Backlog to prioritize (parked): generalize the "contributor's contributions" section beyond Gio, and nest devlogs under per-contributor directories.

---

_AI assist cost today: $41.58, 38.8M tokens (you-bet only)._

> **Betina says:** "Built a gate, a linter, and a prettier way to look at my own mistakes. Tomorrow I get to make new ones in higher resolution."

---

## Appendix — the Sunday phone sesh

Written up after the fact; the whole thing happened from a phone, mid-Sunday, right as Brazil lost its World Cup match and dropped out — ironic timing for a debugging session that kept ending the same way: the house wins the first few tries.

`youbet.gio.show` came back from its first custom-domain deploy as one long 500. What looked at first like a DNS or Heroku cert issue turned out to be two real, independent bugs, only visible once the actual deploy path got run for real instead of theorized about:

- **The database was never migrated.** No release phase existed at all, and once one got added, Heroku's single Postgres add-on couldn't support the three separate `solid_cache`/`solid_queue`/`solid_cable` databases the app was configured for. Collapsing them onto the primary database still wasn't enough — `db:prepare`'s "does this database exist" check meant their tables never actually got created, so every request touching `Rack::Attack`'s cache-backed throttle counters 500'd.
- **tailwind.css never made it into a single build.** A second, unrelated 500 (`Propshaft::MissingAssetError`) survived two separate rake-hook attempts — clearing Propshaft's memoized asset listing, then shelling out to the CLI directly at different points in the task graph — before the actual cause surfaced: `app/assets/builds/.keep` was never committed, so the directory doesn't exist yet when Rails registers its asset load paths at boot on a fresh Heroku checkout. Gio found that one with a plain Google search, faster than the local reproduction loop was converging on it.

Both shipped in PR #46, verified end-to-end against a real Postgres instance and a real from-scratch checkout — not just working-tree state — before being called done. Running the actual test suite as part of `/sure-bet`, not just manual reproduction, caught a third, quieter regression the fix itself introduced (the schema-loading hook crashing `db:prepare` in test/dev) before it ever reached a PR.

**Gio's contribution, this round:** drove every pivot in the diagnosis from a phone — ruled out DNS, ran the first `db:migrate` himself from the Heroku console, pushed back on release-phase safety before letting it ship, and beat two rounds of AI-authored rake hackery to the real fix with a search engine. Scoreboard for the day: Brazil 0, house edge 2 (two wrong guesses before the right one), Gio 1 (the actual fix).

> **Betina says:** "Brazil's out of the Cup and my first two fixes were out by half-time too. At least the app I'm debugging is the one that warns people the house always wins first — I just didn't expect to be the house's opening demo."

---

## Appendix — the magicagem side-quest

*Written up after the fact — its own branch (`claude/blog-session-views-scaffold-dt4fdj`), its own session, no relation to FE 02. "Appendix" is the right word for it: additive, not sprint-card work.*

Gio asked for a scaffold of "magicagem" — his old 2014 crystals-and-tarot blog — branded with the real `@magicagem` Instagram handle and a palette he called whimsy, framed from the start as "just make a PR so I can imagine some things." Built `/blog/sessions` (index + show), `/blog/archive`, and `/blog/about` on a `BlogSession` frozen-data model (no migration needed) behind a dedicated layout — its own soft lavender/pink/gold palette, deliberately the opposite of the locked You-Bet zine look, so the two brands never blur together.

While that was live, the FE-01 landing skeleton that's been sitting unlinked at `/simulations/new` since day 9 finally got wired to root, replacing the old "coming soon" `HomeController` placeholder — and a Blog link went on the landing page so the two prototypes read as one navigable site instead of two orphan URLs.

This is explicitly a **super prototype**: a disposable reaction tool, not a feature commitment. Expect it to change shape a lot, or get cut outright, before it's anything real — no decision has been made on whether magicagem belongs in You-Bet at all. Gio deployed the blog scaffold to Heroku mid-session, on his own call and his own credentials, to see it live rather than imagine it from a description. The reaction was immediate: "so cuuuute" — and, more usefully, liking the whimsy palette sitting next to the zine landing page, even before the two were cross-linked, as a way to actually think about direction instead of guessing at one. The root-wiring and the blog link shipped right after that first look, went out on the next deploy, and Gio confirmed the link works live from the landing page itself.

**Gio's contribution, this round:** framed the whole thing as disposable from the first ask, which is what let it move fast without a scope debate; caught that the two new prototypes had zero link between them and asked for one; made the explicit, eyes-open call to keep the real Instagram handle live on a public repo ("I have my secrets under my sleeves, I'm internet old enough"); and reacted to something concrete instead of describing a preference in the abstract — which is the entire point of building a spike like this one.

> **Betina says:** "Spent the day building a crystal blog and a betting-harm calculator under the same roof. If the house always wins, at least now it has a whimsy corner to sit in while it waits."
