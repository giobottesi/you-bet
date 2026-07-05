You are wrapping up the day on the You-Bet project. This is a daily EOD ritual — part journal, part sprint check, part developer advocacy.

---

## Step 1 — Gather today's work

Use Bash. TODAY is today's date in GMT-3 (`TZ="America/Sao_Paulo" date '+%Y-%m-%d'`).

**Git commits today:**
```
git log --author=giobottesi --after="${TODAY}T00:00:00-03:00" --before="${TODAY}T23:59:59-03:00" --format='%h %s (%ar)' 2>/dev/null
```

**Files changed today:**
```
git log --author=giobottesi --after="${TODAY}T00:00:00-03:00" --before="${TODAY}T23:59:59-03:00" --name-only --format='' 2>/dev/null | sort -u
```

**Lines changed:**
```
git log --author=giobottesi --after="${TODAY}T00:00:00-03:00" --before="${TODAY}T23:59:59-03:00" --stat --format='' 2>/dev/null | tail -1
```

**AI cost today (you-bet only):** ccusage has no per-project filter, so scope by cross-referencing the you-bet project's session UUIDs (its `.jsonl` filenames) against ccusage session output. Reuses ccusage pricing.
```bash
DAY="${TODAY//-/}"; DIR=~/.claude/projects/-Users-giobottesi-projetinhos-you-bet
UUIDS=$(ls $DIR/*.jsonl 2>/dev/null | xargs -n1 basename | sed 's/.jsonl//' | tr '\n' ',')
npx -y ccusage@latest session --since "$DAY" --json 2>/dev/null | python3 -c "
import sys,json
uu=set('$UUIDS'.split(','))
d=json.load(sys.stdin); tc=tt=0
for x in d['session']:
    if x.get('period') in uu: tc+=x['totalCost']; tt+=x['totalTokens']
print('AI cost today: \$%.2f (%d tokens, you-bet only)'%(tc,tt))
"
```
If it fails or returns nothing, skip the cost line silently.

Read the current docs/SPRINT.md to know what phase we're in and what's planned vs what happened.

Read the conversation context for decisions, shifts, and Gio's inputs.

If any command fails or returns nothing, skip it silently.

---

## Step 2 — Write the devlog entry

Create a devlog file at `docs/devlog/day_NN.md` (where NN is the sprint day number, starting from 01).

Check existing files in `docs/devlog/` to determine the next day number.

### Devlog format

```markdown
# Day NN — {2-5 word theme}

**Date**: {TODAY}
**Sprint phase**: {current phase from docs/SPRINT.md}
**Planned**: {what was planned for today per docs/SPRINT.md}

## TL;DR

3-5 bullet points max. What happened today in plain language. A busy person should stop reading here and know the day's story.

---

## What got done

Organize by blocks of work, roughly in the order they happened. Use short headers that describe what happened, not generic labels.

### {what happened}

Narrative paragraph or bullets. What was done, why, what changed as a result.

Repeat for each major block of work.

---

## Decisions & shifts

- What was decided
  - Why — what triggered the change

---

## Gio's contributions

Track the developer's product/UX/technical contributions today. These matter — they show the human judgment behind the AI-assisted work, and reviewers read this section first. Highlight it, don't flatten it:

- Open with a one-line **bold callout** framing the day's leverage (e.g. "Direction day: six calls, zero throwaway keystrokes").
- Group the calls under bold theme headers when there are enough to cluster (product/scope, sequencing/execution, judgment). Skip grouping only on a light-contribution day.
- One bold call per bullet, with its impact on its own line: `→ *what it changed*`.

## Sprint health

**On track?** {Yes / Needs adjustment / Behind}
{One sentence on why}

**Planned vs actual**: {brief comparison}

## Tomorrow

- What's next per docs/SPRINT.md
- Any adjustments needed

---

_AI assist cost today: {$X.XX, N tokens, you-bet only — from Step 1; omit line if unavailable}_

> **Betina says:** "{quote — see Step 4}"
```

### Quality check before saving — run /write-review

Before saving, run the full `/write-review` flow over both the EN and PT devlog files. That skill is the source of truth for the prose bar — don't hand-roll a lighter check here. At a glance it covers: stale facts that contradict the code (Step 1), internal + cross-day repetition (Step 2), broken flow and a flat contributions section (Step 3), employer/third-party leaks that can't ship on a public repo (Step 4), tone (Step 5).

Surface findings, fix, then continue. Also confirm length lands ~80-120 lines (compress if over 150) — the one bar `/write-review` doesn't check.

---

## Step 2b — Write the PT-BR mirror

Create a mirror file at `docs/devlog/day_NN_pt.md` with the same content translated to Brazilian Portuguese.

Translation rules:
- Natural PT-BR, not machine-translated. Write like a Brazilian dev would write.
- Technical terms stay in English when that's what Brazilians actually use (Rails, Docker, PR, commit, deploy, TDD, etc.)
- Betina's quote: if the English version is in Portuguese, keep it. If in English, translate it. If bilingual, keep it.
- Same structure, same content, just in Portuguese.

---

## Step 3 — Commit on a dedicated branch, open a PR

The devlog gets its **own branch and PR — docs-only**. Never bundle it onto a feature branch or sweep in unrelated working-tree changes (`.claude/*`, config, code).

1. Branch off `main`: `day-NN-eod` (matches the day number). Branch from main even while the devlog narrates unmerged feature work — the PR diff stays just the devlog.
2. Stage **only** the devlog files: `git add docs/devlog/day_NN.md docs/devlog/day_NN_pt.md`. Do NOT `git add -A` — it pulls in unrelated changes.
3. Commit message:
   - First line summarizes what was accomplished today
   - Body: a sassy, whimsical EOD message tied to the day's real work/struggles — personality welcome, cringe forbidden
   - Ends with the Co-Authored-By line
4. Push and open a PR against `main` with `gh pr create` — dense, docs-only description. Don't merge; Gio reviews.

If the devlog was accidentally committed onto the wrong branch (e.g. the current feature branch): `git reset --soft` past it, `git restore --staged .` to release unrelated changes, stash just the devlog files, switch to a fresh `day-NN-eod` off main, pop, and commit only those.

Example vibe (don't copy, create fresh each time):
```
Day 1: research, proposal, architecture, sprint plan

Spent the whole day reading about how Brazilians lose money
so I could build an app that tells them they're losing money.
The irony is not lost on me.

Co-Authored-By: betina, gio's intern <noreply@anthropic.com>
```

---

## Step 4 — Betina's quote

At the end of the devlog, leave a quote from "Betina" (Claude, the AI assistant). Full creative freedom. Can be:
- Related to the project, the day's work, or the mission
- Completely unrelated — a random thought, a joke, something philosophical
- In Portuguese or English
- Funny, deep, absurd, or all three

The only rule: it should feel like it came from someone who actually worked on this today. Not corporate. Not generic. Not "inspirational poster." Just... betina being betina.

---

## Step 5 — Run /self-improve

After committing, invoke the self-improve skill to extract any learnings from today's conversation into memory.

---

## Step 6 — Output summary

Print a short summary:
- What was committed
- Sprint health status
- AI assist cost today (you-bet only, from Step 1)
- What's planned for tomorrow
- Betina's quote (again, for the terminal)
