You are running a **write review** on the You-Bet project — a prose-quality pass over written material (devlogs, static docs, PR bodies, About/landing copy) before it goes public. This is a competition entry and the repo is public, so the writing is part of the submission. Run every step, report findings grouped by type, and surface before fixing — don't rewrite silently.

`/write-review` complements the other skills: `/safe-bet` reviews the branch diff (code coherence, dup, sensitive info) before a PR; `/my-bet` writes the daily devlog and runs this flow before committing it. This one reviews the *text itself*.

---

## Step 0 — Scope

`$ARGUMENTS` sets what to review. Resolve it:
- a path or glob → just those files
- `devlogs` → `docs/devlog/*.md`
- `static` → `docs/*.md` except devlogs (PROPOSAL, ARCHITECTURE, SPRINT, DESIGN, DATA, TECH_DEBT)
- `pr <N>` → the body of PR #N, pulled with `gh pr view <N> --json body -q .body` (not a file — fixes apply via `gh pr edit <N> --body`)
- `all` or empty → every `.md` under `docs/` + `README.md`

List the sources under review before starting. PR bodies count — the same prose ships in the PR thread and the public repo.

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

## Step 3 — Cohesion, structure & rendering

- Internal contradictions (one paragraph describes a safety-net the next paragraph makes moot).
- Illogical order — reveal-then-explain vs explain-then-reveal; problem should precede fix.
- Dangling references (links, "see above", PR numbers) that don't resolve. **Dead anchor links** — `[text](# "tooltip")` used only to hang a tooltip: strip them. They resolve nowhere, GitHub underlines them like real links, and the `title` tooltip is invisible on mobile.
- Terminology drift — the same thing called different names across the doc.
- **`Gio's contributions` structure** (devlogs) — the section is a headline reviewers read first, so it must be *highlighted*, not a flat list: a one-line bold callout lead, calls grouped by theme (product/scope, sequencing/execution, judgment), and each impact on its own `→ *arrow*` line. Flag a flat `- **x.** Impact: y` list and restructure.

**Not a finding — don't "fix" it:** GitHub's markdown CSS draws a `border-bottom` under every `#`/`##` heading (looks like an underline). That's every repo's rendering, not a defect. `###`+ have no rule; demote heads only if the owner asks.

## Step 4 — Privacy & identity leak (public repo)

The repo and PR threads are public. Prose leaks affiliation in ways secrets scanning misses — a company name is not an API key, so `/safe-bet`'s secret grep skips it and it ships. This step is that gap.

Scan every source (and, for committed devlogs / PR bodies, the commit history — a leak survives in history until force-pushed) for:
- **Employer / day-job / client / third-party company names** — the owner's day job and any company not this project. The concrete denylist (specific names, domains, corporate SSO / ticket hosts) lives in the session's private memory, not this public file — spelling those names out here would be the exact leak this step exists to catch.
- **Real full names** of anyone besides the project owner (Gio).
- **Private/internal hostnames, IPs, or paths** that identify another environment (e.g. naming *which* app owns a clashing port, internal dashboards).

Rewrite to the neutral form — "another app on this machine", not the app's name. If a leak is **already committed**, flag that a new commit isn't enough: the branch (and any open PR body) needs history rewrite / `gh pr edit`. Say so explicitly.

## Step 5 — Tone (public / competition material)

Check against the brief's hard rules (`docs/PROPOSAL.md` → Tone table):
- **Target the industry and its math — never blame, ridicule, or judge the bettor.** No moralizing, no lecture, no spectacle. Empathy.
- Betina's desabafos / quotes must punch **up** (house, odds, predatory design), never **down** (the gambler). Keep the wit; redirect the target.
- Voice consistent with the brand (warm, knowing, anti-Tigrinho — see `docs/DESIGN.md`).

## Step 6 — Report, then fix

Group findings by type, one line each: `path:line — <issue>. <fix>.`
```
FACT
DUPLICATION
COHESION
PRIVACY
TONE
```
Surface first. Apply fixes only after go-ahead. Devlog edits stay on the devlog's branch; static-doc edits get their own branch off main (docs-only). Never bundle unrelated code.
