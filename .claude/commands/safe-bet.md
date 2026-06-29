You are running the You-Bet **review flow** — the coherence + safety pass a branch goes through before it becomes a PR (or before the daily `/my-bet` commit). Run every step, then report findings grouped by severity and offer to fix. Don't fix silently — surface first.

---

## Step 1 — Establish what's under review

Bash. Pin down the scope:

```
git status
git diff main...HEAD --stat          # committed work on the branch
git diff main...HEAD                  # the actual diff
git diff                              # uncommitted changes
git log main..HEAD --format='%H %an <%ae>%n%B%n---'   # branch commits + messages
```

If a command returns nothing, skip it silently.

---

## Step 2 — Coherence

- Code does what its specs, comments, and the commit/PR description claim — no description promising behavior the code doesn't deliver.
- Naming is consistent and Rails-idiomatic. **Never abbreviated.**
- Docs touched in the same branch (SPRINT.md, ARCHITECTURE.md, devlog) stay consistent with the code change — numbers, names, and status all match.
- Commit message first line actually summarizes the change.

---

## Step 3 — Duplication

- No logic repeated that an existing helper, model, constant, or concern already covers (reuse before adding).
- No copy-pasted blocks that should be one source of truth — but don't flag single-caller indirection (`yagni:`).
- Shared values (seeds, constants, config) live in exactly one place.

---

## Step 4 — Sensitive info / commit safety

The guardrail. Scan **both the diff and the branch's commit history** — secrets survive in history even after a later commit deletes them.

```
git log -p main..HEAD | grep -iE 'api[_-]?key|secret|passwo?rd|token|BEGIN [A-Z ]*PRIVATE KEY|\.env'
git ls-files | grep -iE '\.env$|master\.key$|credentials\.yml\.enc$|\.pem$|\.p12$|id_rsa'
```

Check for:
- **Secrets**: API keys, tokens, passwords, `config/master.key`, `.env`, plaintext credentials, DB connection strings.
- **PII / real personal data** in seeds or fixtures.
- **Commit metadata**: author email and `Co-Authored-By` lines are the intended ones — no stray personal/internal addresses or wrong model attribution leaking.
- **Injection surfaces** in new code: raw SQL string interpolation, `eval`, `YAML.load`, `send`/`constantize` on user input, unparameterized `where("... #{}")`.

**Not sensitive — skip:** product/model names and reference constants in seeds (iPhone, Moto G, Honda CG 160, house-edge floats). Those are reference data, not secrets.

If a secret is found **already committed**, flag that deleting it in a new commit is NOT enough — the secret must be rotated and history rewritten (`git filter-repo` / BFG). Say so explicitly.

---

## Step 5 — Conventions & simplification

Tag findings with Gio's review tags:
- `delete:` dead or speculative code
- `stdlib:` hand-rolled where Ruby/Rails already provides it
- `native:` deps duplicating platform features
- `yagni:` single-caller abstractions, unused config
- `shrink:` logic that compresses to an equivalent shorter form

Plus: RuboCop clean, code/comments in English only, tests live alongside the feature (TDD), RSpec style (no helper methods — factories and inline setup only).

---

## Step 6 — Report

Group findings and lead with the worst:

- 🔴 **Blockers** — sensitive info, broken coherence, failing intent
- 🟡 **Should-fix** — duplication, convention breaks
- 🟢 **Nits** — `shrink:` / `yagni:` cleanups

If it's clean, say so plainly in one line. Then offer to apply the fixes (don't auto-apply).
