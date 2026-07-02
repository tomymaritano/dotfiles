---
name: changelog
description: Generate a changelog or release notes from git history. Use when the user asks for a changelog, release notes, "what changed", or to summarize commits since a tag or date.
---

# Changelog

Turn git history into a clean, user-facing changelog.

## Steps
1. **Range.** Default to the last tag → HEAD: `git describe --tags --abbrev=0`
   then `<tag>..HEAD`. If there are no tags, use the last ~20 commits or a date
   the user gives. Honor an explicit range if provided.
2. **Read commits.** `git log <range> --no-merges --pretty=format:'%h %s'`.
   For anything ambiguous, look closer with `git show --stat <hash>`.
3. **Group** by type — **Features / Fixes / Refactors / Docs / Chore** —
   inferring from conventional-commit prefixes (`feat:`, `fix:`, `refactor:`, …)
   or from the subject when there's no prefix.
4. **Rewrite, don't dump.** Each bullet says what changed and why it matters to a
   reader, not the raw commit subject. Drop noise: merges, pure formatting,
   version bumps, lockfile-only changes.
5. **Output** Markdown under a `## <version or date>` heading, groups as `###`.
6. If asked, **suggest the next semver bump** (major/minor/patch) justified by the
   changes (breaking → major, new feature → minor, fixes only → patch).

## Notes
- Keep it tight — a changelog is scanned, not read.
- Never invent changes that aren't in the commits.
