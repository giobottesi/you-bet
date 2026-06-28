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

## TL;DR

3-5 bullet points max. What happened today in plain language. A busy person should stop reading here and know the day's story.

---

## Timeline

Organize the day chronologically, not by category. Each section is a block of work that happened in sequence. Use short headers that describe what happened, not generic labels.

### {time-ish} — {what happened}

Narrative paragraph or bullets. Include:
- What was done
- Why (what triggered it)
- Key decisions and who made them
- What changed as a result

Repeat for each major block of work.

---

## Gio's contributions

Track the developer's product/UX/technical contributions today. These matter — they show the human judgment behind the AI-assisted work.

- One line per input
  - Impact: what it changed

## Sprint health

**On track?** {Yes / Needs adjustment / Behind}
{One sentence on why}

**Planned vs actual**: {brief comparison}

## Tomorrow

- What's next per SPRINT.md
- Any adjustments needed

---

> **Claudinho says:** "{quote — see Step 4}"
```

### Quality check before saving

Before saving the devlog file, review it for:

1. **Duplications** — same fact stated twice in different sections? Merge or cut.
2. **Inconsistencies** — does the TL;DR match the body? Do numbers/names match throughout?
3. **Repetition with previous days** — read the previous day's devlog. Don't re-explain context that was already covered. Reference it instead: "Continuing from yesterday's architecture work..."
4. **Flow** — does it read like a story of the day, or like a dumped list? The timeline structure should create natural narrative flow.
5. **Length** — aim for 80-120 lines. If over 150, you're being too detailed. Compress.

---

## Step 2b — Write the PT-BR mirror

Create a mirror file at `devlog/day_NN_pt.md` with the same content translated to Brazilian Portuguese.

Translation rules:
- Natural PT-BR, not machine-translated. Write like a Brazilian dev would write.
- Technical terms stay in English when that's what Brazilians actually use (Rails, Docker, PR, commit, deploy, TDD, etc.)
- Claudinho's quote: if the English version is in Portuguese, keep it. If in English, translate it. If bilingual, keep it.
- Same structure, same content, just in Portuguese.

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
