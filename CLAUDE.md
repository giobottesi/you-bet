# You-Bet

## Stack

Ruby on Rails, PostgreSQL, RSpec, FactoryBot. No frontend yet.

## Code Conventions

### Naming
- Rails-idiomatic naming always. Action+Noun pattern: `PriceFetcher` (gets data), not `PriceHandler` (vague).
- Never abbreviate names. `simulation_result` not `sim_res`; `weekly_amount_cents` not `wkly_amt`. If RuboCop complains about line length, break the line — don't shorten the name.

### Patterns
- Per-entity state: aggregate on unique combinations, not per-occurrence rows.
- Safe reversibility: soft-delete with timestamps; preserve audit trail.
- Comment style: one tight what/why line. No multi-line verbose blocks.

### Decision Ladder
Before writing code, walk top-to-bottom. Stop at the first rung that solves the problem.
1. Skip (YAGNI) — does this code need to exist?
2. Reuse codebase — existing helpers/patterns that already solve it.
3. Standard library — built-in language/framework features first.
4. Installed dependencies — already-installed packages before adding new ones.
5. One-liner — can it fit in a single expression? Do that.
6. Minimal code — smallest working implementation. No speculative structure.

### Principles
- Deletion over addition — removing code is preferable when both solve the problem.
- Boring beats clever — straightforward code over clever tricks.
- Shortest effective diff — fewer changed files, fewer changed lines.
- Root cause over symptom — fix why it broke, not what broke.

### Review Tags
When reviewing code, tag findings with:
- `delete:` — dead code, speculative features.
- `stdlib:` — hand-rolled code the standard library already provides.
- `native:` — dependencies duplicating platform capabilities.
- `yagni:` — single-implementation abstractions, unused config, single-caller indirection.
- `shrink:` — logic that compresses to fewer lines with an equivalent shorter form.

## Testing

TDD — tests are written WITH features, not as a separate phase. FactoryBot + nested let. Never stub entire chains. Include test time in the feature estimate.

## PR Hygiene

- Small PRs: one card or a tight group.
- Dense but quick-to-read description. PR descriptions are the project's living docs.
- All code, comments, names, commit messages, and PR descriptions in English (only i18n locale files hold other languages).
- When multiple PRs touch shared files, review and merge one at a time.
- Unrelated/UI fixes get their own branch off main.

### PR Technical Summary Format
Numbered list of changes in present tense, one item per logical change:
1. Add X to Y with Z
2. Create new W for V
3. Change A to B

## Skills

- `/safe-bet` — pre-PR review flow: coherence, duplication, sensitive info, convention checks. Run before opening any PR.
- `/write-review` — prose-quality pass over written material (devlogs, docs, PR bodies): fact-check, duplication, cohesion, privacy/identity leak, tone.
- `/sure-bet` — the definition of done. Orchestrates tests/lint + `/safe-bet` + `/write-review` + privacy + conventions + PR hygiene into one gate. Run before any PR so contributors ship at the team bar.
- `/my-bet` — EOD devlog ritual: journal + progress snapshot.

## Token Economy (always-on)

These rules apply from turn one. Not conditional on session length.

### Read discipline
- Scope every Read with offset/limit when the target location is known.
- Never re-read a file just written/edited — the harness tracks state.
- Never use Bash (cat/sed/head) to read — use the Read tool.

### Delegation
- Broad exploration (multi-file, "where is X used") -> delegate to subagent, return file:line table only.
- Single known file/symbol -> inline Read/Grep, no agent.
- Don't duplicate work already delegated to a subagent.

### Subagent returns
- Request file:line coordinates and conclusions, never prose narratives.
- Subagent should return exact offsets so main can Read with offset/limit.

### Output
- Batch independent tool calls in one message.
- Decide, don't deliberate — pick and move, don't weigh options in-context.
- Caveman mode ON for all mechanical work (auto-toggle, no announcement).

### Reference
Full framework: `~/.claude/token-budget-framework.md`
