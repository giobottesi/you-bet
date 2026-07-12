# You-Bet — Copy Standards

The single source of truth for what good written copy is in this repo. `/ghost-bet` **writes to** these standards; `/write-review` **gates against** them. Keep the two in sync by keeping them both pointed here.

Scope: every public-facing or committed word — user-facing UI copy (locales), static docs, README, PR bodies. **Not devlogs** — those are the raw evolution record and keep their own voice.

---

## Standards (the compliance bar)

A piece of copy passes when it clears all six. `/write-review` checks these once per PR; `/ghost-bet` is built to satisfy them at write time so the gate rarely fails.

1. **Source / fact** — every concrete claim (number, PR ref, route, model/method name, date, house edge) is true against the code or a cited primary source. Deep-link citations, don't homepage them. Verify, never trust prose or memory. This is the highest-priority check: the worst failure is copy that contradicts the code (a doc once said the pre-commit hook "skips when the DB is down" after it was changed to require the DB).
2. **Cohesion** — no internal contradictions, no dangling refs (links, "see above", anchors, PR numbers that don't resolve), no terminology drift (the same thing named two ways). One home per fact; reference it elsewhere.
3. **Flow** — problem precedes fix, reveal follows setup, order is logical. Short sentences carry weight. Cut throat-clearing and padding.
4. **Tone** (competition rule, `docs/PROPOSAL.md`) — target the industry and its math; **never** blame, ridicule, or judge the bettor. Wit punches up (house, odds, predatory design), never down. Warm, knowing, anti-Tigrinho.
   - **Punch-up grammar (subject test).** Blame lives in the *grammatical subject*, not just word choice. When a stat is about harm, make the **industry/house the actor** and the person the one it's done *to* — never make the vulnerable the active doer of their own loss. "5 million poor families *sent* R$3 bi" (people as givers → reads as their fault) → "the bets *took* R$3 bi, *hitting* 5 million people" (house extracts; people are hit). Prefer verbs where the house acts on people: bets *took / pulled / pushed into debt / put at risk / reached*. Same numbers, flipped subject. Run this test on every sentence whose subject is a bettor/family/person.
5. **Plain language** (user-facing pages only — privacy, sources, about, help, in-app copy) — comprehension by someone with zero tech literacy, in both locales. Define jargon in the **native** everyday framing, not an invented or translated analogy (cookie = "pequeno arquivo de texto que o site salva no seu navegador", per ANPD — not "coat-check ticket", which reads translated). Keep internal-app detail out of user copy. Widely-understood estrangeirismos (cookie, site, link) are fine when they don't break flow.
6. **No AI tells** — readers are sick of them; they read machine-written. This is a de-AI *filter*, not a detector — em-dashes and triads are legit human devices, so cut the *overuse/formula*, not the tool:
   - Em-dash overuse for dramatic pauses → periods + short sentences.
   - Flourish closers ("That's all.", "Simple as that.", "e isso muda tudo", "É simples assim.") → cut.
   - Antithesis padding ("not just X — it's Y", "não é apenas X, mas Y", "a force multiplier, not a replacement") → say it plainly.
   - Rule-of-three padding, buzzwords (leverage, seamless, robust, delve, elevate, testament to, tapestry, navigate the landscape).
   - Throat-clearing ("it's important to note that", "vale ressaltar").
   - PT conectivo dump (além disso / no entanto / dessa forma / por outro lado).
   - Decorative emoji in prose. (The betina sign-off's ironic-hover emoji is exempt.)

Privacy/identity leak is enforced separately by `/write-review` Step (public-repo employer/name/host scan) and `/safe-bet` — it's a hard gate, not a copy-quality standard, so it lives in the review flow, not here.

---

## Model notes (for the `/ghost-bet` fan-out)

Empirically calibrated from the multi-model docs-refinement run (8 targets × 3 models, 2026-07-11):

- **Opus 4.8 — adjudicates truth.** Best at fact-verification: caught stale `DevlogController`/`SimulationRun`/route drift by checking against the code, and rejected its own weak findings. **Use as the merger** (skeptical synthesis: combine best-of-both, discard false positives, verify facts). Also a strong writer/reviewer.
- **Sonnet 5 — widest valid coverage.** Best at cohesion + catching what others miss (self-contradictions, buzzwords, terminology drift), with a low false-positive rate. **Use as a writer and reviewer.**
- **Haiku 4.5 — dropped.** False-negatives on docs (clean-verdicted files that had real stale refs) and false-positive padding on copy (invented grammar "fixes", flagged out-of-scope keys). Not worth a fan-out slot for copy work.

The merge is a *separate skeptical stage* precisely because every model — Opus included — emits findings worth discarding. Never union raw reviews.

---

## Learned (append-only)

`/ghost-bet` appends a dated line here each run: a confirmed style rule, a recurring false-positive pattern to pre-empt, or a per-model observation. Promote durable ones up into Standards or Model notes periodically.

- **2026-07-11** — Coat-check-ticket analogy for "cookie" reads as an English translation in pt-BR; native framing ("pequeno arquivo de texto que o site salva no navegador", ANPD register) is the fix. Recurring discard: a lone reviewer flagging localhost:3000→3001 is a false positive (3001 is a host-local remap, not in committed compose).
- **2026-07-12** — First live translation run (7 /sources cards, en→pt-BR). Number blocker: translating a multiplier "roughly 3x" as "3x mais" inflates it to ~4x ("3x mais" = 4x total); the fix is "cerca de 3x" / "pesam 3x". Pre-empt: in the fan-out, reviewers must check every multiplier/comparison ("Nx" vs "Nx more/mais") against the source value. Opus caught it, Sonnet introduced it — consistent with Opus-adjudicates-truth. Brazilian number formatting is mechanical and safe to front-load in the writer prompt (comma decimals, "mi"/"bi", "mês", thousands dot "+2.300%").
- **2026-07-12 (plain-language, from Gio's review)** — A translation faithful to a dense English source is still WRONG copy if the source was dense. The /sources cards target DataSenado's own demographic (52% earn up to 2 minimum wages — low income, skim-reading, low literacy). Rules for user-facing figure copy: (1) **no math symbols** — "≤2" → "até 2" (NOT "menos de 2", which drops the =2 case and changes the number); "~269 mil" → "quase 270 mil". (2) **No research jargon** — drop regression coefficients (0,2255 vs 0,0709 → "cerca de 3 vezes mais"), "inadimplência grave" → "muito endividadas", "comportamento clínico" → "impacto na saúde". (3) **"ludopatia" reads as an invented word to the public** → "vício em apostas". (4) **Fractions skim better than percentages** for this audience, and are honest when exact or hedged: 66,8% → "2 em cada 3", 52% → "metade", 86,7% → "quase 9 em cada 10". (5) **Fewer stats per card** — 2-3 strongest, not 4; the card links to the full source. (6) **Friendly headings** — "Notas metodológicas" reads like a paper → "Como conferimos os números". Gate tension: fraction/rounding trades exact precision for comprehension — hedge ("quase", "mais de", "metade") so it never overstates the source, and keep the deep-link for the exact figure.
