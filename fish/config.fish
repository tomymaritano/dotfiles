# ~/.config/fish/config.fish

# --- Homebrew (arm64) ---
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

# --- User binaries (CLIs: claude, coderabbit/cr, grok, etc.) ---
fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.grok/bin"

# --- Default editor ---
set -gx EDITOR nvim
set -gx VISUAL nvim

# --- Java (openjdk@21, keg-only) for the SonarLint language server ---
if test -d /opt/homebrew/opt/openjdk@21
    set -gx JAVA_HOME /opt/homebrew/opt/openjdk@21
    fish_add_path /opt/homebrew/opt/openjdk@21/bin
end

# --- Node / nvm.fish ---
# nvm.fish (plugin installed via fisher) manages node versions natively in fish.
# It auto-loads $nvm_default_version on shell startup (see conf.d/nvm.fish).
# Commands: `nvm install 22`, `nvm use 20`, `nvm list`.
# Change the default with: set --universal nvm_default_version <ver>

# --- bat as the default pager ---
set -gx PAGER bat

# --- Empty greeting when fish opens ---
set -g fish_greeting

# --- Interactive sessions only ---
if status is-interactive
    # Prompt: starship
    if type -q starship
        starship init fish | source
    end

    # zoxide: `z <part-of-path>` jumps to visited dirs; `zi` opens an fzf picker
    if type -q zoxide
        zoxide init fish | source
    end

    # fzf: Ctrl+T (files), Alt+C (cd). (Ctrl+R is taken over by atuin below.)
    if type -q fzf
        fzf --fish | source
    end

    # atuin: better shell history with fuzzy search on Ctrl+R (synced, per-dir
    # context). First run once: `atuin import auto` to seed from your old history.
    # Sourced after fzf so it wins the Ctrl+R binding.
    if type -q atuin
        atuin init fish | source
    end

    # direnv: auto-loads a directory's .envrc when you cd in (per-project env vars
    # / tool versions). Run `direnv allow` once per project to trust its .envrc.
    if type -q direnv
        direnv hook fish | source
    end

    # --- Aliases ---
    alias v   nvim

    # eza: modern ls replacement (icons + git + tree)
    if type -q eza
        alias ls  "eza --icons --group-directories-first"
        alias ll  "eza -lah --icons --group-directories-first --git"
        alias lt  "eza --tree --level=2 --icons"
    else
        alias ll  "ls -lah"
    end

    # bat: cat with syntax highlighting
    if type -q bat
        alias cat bat
    end

    # git / utils
    alias lg  lazygit
    alias gs  "git status"
    alias gd  "git diff"

    # theme switcher (Ghostty + starship + nvim) — see functions/theme.fish
    complete -c theme -f -a "mocha tokyonight kanagawa rose-pine"

    # SonarQube (Docker) - dashboard at http://localhost:9000
    alias sq-up   "docker start sonarqube"
    alias sq-down "docker stop sonarqube"
    alias sq-logs "docker logs -f sonarqube"

    # Claude Code engine running on xAI Grok, via claude-code-router (CCR).
    # Isolated profile (~/.claude-grok) so it never touches your personal `claude`,
    # and grok-4.3 shows up selectable in the /model picker. Needs XAI_API_KEY set.
    alias grokcode "env CLAUDE_CONFIG_DIR=$HOME/.claude-grok ANTHROPIC_CUSTOM_MODEL_OPTION=grok-4.3 ccr code"
end
