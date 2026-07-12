# Tech Debt

Running ledger of known shortcuts, deferred decisions, and "fix later" items. Add a row when you knowingly defer something; remove it when it's paid down (link the PR).

Severity: 🔴 will bite before launch · 🟡 should fix · 🟢 nice-to-have.

| # | Area | Item | Why it's debt | Proposed fix | Sev | Surfaced |
|---|------|------|---------------|--------------|-----|----------|
| 1 | Seeds | `db/seeds.rb` is a single file every model PR edits | Two PRs touching it collide; a force-resolve can silently drop one model's seeds | Split into `db/seeds/*.rb` loaded by a loop so each model owns its file | 🟡 | PR #10 review |
| 2 | Tooling | Pre-commit hook can't tell "checks failed" from "docker down" | When the `web` container is down, `docker compose exec` fails and the hook blocks every commit | Add a guard: if `web` isn't running, skip with a warning instead of denying | 🟡 | PR #13 |
| 3 | Data model | `value` is stored/cast by `value_type` with no precision policy | Float vs BigDecimal undecided; compounded rates (poupança) need BigDecimal to avoid drift | Decide per-type; use BigDecimal for `decimal`, document the rule | 🟡 | #9 / #10 review |
| 4 | Rate limiting | Rack::Attack throttles key on `request.ip` | Behind Heroku's router the IP resolves from `X-Forwarded-For`, which a client can spoof to dodge the per-IP limit | Key on a trusted signal (visitor cookie) or pin the trusted-proxy chain if abuse appears | 🟢 | PR #31 review |
| 5 | View layer | FE widgets are plain partials + Stimulus, no encapsulation or isolated tests | Partials share a global namespace, leak logic to helpers, and can only be tested through a full view render | Migrate reusable widgets (results/comparison/context/share cards first) to ViewComponent — typed props + isolated unit tests. Good contributor-friendly starter task | 🟢 | FE 02 structure decision |
| 6 | Copy / UX | Bet-type card shows `casa X%` with no explanation of what the house edge % means | "House edge" is jargon for BR bettors; app is mobile-first so a hover tooltip is dead on touch | Add a tap-friendly house-edge explainer (inline glossary line or first-use hint) | 🟡 | FE 02 review |
| 7 | i18n | Full-page localization is incomplete and there is no parity gate | The FE-02 picker is fully localized, but the FE-01 hero/CTA and other views are still hardcoded English, so the page renders mixed under `?locale=pt-BR`. `i18n-tasks` isn't in the Gemfile, so nothing catches missing or untranslated keys | Sweep the remaining views into the locale files (hero/CTA first), then add `i18n-tasks` + a `health` check to the pre-commit hook so key parity is enforced | 🟡 | FE 02 review |
| 8 | View layer / CSS | `application.css` is growing unbounded and some styling still lives as inline Tailwind utilities in the HTML | The sheet bloats with each FE card and inline utilities scatter styling across templates, making a later cleanup harder the longer it waits | Dedicated CSS pass on its own branch: dedupe the sheet and extract inline Tailwind into component classes | 🟢 | PR #59 review |
| 9 | Tooling / i18n | No browser UI for editing the locale YAML | Hand-editing YAML is error-prone and slows copy iteration; a web editor would speed the pt-BR/en round-trip | Investigate a locale-editing gem/UI (some ship a browser editor) and scope separately from the #7 parity gate | 🟢 | PR #59 review |
| 10 | View layer / devlog | The whole devlog rendering flow (`DevlogReader` file reads + `DevlogEntry` markdown parsing + per-request redcarpet render) is a static-file stopgap | It reads and parses committed `.md` on every request; the render path (title/section split, markdown per request) works but hasn't had an end-to-end design review, and the entries really belong in a real model | Review the flow end to end; migrate `docs/devlog/*.md` to a DB-backed blog model, retiring `DevlogReader`. Tracks the parked devlog follow-up | 🟢 | PR #69 review |

## Notes

- This file is the source of truth for "we know, it's on the list." If it's not here, it's not tracked — add it.
- When you pay something down, delete the row and reference the PR in the commit so history keeps the trail.
