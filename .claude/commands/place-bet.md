You are running **`/place-bet`** — the PR-description convention. A PR body is the project's living documentation and the reviewer's first read; this skill turns a diff into a description at the team bar, or audits an existing body against its diff. It is the writing half of PR hygiene — `/sure-bet` Step 6 delegates the description format here.

`$ARGUMENTS` optionally sets the mode/scope: a branch name (default: current branch vs `main`), or `pr <N>` to audit/rewrite an already-pushed body. Default: draft a body for the current branch's diff.

---

## Step 0 — Read the diff, then read the repo's conventions

1. Establish the change: `git fetch origin && git diff origin/main...HEAD` (+ `--stat` for the file list). The description describes **what the diff does**, not what the card hoped to do.
2. **Respect the local repo's section rules.** This convention travels across repos — do not impose You-Bet's exact headers everywhere. Detect the host repo's PR shape first, in this order, and adopt it:
   - `.github/PULL_REQUEST_TEMPLATE.md` (or `.github/PULL_REQUEST_TEMPLATE/*`) — if present, its sections are authoritative; fill them.
   - Recent merged PR bodies (`gh pr list --state merged --limit 5 --json body`) — match the house structure.
   - The repo's `CLAUDE.md` / contributing docs for a stated format.
   - No local convention found → use the default shape below.
   Whatever the section headers, the **core** (Step 2) is non-negotiable.

---

## Step 1 — Default shape (when the repo states none)

```
<context line — optional>

## What
<dense prose + bullets>

## Technical summary
1. <present-tense change>
2. ...

## References
- <real cited URL> — <what it informed>
```

- **Context line** (top, one line, optional): orienting facts a reviewer needs before the body — stacking/base (`Stacks on #NN, retarget to main after it merges`), which schema/PR the copy is written against, a design pivot. Skip it if there's nothing to orient.
- **## What**: dense, quick-to-read prose — what the change delivers and how it maps to what the code actually does. Bullets for the substantive facts (the data model, the real behavior, the honest caveats). A reviewer should understand the change without opening a file.
- **## References**: only when external sources informed the work (research, a spec, a standard). Real URLs only — never invent or guess a link. Omit the section entirely if empty.

## Step 2 — The core (every repo, non-negotiable)

1. **Technical summary is numbered, present tense, one item per logical change** — `Add X to Y with Z` / `Create W for V` / `Change A to B`. One logical change per line, not one file per line.
2. **Honest to the code.** Every claim in the body must be true of the diff — no promising behavior the code doesn't deliver, no describing a plan the code abandoned. This is the same bar as `/safe-bet` coherence; a body that oversells is a defect.
3. **Dense but quick to read.** Cut filler. A reviewer skims the summary in seconds and reads *What* in under a minute.
4. **English only** — code, comments, names, and the PR body. (i18n locale files are the sole place other languages live.)
5. **No privacy/identity leak** — no employer, client, third-party company, real names, or private hostnames when the repo is public. This is `/write-review` Step 4; apply it to the body.

## Step 3 — Audit mode (`pr <N>` or a body that already exists)

When the branch moved after the body was written, the summary now lies. Re-read `git diff origin/main...HEAD`, then:
- Flag every claim the code no longer supports (removed behavior, renamed symbol, dropped step).
- Rewrite the numbered summary and *What* to the final diff.
- `gh pr edit <N> --body-file <file>` to sync. A stale body is a FAIL, not a nicety.

---

## Step 4 — Emit

Output the finished body (ready for `gh pr create --body-file`), and — if any concrete claim couldn't be verified against the diff — a short numbered list of what the author must confirm before it ships. Do not fabricate detail to fill a section; an honest short body beats a padded one.
