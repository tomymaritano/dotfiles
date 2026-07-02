---
description: Write a good commit message for the staged changes and commit
allowed-tools: Bash(git diff:*), Bash(git status:*), Bash(git add:*), Bash(git commit:*), Bash(git log:*)
---

Commit the staged changes with a clear message.

1. Run `git status` and `git diff --staged`. If nothing is staged, run `git diff`
   to see the working changes and stage the relevant ones with `git add`.
2. Look at `git log --oneline -5` to match the repo's commit style.
3. Write a concise message: a ≤50-char imperative subject, then a blank line and
   a short body explaining the *why* (only if it's not obvious). No fluff.
4. Show me the message and commit it. Do not push unless I ask.

Extra instructions (optional): $ARGUMENTS
