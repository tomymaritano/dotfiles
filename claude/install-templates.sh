#!/usr/bin/env bash
# claude/install-templates.sh — third-party Claude Code agents & skills I use,
# from aitmpl.com (claude-code-templates). Re-run on a new machine to fetch them
# fresh into ~/.claude. (Our OWN agents/skills/commands are symlinked from this
# repo by install.sh; these community ones are downloaded, not vendored.)
set -euo pipefail

cd "$HOME" # claude-code-templates installs into ./.claude
run() { npx --yes claude-code-templates@latest "$@" --yes; }

# agents (~/.claude/agents/*.md)
run --agent development-team/ui-ux-designer
run --agent development-team/devops-engineer
run --agent development-tools/test-engineer
run --agent devops-infrastructure/deployment-engineer

# skills (~/.claude/skills/<name>/SKILL.md)
run --skill development/senior-frontend
run --skill creative-design/frontend-design
run --skill creative-design/ui-ux-pro-max
run --skill development/senior-security
run --skill development/clean-code
run --skill web-development/react-best-practices

# hooks (merged into ~/.claude/settings.local.json)
run --hook automation/simple-notifications # desktop notice when Claude finishes / needs input

echo "✓ community templates installed into ~/.claude"
