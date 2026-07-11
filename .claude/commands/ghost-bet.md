You are running **`/ghost-bet`** — the You-Bet **copy ghostwriter**. It drafts or revises public-facing copy by fanning the work across two models, cross-reviewing them adversarially, and merging the best of both into one final. It is the heavy, high-stakes counterpart to `/write-review`: `/ghost-bet` **writes** the copy; `/write-review` **gates** it once per PR.

`$ARGUMENTS` = the target + intent. Two modes (infer from the ask, or ask if unclear):
- **WRITE** — net-new copy from a brief ("write the /about intro", "draft the LGPD deletion section").
- **REVISE** — improve existing copy ("tighten the sources page", "de-AI the proposal overview").

Everything is written to `docs/COPY_STANDARDS.md` — that's the bar. Read it first; it also carries the per-model calibration this skill depends on.

---

## Step 0 — Scope & stakes (decide the path before spending agents)

The full fan-out is five agents. Don't spend them on trivia. Pick a path:

- **Full fan-out** — user-facing pages (privacy, sources, about, help, in-app copy), the PR-critical doc, launch/submission copy. Anything a stranger reads or that carries the brand. Run Steps 1–4.
- **Cheap path** — a one-line tweak, an internal-only note, a typo. Do it inline single-model, skip the fan-out. Log that you took the cheap path and why.
- **Skip** — the copy is already clean. Say so; don't invent work. (In the calibration run, `TECH_DEBT.md` needed zero edits — a clean verdict is a valid result.)

Name the target(s), the mode, and the path before running anything.

---

## Step 1 — The five-agent fan-out

Author a `Workflow` for this (deterministic topology, model overrides per role). Models are **Opus 4.8 and Sonnet 5 only — never Haiku** for copy (see `docs/COPY_STANDARDS.md` → Model notes for why). Roles:

**WRITE mode** (net-new):
1. **Writer-Opus** — drafts the brief against the Standards.
2. **Writer-Sonnet** — drafts the same brief independently.
3. **Reviewer-A** (inverted/adversarial) — critiques Writer-Sonnet's draft: every weak claim, AI tell, tone slip, unsourced fact.
4. **Reviewer-B** (inverted/adversarial) — critiques Writer-Opus's draft the same way. Cross, so no draft grades its own homework.
5. **Merger** (`model: opus`) — skeptical synthesis: take both drafts + both critiques, produce ONE final that grafts the best of each, **discards false-positive critiques, and verifies every surviving fact against the code/source.** The merge is not a union — every model, Opus included, emits findings worth throwing out.

**REVISE mode** (existing copy): skip the two writers. The two inverted reviewers read the existing text (each a distinct lens — e.g. one fact/cohesion, one tone/plain-language/de-AI), then the Opus merger applies the surviving fixes with a minimal diff.

Use structured-output schemas so drafts/critiques come back as validated objects, not prose. Give reviewers the Standards in their prompt. Keep the merger's mandate explicit: minimal diff, preserve technical meaning/numbers/code/tables/headings and any betina sign-off, conservative-beats-clever, skip-and-log when unsure.

---

## Step 2 — Apply the merged copy

The merger's output is the copy to ship. Apply it by editing the file(s):
- Locale copy → edit **both** `en.yml` and `pt-BR.yml`, keys at parity, widely-understood estrangeirismos kept.
- Docs/README/PR body → minimal diff, structure preserved.

Never apply a fix the merger couldn't verify. When the merger skipped something, leave it and surface it.

---

## Step 3 — Model-comparison receipt

Copy the run's value back for the human: a compact table, one row per target — findings per model (opus/sonnet), how many the merge kept vs discarded, which model reviewed best, and a one-line why. This comparison is a first-class deliverable (it's what proves the fan-out earned its cost and which model to trust next time), not an afterthought.

---

## Step 4 — Self-improve (the reason this skill gets sharper)

Append one dated line to `docs/COPY_STANDARDS.md` → **Learned**: a confirmed style rule, a recurring false-positive to pre-empt next run, or a per-model observation. This is the skill's memory — front-loading these into write time is what keeps the `/write-review` gate a green rubber-stamp instead of a rework trigger. Promote durable learnings up into Standards or Model notes when they stop being one-offs.

---

## Compliance handoff

`/ghost-bet` produces copy; it does not self-certify. The output still passes through `/write-review` (the batched compliance gate) once per PR-finish — same Standards, run as pass/fail. If ghost-bet did its job, the gate is clean. Then `/sure-bet` for the full definition-of-done, `/place-bet` for the PR body.
