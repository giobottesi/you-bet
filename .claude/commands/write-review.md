You are running a **write review** on the You-Bet project — a prose-quality pass over written material (devlogs, static docs, PR bodies, About/landing copy) before it goes public. This is a competition entry and the repo is public, so the writing is part of the submission. Run every step, report findings grouped by type, and surface before fixing — don't rewrite silently.

`/write-review` complements the other skills: `/safe-bet` reviews the branch diff (code coherence, dup, sensitive info) before a PR; `/my-bet` writes the daily devlog. This one reviews the *text itself*.

---

## Step 0 — Scope

`$ARGUMENTS` sets what to review. Resolve it:
- a path or glob → just those files
- `devlogs` → `docs/devlog/*.md`
- `static` → `docs/*.md` except devlogs (PROPOSAL, ARCHITECTURE, SPRINT, DESIGN, DATA, TECH_DEBT)
- `all` or empty → every `.md` under `docs/` + `README.md`

List the files under review before starting.

---

## Step 1 — Fact-check against reality (highest priority)

Never trust the prose or your own memory. Verify every concrete claim against a real source:
- **Code/behavior** — does the file/method/flag/port/value the text names still exist and behave as described? (Read the code, don't assume.)
- **Git/PRs** — PR numbers, merge state, dates, "N lines" claims → `gh pr view`, `git log`, `git diff --stat`.
- **Numbers & settings** — ports, Ruby/gem versions, counts ("56 examples", "10 comparison prices"), house edges, dates. Cross-check the actual config/seed/spec.
- **Cross-doc facts** — the same fact stated in two docs must match (e.g. hosting target, Ruby version, port, model names).

Flag every claim that is wrong, stale, or unverifiable. This is the failure that matters most: a devlog once shipped saying the pre-commit hook "skips when the DB is down" *after* it was changed to require the DB — the text contradicted the code.

## Step 2 — Duplication

- **Internal** — the same point stated more than once in one file (TL;DR vs body vs Decisions is the usual offender). Each section should add, not restate. Merge or cut.
- **Cross-doc** — the same explanation copy-pasted across docs, or the same fact narrated three different ways. Pick one home; reference it from the others.

## Step 3 — Cohesion & flow

- Internal contradictions (one paragraph describes a safety-net the next paragraph makes moot).
- Illogical order — reveal-then-explain vs explain-then-reveal; problem should precede fix.
- Dangling references (links, "see above", PR numbers) that don't resolve.
- Terminology drift — the same thing called different names across the doc.

## Step 4 — Tone (public / competition material)

Check against the brief's hard rules (`docs/PROPOSAL.md` → Tone table):
- **Target the industry and its math — never blame, ridicule, or judge the bettor.** No moralizing, no lecture, no spectacle. Empathy.
- Betina's desabafos / quotes must punch **up** (house, odds, predatory design), never **down** (the gambler). Keep the wit; redirect the target.
- Voice consistent with the brand (warm, knowing, anti-Tigrinho — see `docs/DESIGN.md`).

## Step 5 — Report, then fix

Group findings by type, one line each: `path:line — <issue>. <fix>.`
```
FACT
DUPLICATION
COHESION
TONE
```
Surface first. Apply fixes only after go-ahead. Devlog edits stay on the devlog's branch; static-doc edits get their own branch off main (docs-only). Never bundle unrelated code.
