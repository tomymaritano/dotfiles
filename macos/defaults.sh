#!/usr/bin/env bash
# macos/defaults.sh — opinionated, reversible macOS settings.
# Run once per machine:  ./macos/defaults.sh   (some changes need a logout/restart)
# Undo any line by running the same `defaults write` with your preferred value,
# or `defaults delete <domain> <key>` to reset to the system default.
set -euo pipefail

echo "· keyboard: fast key repeat (better for vim motions)"
defaults write NSGlobalDomain KeyRepeat -int 2            # 1 = fastest
defaults write NSGlobalDomain InitialKeyRepeat -int 15    # 15 = shortest sane delay
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false  # repeat instead of accent popup

echo "· finder: show extensions, hidden files, path bar, list view"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "· screenshots: PNG into ~/Screenshots"
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"

echo "· dock: autohide, no delay, don't rearrange spaces"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock mru-spaces -bool false

echo "· dialogs: expand save/print panels by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

killall Finder Dock SystemUIServer 2>/dev/null || true
echo "✓ done. A few settings only take effect after a logout or restart."
