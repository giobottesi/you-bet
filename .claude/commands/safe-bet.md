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

Plus: RuboCop clean, code/comments in English only, tests live alongside the feature (TDD), RSpec style (no helper methods — factories and inline setup only; group a class's constant assertions under one `describe 'constants'`, not one describe per constant).

**Stimulus controllers** (hardest to review — hold the line):
- **Method names follow Rails naming — say what the method does.** Verb-first, Action+Noun, no vague `sync`/`handle`/`update`/`process`. `updateArrows`, not `sync`; `validateSelection`, not `check`. The name is the first comment.
- **One job per method, with a one-line intent comment.** If a method needs "and" to describe it, question the split.
- **Element-size or scroll-dependent state uses a `ResizeObserver` on the element**, not a `window` `resize` listener — the latter misses reflows the window didn't cause (font load, sibling layout). Every observer/listener opened in `connect()` is torn down in `disconnect()`.
- **User-facing strings arrive via `values` from the i18n locale files** — never hard-coded in the controller.
- **Reach for `static targets`/`static values`, not manual `querySelector`/`dataset`** where a target or value fits.

---

## Step 6 — Prose review (docs, devlogs, PR body)

If the branch touches any written material — `docs/**/*.md` (static docs or devlogs), `README.md`, or the PR description — run `/write-review` on those files before reporting. The repo is public competition material: fact-check claims against code/git, cut duplication (internal + cross-doc), check cohesion, and enforce the brief's tone (target the industry, never the bettor). Fold its findings into the report below.

---

## Step 7 — Report

Group findings and lead with the worst:

- 🔴 **Blockers** — sensitive info, broken coherence, failing intent
- 🟡 **Should-fix** — duplication, convention breaks
- 🟢 **Nits** — `shrink:` / `yagni:` cleanups

If it's clean, say so plainly in one line. Then offer to apply the fixes (don't auto-apply).

---

## Step 8 — Signature gate (before any `gh pr create` / `gh pr edit`)

The recurring blind spot. When this review precedes opening or updating a PR:

**Intern name — chosen once, per setup.** The persona is `<intern>, <owner>'s intern`. Read the name from the signature memory. **If none is recorded (first time in this setup), ASK the user what to call their AI assistant before signing anything, then save it as a memory** — do not assume a default. For this repo the recorded answer is `betina` (owner `gio`).

- **Commit trailer**: `Co-Authored-By: <intern>, <owner>'s intern <noreply@anthropic.com>` — never a made-up email, never a `Claude` attribution line.
- **PR body / any `gh` comment**: must END with `— <intern>, <owner>'s intern [<emoji>](# "<rationale>")` — freshly-derived ironic emoji, hover-label link form. The hover text is the **ironic rationale** (why the emoji is a counterpoint to what's being signed), NOT the literal thing it depicts. **Strip the default `🤖 Generated with Claude Code` footer** — the harness adds it, this convention overrides it.

Do NOT infer signing from `git log` (history shows the generic line because the owner post-rewrites it). Apply directly from the signature memory every time.
