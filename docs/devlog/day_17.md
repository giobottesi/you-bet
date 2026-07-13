# Day 17 — Live, then swept

**Date**: 2026-07-13
**Sprint phase**: MVP DELIVERED (Jul 12) — remaining: SUB (demo, AI-declaration, register + submit)
**Planned**: Ship the MVP by deadline day, then close out.

## TL;DR

- **You-Bet went public** — live at `youbet.gio.show`, announced on Instagram with a launch video.
- **Gio wrote the entire launch caption himself, letter by letter** — the AI draft got tossed for reading like GPT.
- Packaged a subtitled 9:16 launch video (Fireflies transcript → ffmpeg burn-in) and got it on the feed.
- Then a full **house-cleaning ritual** — *defumar a casa*: compliance sweep, 70+ stale branches pruned, backlog organized, README given a future.
- Only **SUB** left. The build is done.

---

## What got done

### The house went live

The core loop has been shippable for a day; today it went *public*. Live URL announced, Instagram post up under `#DesafioContraBets`, README wired to the repo and the post. The thing exists in the world now.

### The launch content — Gio's, by hand

The caption that went up on Instagram was written **entirely by Gio, letter by letter**. An AI draft existed briefly and got thrown out for reading like a language model; the post that shipped is his voice, his hands — "vc confia no gatinho? 🍀". On packaging: the video transcript came from Fireflies and the subtitles were burned in with ffmpeg after a re-sync. The content landed — that's the point.

### Defumar a casa — the cleaning ritual

With the pressure off, the repo got a smoke-cleansing. A full compliance sweep confirmed no personal or sensitive data ever entered public history, and the 22MB launch video is safely out of git's reach. Then the branch graveyard — **70+ merged and stale branches** deleted, four dead stashes cleared, leftover worktrees removed, origin pruned down to the branches that still matter. `main` synced clean.

### A future worth reading

The scattered "someday" list got sorted into a proper post-MVP backlog (#92), and the README grew a **✨ Future iterations** section — sharper Monte Carlo, richer share formats, real-world-cost art, a *pague um refri pro dev* corner, and contributor-sized tasks. The About page title also shed its formality: *Sobre* → *Projeto*.

---

## Decisions & shifts

- **Launch commits went straight to main.**
  - Why — deadline crunch; the PR ceremony was suspended for the final polish, then resumed for everything after.
- **Tech-debt-as-issues was organized, not auto-created.**
  - Why — spawning a dozen public issues unattended cuts against the project's no-ticketing habit; parked as a decision instead.

---

## Gio's contributions

**Ship day: the code was mostly done — the judgment was everything.**

**Product & voice**
- **Wrote the entire launch caption by hand, letter by letter** → *tossed the GPT-flat AI draft; the post that shipped is fully his own words*
- **Held the launch copy to an explicit human-vs-Betina attribution** → *the AI declaration reads as honest credit, not a vague "made with AI"*

**Direction & judgment**
- **Called the whole cleaning ritual — "defumar a casa"** → *a delivered project got a clean, auditable public history instead of a branch swamp*
- **Dumped the future-work list and steered its privacy triage** → *features landed in the public backlog; personal and sensitive threads stayed out of git*
- **Framed You-Bet as a first step, not a finish line** → *sets the direction: serious simulation aimed at public-interest problems*

## Sprint health

**On track?** Yes — delivered.
Core loop shipped end to end and is live; the only remaining work is submission.

**Planned vs actual**: Planned to ship by deadline day — done. Everything past the launch was cleanup and closeout, ahead of the SUB step.

## Tomorrow

- **SUB** — record the demo, finalize the AI-declaration, register and submit.
- Nothing else blocks. Rest first.

---

_AI assist cost today: $338.60 · 501M tokens (you-bet only, day 17 — from Gio's 12pm start; day 16's overnight spend is logged there)._

> **Betina says:** "17 dias pra provar que a casa sempre ganha, e a última coisa que fizemos foi varrer a nossa. tem uma piada aí sobre limpar a bagunça de um projeto sobre não fazer bagunça, mas o gatinho já foi dormir. 🐱🍀"
