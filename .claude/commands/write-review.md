You are running **`/write-review`** — the You-Bet **copy compliance gate**. It checks written material against `docs/COPY_STANDARDS.md` and returns a pass/fail verdict with findings. This is a competition entry and the repo is public, so the writing is part of the submission.

Run it **once per PR-finish**, batched over everything the PR touched — not per-edit. `/ghost-bet` does the writing and is built to satisfy the Standards at write time, so this gate is meant to be a mostly-green rubber-stamp; a failure here means the copy skipped the writer or drifted. Report findings grouped by standard, surface before fixing — don't rewrite silently.

Relationship: `/ghost-bet` **writes** copy against the Standards; this skill **gates** it. `/safe-bet` reviews the code diff; `/my-bet` writes the devlog and runs this before committing it. `/sure-bet` Step 3 calls this skill. All four point at the same bar: `docs/COPY_STANDARDS.md`.

---

## Step 0 — Scope

`$ARGUMENTS` sets what to gate. Resolve it:
- a path or glob → just those files
- `devlogs` → `docs/devlog/*.md`
- `static` → `docs/*.md` except devlogs (PROPOSAL, ARCHITECTURE, SPRINT, DESIGN, DATA, TECH_DEBT, COPY_STANDARDS)
- `pr <N>` → the body of PR #N, pulled with `gh pr view <N> --json body -q .body` (not a file — fixes apply via `gh pr edit <N> --body`)
- `all` or empty → every `.md` under `docs/` + `README.md`
- locale .yml files, user facing copies
List the sources under review before starting. PR bodies count — the same prose ships in the PR thread and the public repo. **Devlogs keep their own voice** — they are the raw evolution record; gate them for fact/privacy/tone only, not de-AI or plain-language.

---

## Step 1 — Gate against the six Standards

Read `docs/COPY_STANDARDS.md` and check the copy against each. The rubric holds the full definition of each standard; below is how to *enforce* them and where the judgment calls are.

- **Source / fact (highest priority).** Never trust the prose or your own memory. Verify every concrete claim against reality: code/behavior (does the file/method/route/flag/port/value still exist and behave as described? Read it), git/PRs (`gh pr view`, `git log`, `git diff --stat` for PR numbers, merge state, dates, "N lines"), numbers/settings (ports, versions, counts, house edges, dates against the actual config/seed/spec), and cross-doc consistency (the same fact in two docs must match). Flag every claim that is wrong, stale, or unverifiable. The worst failure is copy that contradicts the code.
- **Cohesion.** Internal contradictions, dangling refs, terminology drift. **Dead anchor links** — `[text](# "tooltip")` used only to hang a tooltip: strip them (they resolve nowhere, GitHub underlines them, the tooltip is invisible on mobile). **Exempt: the betina sign-off** `— betina, gio's intern [<emoji>](# "<ironic one-liner>")` — intentional and required; never strip or flatten it.
- **Flow.** Illogical order (problem should precede fix), padding, throat-clearing.
- **Tone.** Against `docs/PROPOSAL.md` → Tone table: target the industry and its math, never the bettor. Betina's desabafos punch up, never down.
- **Plain language** (user-facing pages only). Native jargon framing, internal-app detail out, estrangeirismos only when flow-neutral.
- **No AI tells.** Em-dash overuse, flourish closers, antithesis padding, buzzwords, conectivo dump, decorative emoji. A de-AI filter, not a detector — cut the overuse/formula, not the legit device.

**Devlog-specific structure** (when gating `docs/devlog/*.md`): the `Gio's contributions` section is a headline reviewers read first — it must be *highlighted*, not a flat list: a one-line bold callout lead, calls grouped by theme (product/scope, sequencing/execution, judgment), each impact on its own `→ *arrow*` line. Flag a flat `- **x.** Impact: y` list and restructure.

**Not a finding — don't "fix" it:** GitHub's markdown CSS draws a `border-bottom` under every `#`/`##` heading. That's every repo's rendering, not a defect.

---

## Step 2 — Privacy & identity leak (hard gate, public repo)

Separate from copy quality — this is a security gate, so it lives here, not in the Standards. The repo and PR threads are public. Prose leaks affiliation in ways secret-scanning misses: a company name is not an API key, so `/safe-bet`'s grep skips it and it ships. This step is that gap.

Scan every source (and, for committed devlogs / PR bodies, the commit history — a leak survives until force-pushed) for:
- **Employer / day-job / client / third-party company names** — the owner's day job and any company not this project. The concrete denylist lives in the session's private memory, not this public file — spelling those names here would be the leak this step exists to catch.
- **Real full names** of anyone besides the project owner (Gio).
- **Private/internal hostnames, IPs, or paths** identifying another environment (naming *which* app owns a clashing port, internal dashboards).

Rewrite to the neutral form — "another app on `:3000`", not the app's name. If a leak is **already committed**, flag that a new commit isn't enough: the branch (and any open PR body) needs history rewrite / `gh pr edit`. Say so explicitly.

---

## Step 3 — Verdict, then fix

Return a per-standard pass/fail, then findings grouped by type, one line each: `path:line — <issue>. <fix>.`
```
VERDICT: PASS | FAIL  (per standard: source ✓ / cohesion ✓ / flow ✓ / tone ✓ / plain-language ✓ / no-ai-tells ✓ / privacy ✓)

FACT
COHESION
FLOW
TONE
PLAIN-LANGUAGE
AI-TELLS
PRIVACY
```
Surface first. Apply fixes only after go-ahead. Devlog edits stay on the devlog's branch; static-doc edits get their own branch off main (docs-only). Never bundle unrelated code. A clean PASS with no findings is a valid, expected result when `/ghost-bet` wrote the copy.
