# Day 14 — Review day, and the tax we paid ourselves

**Date**: 2026-07-09
**Sprint phase**: Frontend — reviewing the parallel-worktree batch into `main`
**Planned**: Review + merge the Day-13 batch (#63 → #66 → #67/#68/#69), applying feedback as we go

## TL;DR

- **Three PRs merged** — #63 (FE-05 form), #67 (FE-06 results), and #70, a cleanup PR that only exists because we merged #67 a beat too early.
- **The sources page grew a spine**: every figure re-verified against its *primary* source, deep-linked to where it's actually stated, and the methodological notes localized to both languages.
- **A caught fabrication that wasn't**: "bets weigh 3x interest" looked invented — turned out real (regression coefficients 0.2255 vs 0.0709). Two other numbers *were* wrong (units, attribution) and got fixed.
- **New GitHub label system** so a half-baked PR can't be mistaken for merge-ready again.
- Cosmetics landed too — washi tape and a dashed box (#71).

---

## What got done

### #63 and #67 — review, apply, merge

FE-05 and FE-06 both went in after a review round. #63's feedback was small and clean: a `before_create` callback for the UUID instead of an instance method named `create`, and the specs converted to the nested-let style. #67 asked to move the loss math off the view helper and onto `SimulationResult` — a memoized reader per horizon.

### The premature merge, and the tax

Then #67 merged — before the *simplification* pass Gio asked for had landed. The memoization and the defensive nil/zero guards were over-built for what the readers do (a simulated horizon always wagers more than zero, so the guards were unreachable). The cleaner version had to come back as a whole separate PR (#70): branch off main, redo, re-preview, re-gate. Work that was already written, paid for twice. On an app built to show people the cost of "just one more," we made exactly that bet.

### The sources page earns its name (#66)

The `/sources` page is the credibility page, so the numbers have to be right. They weren't, quite. A research pass against each primary source found drift: "5 million families" was really 5 million *people* in Bolsa Família households; the R$30 bi/month figure was mis-attributed to the Banco Central when it's a CNC number; "53.9% women" was Procon-SP, not DataSenado. Each source now carries a **deep link** to the exact study — not a homepage — and a `url` in the data. The methodological notes (including a new one flagging that CNC's magnitude is publicly contested) moved into localized keys, so the page reads fully in Portuguese. The verified table lives in `docs/DATA.md` as the durable record.

### Cosmetics (#71)

Washi tape — translucent strips pinned over each card via `::before`/`::after`, no drop shadow, so the card reads as taped to the paper instead of floating. The methodological notes got a dashed-border box. Stickers are still on the "let's think" pile.

## The Token Ledger — did efficiency actually pay out?

Gio asked a fair question at wrap-up: did our token efficiency improve, measured against work *actually delivered* — not against how busy we looked. Here's the day's book, ranked by odds. On an anti-bets app, it's only right we grade ourselves on the house edge we ran against our own context window.

- 🥇 **Best odds — delegating the source audit.** ~53k tokens of web research, spent entirely in a subagent, returned as a compressed table. High value, cost quarantined off the main thread. The bet that pays.
- 🥈 **The tight #63 fixes.** Two files, read-apply-ship, no thrash.
- 🥉 **The grinders** — caveman mode, batched tool calls, a headless screenshot to *verify* the tape instead of describing it. Small alone; together, the difference between a session that lasts and one that taps out.
- 📉 **Worst odds — the premature #67 merge.** A whole follow-up PR to finish already-written work. The vig, paid in full.
- 📉 **The house's cut** — preview branches reset, worktrees re-audited, CSS rebuilt more than once.

**The payout: mixed, honestly.** Delegation and discipline bought real room; the premature merge and branch shuffle clawed a chunk back. We shipped heavy — but the savings were *earned back*, not banked clean. And the day's AI bill was the sprint's highest, which is the ledger's own punchline.

---

## Decisions & shifts

- **A PR-label taxonomy** (`do not merge` / `needs review` / `review applied` / `ready to merge` / `stacked: waiting` / `stacked: ready`).
  - Why — #67 merged before it was ready; labels make merge-readiness explicit so it can't happen by accident.
- **Verify against the primary source, not the summary; deep-link every figure.**
  - Why — a credibility page can't carry a number that drifted in transit. Generic domain links aren't enough.
- **Cosmetics brought forward** from a post-merge follow-up to now.
  - Why — Gio wanted to see the tape and iterate, not approve it blind.

## Gio's contributions

**Direction day: a dozen calls, and the sharpest ones were about what *not* to trust.**

**Review & simplification**
- **"too overengineered — can we memoize?"** → collapsed #67's readers to small methods; killed the unreachable guards.
- **"not a real problem to pass down params if it makes it cleaner"** → freed the refactor from a needless value object.

**Workflow & sequencing**
- **Spotted the premature #67 merge and called "branch off with corrections, new PR"** → contained the damage as #70 instead of a messy revert.
- **Invented the label taxonomy** → merge-readiness is now legible at a glance.

**Data integrity**
- **"I don't want lost-in-context numbers"** → triggered the full primary-source audit that caught the unit and attribution errors.
- **Caught the Bolsa Família double-meaning** and asked for a neutral explainer link → precise, and coherent without editorializing.
- **"generic links aren't good enough — search where each said what"** → deep links, not homepages.
- **"all locales, please"** → notes localized, parity held.

## Sprint health

**On track?** Yes.
Three PRs merged, the sources page hardened to a real bar, cosmetics in review. The only drag was self-inflicted (the re-merge), and it's now a labeled process fix.

**Planned vs actual**: Planned to review + merge the batch; did that for #63/#67, hardened #66 well past its original scope, and added a cosmetics PR. #68/#69 still stacked and waiting.

## Tomorrow

- Merge #66, retarget #71/#68/#69 to main, review the stack in order.
- Decide the sticker/stamp direction (or call tape enough).
- FE-13 About — needs Gio's copy/voice, so it's a together card.

---

_AI assist cost today: $39.24, 37.9M tokens, you-bet only._

> **Betina says:** "The house always wins — turns out even when the house is your own token budget. Next time we cash out before the merge, not after." 🎲
