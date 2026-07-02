# dotfiles

<img width="4688" height="2976" alt="CleanShot 2026-06-30 at 19 39 18@2x" src="https://github.com/user-attachments/assets/9c2cc07c-cc4f-449a-9129-689ddf4d9a73" />


My macOS (Apple Silicon) terminal setup: **Ghostty + fish + Neovim (LazyVim)**, themed with a **one-command switcher** — `theme <name>` restyles the terminal, prompt and editor together (**Catppuccin Mocha** by default; also TokyoNight, Kanagawa, Rose Pine). Plus modern CLI tools, code-quality tooling (SonarLint + SonarQube), and AI assistants (Claude Code, Grok, CodeRabbit).

## Stack

```
Ghostty (terminal)  →  fish (shell)  →  Neovim / LazyVim (editor)
   `theme` switcher     starship prompt     LSP + Telescope + SonarLint
   JetBrains Nerd Font  zoxide · eza · bat  ripgrep · fd
   blur + transparency  fzf · nvm.fish      Mason

   theme mocha | tokyonight | kanagawa | rose-pine   ← restyles all three
```

| Layer | Tool | What for |
|-------|------|----------|
| Terminal | [Ghostty](https://ghostty.org) | fast GPU terminal, Nerd Font, blur + transparency |
| Shell | [fish](https://fishshell.com) 4.x | interactive shell (default only in Ghostty; the system stays on zsh) |
| Prompt | [starship](https://starship.rs) | prompt with git/language/duration; palette follows the active theme |
| Editor | [Neovim](https://neovim.io) + [LazyVim](https://lazyvim.org) | LSP, completion, fuzzy find — a VSCode replacement |
| `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) | jump to frequent dirs (`z <name>`) |
| `ls` | [eza](https://eza.rocks) | listing with icons + git |
| `cat` | [bat](https://github.com/sharkdp/bat) | syntax highlighting |
| search | [ripgrep](https://github.com/BurntSushi/ripgrep) + [fd](https://github.com/sharkdp/fd) | fast; used by Telescope in nvim |
| node | [nvm.fish](https://github.com/jorgebucaran/nvm.fish) | native node version management in fish |
| git | [lazygit](https://github.com/jesseduffield/lazygit) | git TUI (`lg`) |
| quality | SonarLint (nvim) + SonarQube (Docker) | see below |

## Installation

```bash
git clone git@github.com:tomymaritano/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 1) Install everything from Homebrew
brew bundle --file=Brewfile

# 2) Symlink the configs into ~/.config (backs up anything existing)
./install.sh

# 3) fish plugins (fisher + nvm.fish)
fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
fish -c 'fisher update'   # installs what's in fish/fish_plugins

# 4) default node via nvm.fish
fish -c 'nvm install 24; and set --universal nvm_default_version 24'

# 5) Open nvim — LazyVim + Mason install plugins and the SonarLint language server
nvim
```

## Themes

One command restyles the whole stack — terminal, prompt and editor — at once:

```fish
theme mocha        # Catppuccin Mocha  (default)
theme tokyonight   # TokyoNight Moon
theme kanagawa     # Kanagawa Wave
theme rose-pine    # Rose Pine Moon
```

`theme` (defined in `fish/functions/theme.fish`) maps a short name to the
matching **Ghostty theme**, **starship palette** and **Neovim colorscheme**:

| `theme <name>` | Ghostty | starship palette | Neovim colorscheme |
|----------------|---------|------------------|--------------------|
| `mocha`        | Catppuccin Mocha | `catppuccin_mocha` | `catppuccin-mocha`  |
| `tokyonight`   | TokyoNight Moon  | `tokyonight`       | `tokyonight-moon`   |
| `kanagawa`     | Kanagawa Wave    | `kanagawa`         | `kanagawa-wave`     |
| `rose-pine`    | Rose Pine Moon   | `rose_pine`        | `rose-pine-moon`    |

**How it applies after switching:**
- **starship** — instant, on the next prompt.
- **Ghostty** — reload with `Cmd+Shift+,` (or just open a new window).
- **Neovim** — restart nvim. To *preview* themes live without committing, use
  LazyVim's picker: `<leader>uC` (that preview is not persisted; `theme` is what sticks).

**How it works internally:**
- Ghostty (`ghostty/config`) and starship (`starship.toml`) each have one line
  swapped in place (`theme = …` / `palette = "…"`).
- Neovim reads a tiny state file, `~/.config/nvim/theme.txt` (git-ignored), at
  startup — `nvim/lua/plugins/colorscheme.lua` maps its contents to a colorscheme
  and installs all four theme plugins.

To **add a theme**: add a `case` in `fish/functions/theme.fish`, a matching
`[palettes.<name>]` block in `starship.toml`, and an entry (plus its plugin) in
`nvim/lua/plugins/colorscheme.lua`.

## Per-tool notes

### Ghostty (`ghostty/config`)
- Font: `JetBrainsMono Nerd Font` (icons for LazyVim).
- Theme: set by the `theme` command (see [Themes](#themes)); the `theme = …` line uses Ghostty's exact, capitalized theme names.
- Translucent background: `background-opacity = 0.85` + `background-blur-radius = 20` (macOS blur).
- `command = /opt/homebrew/bin/fish` → fish only inside Ghostty; the system login shell stays zsh (friendlier with POSIX installers/tooling).
- Reload config: `Cmd+Shift+,`.

### fish (`fish/config.fish`)
- Loads Homebrew, sets `EDITOR=nvim`, adds Java (openjdk@21) to PATH for SonarLint.
- Initializes starship, zoxide and fzf in interactive sessions only.
- node is managed by **nvm.fish** (`nvm install 22`, `nvm use 20`, `nvm list`).
- Aliases: `v` (nvim), `lg` (lazygit), `ll`/`lt` (eza), `cat` (bat), `gs`/`gd`, `sq-up`/`sq-down`/`sq-logs` (SonarQube).
- Functions (`fish/functions/`): `theme <name>` — the whole-stack theme switcher (see [Themes](#themes)).

### Neovim (`nvim/`)
LazyVim base. The custom bits live in:
- `lua/config/` → options, keymaps, autocmds.
- `lua/plugins/` → extra plugins: `colorscheme.lua` (themes, see [Themes](#themes)) and `sonarlint.lua`.

Key bindings (`<leader>` = space): `<space><space>` find files · `<space>/` grep · `<space>e` explorer · `gd` definition · `<space>ca` code actions · `<space>gg` lazygit · `<space>uC` colorscheme picker (live preview).

## Code quality: SonarLint + SonarQube

Two layers that act at different moments:

**1. SonarLint in nvim (`nvim/lua/plugins/sonarlint.lua`)** — *live* linting as you type, like VSCode's SonarLint. Runs locally, no server.
- Requires `openjdk@21` (Java) and `sonarlint-language-server` (installed by Mason).
- Active for JS/TS/Python/HTML/CSS/XML.

**2. SonarQube Server in Docker** — *full* analysis with a dashboard and quality gates.

```bash
docker run -d --name sonarqube \
  -p 9000:9000 \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  -v sonarqube_logs:/opt/sonarqube/logs \
  --restart unless-stopped \
  sonarqube:community
```

- Dashboard: <http://localhost:9000> — initial login `admin` / `admin` (forces a change).
- To analyze a project: create the project in the dashboard → generate a token → from the repo root:

  ```bash
  sonar-scanner \
    -Dsonar.projectKey=my-project \
    -Dsonar.sources=. \
    -Dsonar.host.url=http://localhost:9000 \
    -Dsonar.token=YOUR_TOKEN
  ```

- Container control: `sq-up` / `sq-down` / `sq-logs`.

## AI assistants

Installed as global CLIs (their auth is local and **not** in this repo):
- **Claude Code** — `claude`
- **Grok** (xAI, native CLI) — `grok`
- **CodeRabbit** — `coderabbit` / `cr`

### Claude Code running on Grok (`ccr/config.json`)

The Claude Code *engine* can run on xAI Grok via [claude-code-router](https://github.com/musistudio/claude-code-router) (CCR), a local proxy that translates Anthropic ⇄ OpenAI format. Run it with the `grokcode` alias:

```fish
grokcode   # = env CLAUDE_CONFIG_DIR=~/.claude-grok ANTHROPIC_CUSTOM_MODEL_OPTION=grok-4.3 ccr code
```

- **Isolated profile** (`~/.claude-grok`) so it never touches your personal `claude` account.
- `ANTHROPIC_CUSTOM_MODEL_OPTION=grok-4.3` makes Grok selectable in the `/model` picker (Claude Code rejects non-Claude names otherwise).
- Needs `XAI_API_KEY` set: `set -Ux XAI_API_KEY xai-...` (stored in gitignored `fish_variables`).
- `ccr/config.json` (in this repo) defines the providers/router; it has **no key** (uses `$XAI_API_KEY`). Copy it to `~/.claude-code-router/config.json`.
- The model lives at `~/.claude-code-router/config.json` `Router` block; `ccr ui` opens a web editor.
- Note: unofficial/unsupported by Anthropic; tool-use/agentic editing on Grok can be less reliable than native Claude.

## Notes

- macOS Apple Silicon (Homebrew under `/opt/homebrew`).
- No secrets in the repo: `auth.json`, `.env` and `fish_variables` are in `.gitignore`.
