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
| 6 | Copy / i18n | Bet-type card shows `casa X%` with no explanation of what the % means | "House edge" is jargon for BR bettors; app is mobile-first so a hover `title` tooltip is dead on touch; picker also mixes hardcoded-English headings with i18n'd type names | Localize the whole picker (heading/hint/badge) and add a tap-friendly house-edge explainer (inline glossary line or first-use hint), not a hover tooltip | 🟡 | FE 02 review |

## Notes

- This file is the source of truth for "we know, it's on the list." If it's not here, it's not tracked — add it.
- When you pay something down, delete the row and reference the PR in the commit so history keeps the trail.
