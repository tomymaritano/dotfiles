#!/usr/bin/env bash
# setup-mcp.sh — wire the SonarQube → Claude Code (MCP) bridge, reproducibly.
#
# Does, idempotently:
#   1. wait for the local SonarQube to be UP
#   2. generate a USER token via the API
#   3. store it as a fish universal var (SONARQUBE_TOKEN → gitignored fish_variables)
#   4. register the official SonarQube MCP server with Claude Code (user scope)
#
# Usage:  sonarqube/setup-mcp.sh [admin_password]
#         (admin password defaults to "admin"; override if you changed it)
#
# The MCP config lives in ~/.claude.json (per-user, NOT in this repo) and only
# references ${SONARQUBE_TOKEN} — the secret never touches the repo.
set -euo pipefail

SQ_URL="${SONARQUBE_URL:-http://localhost:9000}"
ADMIN_PASS="${1:-admin}"
TOKEN_NAME="claude-mcp"

echo "· waiting for SonarQube at $SQ_URL ..."
status=""
for _ in $(seq 1 60); do
  status=$(curl -s "$SQ_URL/api/system/status" 2>/dev/null | sed -n 's/.*"status":"\([^"]*\)".*/\1/p' || true)
  [ "$status" = "UP" ] && break
  sleep 2
done
if [ "$status" != "UP" ]; then
  echo "✗ SonarQube is not UP. Start it first:"
  echo "    docker compose -f sonarqube/docker-compose.yml up -d"
  exit 1
fi

echo "· generating USER token '$TOKEN_NAME' ..."
# revoke first so re-runs are idempotent (tokens are shown only once)
curl -s -u "admin:$ADMIN_PASS" -X POST "$SQ_URL/api/user_tokens/revoke?name=$TOKEN_NAME" >/dev/null || true
resp=$(curl -s -u "admin:$ADMIN_PASS" -X POST "$SQ_URL/api/user_tokens/generate?name=$TOKEN_NAME&type=USER_TOKEN")
token=$(echo "$resp" | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')
if [ -z "$token" ]; then
  echo "✗ could not generate token (wrong admin password?). Response: $resp"
  exit 1
fi

echo "· storing token as fish universal var SONARQUBE_TOKEN ..."
fish -c "set -Ux SONARQUBE_TOKEN $token"

echo "· registering the MCP server with Claude Code (user scope) ..."
# host.docker.internal lets the MCP container reach SonarQube on the host.
claude mcp remove -s user sonarqube 2>/dev/null || true
claude mcp add -s user sonarqube \
  --env 'SONARQUBE_TOKEN=${SONARQUBE_TOKEN}' \
  --env SONARQUBE_URL=http://host.docker.internal:9000 \
  -- docker run --init -i --rm -e SONARQUBE_TOKEN -e SONARQUBE_URL sonarsource/sonarqube-mcp

echo
echo "✓ done. Open 'claude' from fish, then: claude mcp list  (expect ✔ Connected)"
echo "  Issues appear once a project is analyzed with sonar-scanner."
