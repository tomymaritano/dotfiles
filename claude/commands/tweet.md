---
description: Draft a build-in-public tweet (or thread) from an idea or recent work
allowed-tools: Bash(git log:*), Bash(git diff:*), Bash(git status:*), Read
---

Draft tweets in my voice. Follow the style guide at `~/.claude/voice.md` (read it first).

Seed idea (may be empty): $ARGUMENTS

Steps:
1. Read `~/.claude/voice.md` for tone and format.
2. If a seed idea was given, build on it. If it's empty, look at what I just did:
   `git log --oneline -10` and `git diff --stat HEAD~3..HEAD` (and `git status`),
   and pick the most tweet-worthy thing (a fix, a decision, a shipped feature).
3. Also skim `~/notes/tweets.md` if it exists — I jot raw ideas there with the
   `tweet` command; you can polish one of those instead.
4. Produce:
   - **3 single-tweet options** (different angles: the insight / the result / the gotcha).
   - **1 optional thread** (2–4 tweets) only if the topic genuinely needs it.
5. Keep each tweet under 280 chars. Show the work (snippet/command/number) when it helps.
6. Do NOT post. Just present the drafts so I can pick. If the `sonarqube`-style
   `x`/twitter MCP tools are available and I say "post it", then post the chosen one.

Output the drafts as plain text I can copy, each clearly separated.
