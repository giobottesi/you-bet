# Dev Tooling

Optional local tooling that makes contributing to You-Bet faster. None of it is required to run the app — it only sharpens the review loop.

## Better git diffs — `git-delta`

Plain `git diff` is hard to scan for prose-heavy changes (devlogs, docs, skill files) and dense code. [`git-delta`](https://github.com/dandavison/delta) renders syntax-highlighted, line-numbered diffs with word-level intra-line highlighting.

**Install:**

```bash
brew install git-delta        # macOS
# see the delta README for apt / cargo / other platforms
```

**Configure** (`~/.gitconfig`, global — applies to every repo):

```ini
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    navigate = true       # n / N to jump between files in a diff
    line-numbers = true
    side-by-side = true    # set false for a unified view
```

After this, `git diff`, `git show`, and `git log -p` all render through delta in your terminal. `q` quits, `n`/`N` walk between files.

**Note:** delta is a pager — it only activates when output goes to a terminal. In scripts, pipes, or CI logs, git falls back to plain diff automatically, so nothing downstream breaks.
