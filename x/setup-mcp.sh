#!/usr/bin/env bash
# x/setup-mcp.sh — register X's OFFICIAL MCP servers with Claude Code:
#   • xapi   → https://api.x.com/mcp   (via the `xurl` OAuth2 bridge; acts as you)
#   • x-docs → https://docs.x.com/mcp  (search/read X API docs; no auth)
#
# Prereqs for `xapi` (one-time, only you can do these):
#   1. developer.x.com → create an App with **OAuth 2.0** enabled.
#   2. Register the redirect URI  http://localhost:8080/callback  on the app.
#   3. Copy the app's CLIENT_ID and CLIENT_SECRET, then in fish:
#        set -Ux X_CLIENT_ID ...
#        set -Ux X_CLIENT_SECRET ...
#   (First tool use opens your browser once to log in; xurl caches + refreshes
#    the token in ~/.xurl afterwards. Needs Node/npx — provided by mise.)
#
# Run:  x/setup-mcp.sh   (from a fish shell where the two vars are set)
set -euo pipefail

# --- X Docs MCP: no credentials needed ---
echo "· registering x-docs (X API documentation search) ..."
claude mcp remove -s user x-docs 2>/dev/null || true
claude mcp add --transport http -s user x-docs https://docs.x.com/mcp

# --- X API MCP: needs your OAuth2 app credentials ---
if [ -n "${X_CLIENT_ID:-}" ] && [ -n "${X_CLIENT_SECRET:-}" ]; then
  echo "· registering xapi (X API via the xurl OAuth2 bridge) ..."
  claude mcp remove -s user xapi 2>/dev/null || true
  # shellcheck disable=SC2016  # Claude Code expands ${...} at launch, not bash
  claude mcp add -s user xapi \
    --env 'CLIENT_ID=${X_CLIENT_ID}' \
    --env 'CLIENT_SECRET=${X_CLIENT_SECRET}' \
    -- npx -y @xdevplatform/xurl mcp https://api.x.com/mcp
  echo "  first use opens your browser to log in to X (one-time)."
  echo "  if Claude Code times out on startup, raise MCP_TIMEOUT (e.g. 300000)."
else
  echo "⚠ X_CLIENT_ID / X_CLIENT_SECRET not set — skipped 'xapi'."
  echo "  Set them (see this script's header) and re-run to enable posting."
fi

echo
echo "✓ done. From fish: claude mcp list"
