#!/usr/bin/env bash
# install.sh — symlink the configs in this repo into ~/.config
# Usage: ./install.sh
set -euo pipefail

DOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="$HOME/.config"

mkdir -p "$CFG/ghostty" "$CFG/fish" "$CFG/nvim"

link() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%s)"
    echo "backup: $dst -> $dst.bak.*"
  fi
  ln -sfn "$src" "$dst"
  echo "link: $dst -> $src"
}

link "$DOT/ghostty/config"         "$CFG/ghostty/config"
link "$DOT/fish/config.fish"       "$CFG/fish/config.fish"
link "$DOT/fish/fish_plugins"      "$CFG/fish/fish_plugins"
link "$DOT/starship/starship.toml" "$CFG/starship.toml"

# nvim: link our own files (don't clobber the user's lazy-lock.json)
link "$DOT/nvim/init.lua"     "$CFG/nvim/init.lua"
link "$DOT/nvim/lua"          "$CFG/nvim/lua"
[ -f "$DOT/nvim/stylua.toml" ]   && link "$DOT/nvim/stylua.toml"   "$CFG/nvim/stylua.toml"
[ -f "$DOT/nvim/.neoconf.json" ] && link "$DOT/nvim/.neoconf.json" "$CFG/nvim/.neoconf.json"

echo
echo "Done. Next:"
echo "  1) brew bundle --file=$DOT/Brewfile"
echo "  2) fisher install jorgebucaran/fisher  (then: fisher update)"
echo "  3) open nvim so LazyVim/Mason install plugins + sonarlint-language-server"
