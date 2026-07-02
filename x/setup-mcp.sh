#!/usr/bin/env bash
# x/setup-mcp.sh — wire X into Claude Code:
#   • x-docs    → https://docs.x.com/mcp  (official docs search; no auth)
#   • x-twitter → community poster (Infatoshi/x-mcp): post_tweet, reply_to_tweet,
#                 quote_tweet, upload_media, search_tweets, … Uses OAuth1 keys
#                 injected from 1Password with `op run` — no secrets on disk.
#
# Prereqs (one-time):
#   1. developer.x.com → app with **Read and write** permissions; generate the
#      OAuth1 keys (API key/secret, access token/secret, bearer).
#   2. Store them in 1Password and point op/secrets.env at the fields
#      (copy op/secrets.env.example). Expected env vars:
#        X_API_KEY X_API_SECRET X_BEARER_TOKEN X_ACCESS_TOKEN X_ACCESS_TOKEN_SECRET
#
# Run:  x/setup-mcp.sh
# Then launch Claude with the secrets injected:  cx   (fish alias, see config.fish)
set -euo pipefail

SRC="$HOME/.local/share/x-mcp"

echo "· x-docs (X API documentation search; no auth) ..."
claude mcp remove -s user x-docs 2>/dev/null || true
claude mcp add --transport http -s user x-docs https://docs.x.com/mcp

echo "· building the X poster in $SRC ..."
if [ -d "$SRC/.git" ]; then
  git -C "$SRC" pull --ff-only
else
  git clone --depth 1 https://github.com/Infatoshi/x-mcp "$SRC"
fi
( cd "$SRC" && npm install && npm run build )

echo "· registering x-twitter (secrets injected by op at launch) ..."
claude mcp remove -s user x-twitter 2>/dev/null || true
# shellcheck disable=SC2016  # Claude Code expands ${...} at launch, not bash
claude mcp add -s user x-twitter \
  --env 'X_API_KEY=${X_API_KEY}' \
  --env 'X_API_SECRET=${X_API_SECRET}' \
  --env 'X_BEARER_TOKEN=${X_BEARER_TOKEN}' \
  --env 'X_ACCESS_TOKEN=${X_ACCESS_TOKEN}' \
  --env 'X_ACCESS_TOKEN_SECRET=${X_ACCESS_TOKEN_SECRET}' \
  -- node "$SRC/dist/index.js"

echo
echo "✓ done. Launch Claude with X secrets from 1Password:  cx"
echo "  Then in Claude Code:  /tweet <idea>  → review → 'post it'."
