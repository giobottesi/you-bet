# Contributing

You-Bet is a public, always-evolving project. Contributions are welcome — code, copy, translations, design, or a sharp issue. Here's how to start.

## Find something to work on

- New here? Look for the [`good first issue`](https://github.com/giobottesi/you-bet/labels/good%20first%20issue) label — small, self-contained, no deep context needed.
- Everything else is in [Issues](https://github.com/giobottesi/you-bet/issues), grouped by `area:` labels (results, i18n, design, simulation, and so on). `research` means "find a source before building it"; `copy` means user-facing text.
- Rather talk first? Open an issue describing what you'd like to do.

## Set it up

You need Docker. Then:

```bash
docker compose up -d      # → http://localhost:3000
```

Run the tests:

```bash
docker exec you-bet-web-1 bundle exec rspec
```

The stack and folder layout are in the [README](README.md).

## Make your change

- **Tests ship with features**, not as an afterthought. New behavior gets a spec.
- **Small, focused pull requests** — one issue or a tight group. Easier to read, faster to merge.
- **English** for code, comments, and commit messages. Only the `pt-BR` locale files hold Portuguese.
- **Cite your sources.** Every number in the app links to a primary source; new ones must too.
- The full house rules are in [CLAUDE.md](CLAUDE.md) if you want them.

## Open a pull request

Never done this before? The short version:

1. Fork this repo (button, top right) and clone your fork.
2. Make a branch: `git checkout -b my-change`.
3. Commit, push to your fork, then open a Pull Request against `main`.

Say what changed and why. If it closes an issue, write `Closes #NN` in the description.

## One rule on tone

This project is about gambling harm. We aim the math at the industry, never at the person who bets. Keep copy kind, plain, and free of blame. When in doubt, punch up.
