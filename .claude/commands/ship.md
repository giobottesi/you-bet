You are addressing PR review comments, applying fixes, committing, and pushing.

Argument: $ARGUMENTS (PR number, PR URL, or empty for current branch's PR)

---

## Step 1 — Find the PR

If `$ARGUMENTS` is a URL, extract the PR number from it. If it's a number, use it directly. If empty, detect:

```bash
gh pr view --json number,headRefName,baseRefName --jq '.number'
```

If no PR is found, stop and tell the user.

---

## Step 2 — Fetch review comments

```bash
gh api repos/{owner}/{repo}/pulls/{number}/comments
```

Also check for top-level review comments:

```bash
gh pr view {number} --json reviews --jq '.reviews[] | select(.body != "") | {author: .author.login, body: .body}'
```

If there are no comments, tell the user "No review comments found" and stop.

---

## Step 3 — Summarize and apply

List each comment with file, line, and what the reviewer wants. Then apply each fix:

- Read the file referenced in the comment
- Make the change the reviewer is asking for
- If a comment is ambiguous, ask the user before guessing

---

## Step 4 — Commit and push

Stage all changed files. Write a commit message that summarizes what was addressed:

```
Address PR review: {brief summary of fixes}

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
```

Push to the PR branch.

---

## Step 5 — Report

List what was fixed, one line per comment addressed. If any comments were skipped (ambiguous, out of scope), list those too.
