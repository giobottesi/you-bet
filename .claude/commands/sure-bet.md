You are running **`/sure-bet`** — the You-Bet **definition of done**. This is the single gate a change passes through before it becomes a PR, so any contributor delivers at the same bar as the core team. It orchestrates the existing skills rather than repeating them: run each step, report a pass/fail line per step, and only call the work done when every gate is green. Surface failures — never wave one through silently.

`$ARGUMENTS` optionally narrows scope (a card name, a branch). Default: the current branch's diff against `main`.

---

## Step 0 — Know what changed

Establish the diff and classify it:
```
git fetch origin && git diff --stat origin/main...HEAD
```
- **Code touched?** (`app/`, `config/`, `lib/`, `spec/`) → Steps 1–2 apply.
- **Prose touched?** (`docs/`, `*.md`, README, the PR body itself) → Step 3 applies.
- Public repo always → Step 4 applies.

List the files under review before starting. If an untracked handover/scratch doc sits in the repo root (e.g. `HANDOVER_NEXT.md`), it must **not** appear in the staged diff — `git add -A`/`git add .` will sweep it in; `git reset <doc>` to unstage, and prefer scoped `git add app/ spec/ …`.

---

## Step 1 — Tests & lint green (code changes)

Nothing ships red. This stack runs in Docker:
- Specs: `docker exec -e RAILS_ENV=test you-bet-web-1 bundle exec rspec` — `RAILS_ENV=test` is mandatory (the container defaults to `development`, whose host-auth config 403s the specs).
- RuboCop: `docker exec you-bet-web-1 bundle exec rubocop`.
- The pre-commit hook (gems + db + rubocop + rspec) must pass — it runs on commit; don't bypass with `--no-verify`.

New behavior ships **with** its tests (TDD — tests are written with the feature, never as a later phase). FactoryBot + nested `let`; never stub a whole chain.

## Step 2 — Code review (`/safe-bet`)

Run `/safe-bet` over the diff. It covers coherence, duplication, **sensitive-info / commit safety**, and conventions + simplification tags (`delete`/`stdlib`/`native`/`yagni`/`shrink`). Fix 🔴 blockers before proceeding; decide 🟡s explicitly.

## Step 3 — Prose review (`/write-review`)

If the change touches any prose — docs, a devlog, or the **PR body you're about to write** — run `/write-review` on it (`pr <N>` scope for a body already pushed). It fact-checks every concrete claim against the code, kills duplication, checks cohesion/structure, scans for **privacy/identity leaks**, and holds the tone bar. A PR description is public prose; it goes through this too.

## Step 4 — Privacy (public repo)

This repo, its PR threads, and its history are public competition material. Confirm the change names **no** employer, day-job, client, third-party company, other people's real names, or private/internal hostnames — use a neutral form ("another app on `:3000`", not the app's name). This is `/write-review` Step 4; run it explicitly here because an external contributor may not know which names are off-limits. A leak already committed needs history rewrite, not just a new commit.

## Step 5 — Conventions

- **Rails-idiomatic naming**, Action+Noun (`PriceFetcher`, not `PriceHandler`). **Never abbreviate** — `simulation_result`, not `sim_res`; break a long line rather than shorten a name.
- **Decision ladder** before adding code: skip (YAGNI) → reuse → stdlib → installed deps → one-liner → minimal. Deletion over addition; boring over clever; shortest effective diff; root cause over symptom.
- **Comment style**: one tight what/why line, no verbose blocks.
- No new concern/base class/shared module for 2-class duplication.

## Step 6 — PR hygiene

- **Small PR** — one card or a tight group. Unrelated/UI fixes get their own branch off `main`.
- **Own branch off `main`.** Docs-only changes (devlogs, doc sweeps) never ride a feature branch.
- **Dense, quick-to-read description** — draft it with `/place-bet`, which enforces the format (context line → `## What` → numbered present-tense `## Technical summary` → optional `## References`) and keeps every claim honest to the diff. PR descriptions are the project's living docs.
- **Re-sync an already-open PR's description to the final diff.** If the branch moved after the PR was opened (review fixes, extra commits, a design pivot), the numbered summary now lies. Re-read `git diff origin/main...HEAD`, rewrite the summary and any claim the code no longer supports, then `gh pr edit`. A stale body is a defect, not a nicety — treat it as a FAIL until fixed.
- **English only** in code, comments, names, commits, and PR bodies (i18n locale files are the sole exception).
- **Sign-off:** an AI session signs with its assistant persona in the established pattern — `— <name>, <role> <fresh-emoji>` with an ironic-rationale emoji hover. Read the assistant name from the project's signature memory; if none is recorded (a fresh contributor setup), **prompt the contributor once for what to call their AI assistant, persist it, then sign** — don't hardcode the core session's `betina, gio's intern`. Human contributors sign as themselves. Commit trailer: `Co-Authored-By:` the author.
- **Never self-merge.** Gio reviews.

---

## Step 7 — Verdict

Report one line per step: `Step N — <PASS/FAIL> — <detail>`. The work is a **sure bet** only when every step is green.

When anything is red or open, don't open the PR — present a **numbered list the dev answers**, split into two groups so they can act fast:

1. **Blockers** — hard failures that must be fixed before the PR (red tests, a privacy leak, a convention violation). Each numbered, with the exact fix.
2. **Decisions (not scoped)** — judgment calls that aren't clearly in or out of this change (a 🟡 from `/safe-bet`, an optional refactor, a borderline scope creep). Each numbered, with the tradeoff, for the dev to rule on.

Stop after the list; resume only on the dev's answers — never wave a blocker through or self-decide a scope call.
