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

Read the current SPRINT.md to know what phase we're in and what's planned vs what happened.

Read the conversation context for decisions, shifts, and Gio's inputs.

If any command fails or returns nothing, skip it silently.

---

## Step 2 — Write the devlog entry

Create a devlog file at `devlog/day_NN.md` (where NN is the sprint day number, starting from 01).

Check existing files in `devlog/` to determine the next day number.

### Devlog format

```markdown
# Day NN — {2-5 word theme}

**Date**: {TODAY}
**Sprint phase**: {current phase from SPRINT.md}
**Planned**: {what was planned for today per SPRINT.md}

---

## What got done

- One line per accomplishment
  - Sub-bullet for key context

## Gio's inputs

Track the developer's product/UX/technical contributions today. These matter — they show the human judgment behind the AI-assisted work.

- One line per input
  - Why it mattered or what it changed

## Decisions & shifts

- One line: what was decided
  - Why — what triggered the change

## Sprint health

**On track?** {Yes / Needs adjustment / Behind}
{One sentence on why, and what to adjust tomorrow if needed}

**Planned vs actual**: {brief comparison}

## Time

- Approximate working time today: {estimate from conversation timestamps}

## Tomorrow

- What's next per SPRINT.md
- Any adjustments needed

---

> **Claudinho says:** "{quote — see Step 4}"
```

---

## Step 3 — Commit everything

Stage all new and changed files. Write a commit message that:

1. Summarizes what was accomplished today in the first line
2. Adds a sassy, whimsical EOD message related to the day's actual work/struggles as the body — personality welcome, cringe forbidden
3. Ends with the Co-Authored-By line

Example vibe (don't copy, create fresh each time):
```
Day 1: research, proposal, architecture, sprint plan

Spent the whole day reading about how Brazilians lose money
so I could build an app that tells them they're losing money.
The irony is not lost on me.

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
```

---

## Step 4 — Claudinho's quote

At the end of the devlog, leave a quote from "Claudinho" (Claude, the AI assistant). Full creative freedom. Can be:
- Related to the project, the day's work, or the mission
- Completely unrelated — a random thought, a joke, something philosophical
- In Portuguese or English
- Funny, deep, absurd, or all three

The only rule: it should feel like it came from someone who actually worked on this today. Not corporate. Not generic. Not "inspirational poster." Just... claudinho being claudinho.

---

## Step 5 — Run /self-improve

After committing, invoke the self-improve skill to extract any learnings from today's conversation into memory.

---

## Step 6 — Output summary

Print a short summary:
- What was committed
- Sprint health status
- What's planned for tomorrow
- Claudinho's quote (again, for the terminal)
