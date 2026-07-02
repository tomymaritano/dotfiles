# dotfiles

<img width="3392" height="2086" alt="CleanShot 2026-07-02 at 00 46 30@2x" src="https://github.com/user-attachments/assets/46085335-6a0d-4361-86bc-372fdf97f6cd" />


![platform](https://img.shields.io/badge/platform-macOS%20Apple%20Silicon-000000?logo=apple&logoColor=white)
![shell](https://img.shields.io/badge/shell-fish%204.x-4E9A06?logo=gnubash&logoColor=white)
![terminal](https://img.shields.io/badge/terminal-Ghostty-1E1E2E)
![editor](https://img.shields.io/badge/editor-Neovim%20·%20LazyVim-57A143?logo=neovim&logoColor=white)
![themes](https://img.shields.io/badge/themes-4%20·%20one--command%20switcher-e6c384)

My macOS (Apple Silicon) terminal setup: **Ghostty + fish + Neovim (LazyVim)**, themed with a **one-command switcher** — `theme <name>` restyles the terminal, prompt and editor together (**Kanagawa Wave** by default; also Catppuccin Mocha, TokyoNight, Rose Pine). Plus modern CLI tools, code-quality tooling (SonarLint + SonarQube), and AI assistants (Claude Code, Grok, CodeRabbit).

## Contents

- [Stack](#stack)
- [Requirements](#requirements)
- [Installation](#installation)
- [Themes](#themes)
- [Keybindings](#keybindings)
- [Per-tool notes](#per-tool-notes)
- [Code quality](#code-quality)
- [AI assistants](#ai-assistants)
- [Tasks (just)](#tasks)
- [Updating](#updating)
- [Uninstall](#uninstall)
- [Notes](#notes)

## Stack

```
Ghostty (terminal)  →  fish (shell)  →  Neovim / LazyVim (editor)
   `theme` switcher     starship prompt     LSP + Telescope + SonarLint
   JetBrains Nerd Font  zoxide · eza · bat  ripgrep · fd
   blur + transparency  fzf · nvm.fish      Mason

   theme kanagawa | mocha | tokyonight | rose-pine   ← restyles all three
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
| history | [atuin](https://atuin.sh) | fuzzy `Ctrl+R` shell history, per-dir + synced |
| env | [direnv](https://direnv.net) | auto-load per-project env from `.envrc` |
| node | [nvm.fish](https://github.com/jorgebucaran/nvm.fish) | native node version management in fish |
| git | [lazygit](https://github.com/jesseduffield/lazygit) + [delta](https://github.com/dandavison/delta) | git TUI (`lg`) + pretty diffs |
| tasks | [just](https://github.com/casey/just) | repo task runner (see [Tasks](#tasks)) |
| quality | SonarLint (nvim) + SonarQube (Docker) | see [Code quality](#code-quality) |

## Requirements

- **macOS on Apple Silicon** (Homebrew lives under `/opt/homebrew`).
- **[Homebrew](https://brew.sh)** — everything else is installed from the `Brewfile`.
- **git** and, for the SSH clone below, a GitHub SSH key (or clone over HTTPS).
- A **Nerd Font** — the `Brewfile` installs *JetBrainsMono Nerd Font*; Ghostty is
  already configured to use it. Other terminals need the font selected manually.
- **Docker** (Docker Desktop or OrbStack) — only for the SonarQube server + its MCP; the rest of the setup works without it.

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

`install.sh` symlinks each config into `~/.config` (and a few into `~`, like
`.gitconfig`) and **backs up** anything already there to `*.bak.<timestamp>` — so
it's safe to re-run and easy to undo (see [Uninstall](#uninstall)).

Optional: `./macos/defaults.sh` applies opinionated macOS system settings (fast
key repeat, Finder tweaks, screenshots → `~/Screenshots`). From then on, `just`
runs the common tasks (see [Tasks](#tasks)).

## Themes

One command restyles the whole stack — terminal, prompt and editor — at once:

```fish
theme kanagawa     # Kanagawa Wave     (default)
theme mocha        # Catppuccin Mocha
theme tokyonight   # TokyoNight Moon
theme rose-pine    # Rose Pine Moon
```

### Gallery

The banner accent and starship prompt follow the active theme:

|  |  |
|:--:|:--:|
| ![Kanagawa Wave](https://img.shields.io/badge/Kanagawa%20Wave-default%20·%20gold-e6c384?style=for-the-badge&labelColor=1f1f28) | ![Catppuccin Mocha](https://img.shields.io/badge/Catppuccin%20Mocha-mauve-cba6f7?style=for-the-badge&labelColor=1e1e2e) |
| ![TokyoNight Moon](https://img.shields.io/badge/TokyoNight%20Moon-blue-82aaff?style=for-the-badge&labelColor=222436) | ![Rose Pine Moon](https://img.shields.io/badge/Rose%20Pine%20Moon-pink-eb6f92?style=for-the-badge&labelColor=232136) |

> **Screenshots:** drop one per theme here the same way as the header image —
> drag a PNG into a GitHub issue/comment to get a `user-attachments` URL, then
> replace a cell with `![kanagawa](URL)`.

### How switching maps

`theme` (defined in `fish/functions/theme.fish`) maps a short name to the
matching **Ghostty theme**, **starship palette** and **Neovim colorscheme**:

| `theme <name>` | Ghostty | starship palette | Neovim colorscheme | banner accent |
|----------------|---------|------------------|--------------------|---------------|
| `kanagawa`     | Kanagawa Wave    | `kanagawa`         | `kanagawa-wave`     | gold `#e6c384`  |
| `mocha`        | Catppuccin Mocha | `catppuccin_mocha` | `catppuccin-mocha`  | mauve `#cba6f7` |
| `tokyonight`   | TokyoNight Moon  | `tokyonight`       | `tokyonight-moon`   | blue `#82aaff`  |
| `rose-pine`    | Rose Pine Moon   | `rose_pine`        | `rose-pine-moon`    | pink `#eb6f92`  |

### How it applies after switching

- **starship** — instant, on the next prompt.
- **Ghostty** — reload with `Cmd+Shift+,` (or just open a new window).
- **Neovim** — restart nvim. To *preview* themes live without committing, use
  LazyVim's picker: `<leader>uC` (that preview is not persisted; `theme` is what sticks).

### How it works internally

- Ghostty (`ghostty/config`) and starship (`starship.toml`) each have one line
  swapped in place (`theme = …` / `palette = "…"`).
- Neovim reads a tiny state file, `~/.config/nvim/theme.txt` (git-ignored), at
  startup — `nvim/lua/plugins/colorscheme.lua` maps its contents to a colorscheme,
  installs all four theme plugins, and colors the dashboard banner per theme.

To **add a theme**: add a `case` in `fish/functions/theme.fish`, a matching
`[palettes.<name>]` block in `starship.toml`, and an entry (plus its plugin +
accent color) in `nvim/lua/plugins/colorscheme.lua` / `nvim/lua/plugins/dashboard.lua`.

## Keybindings

`<leader>` is **space**. These are LazyVim defaults plus this repo's additions —
see [lazyvim.org/keymaps](https://www.lazyvim.org/keymaps) for the full list.

### Neovim — files & search

| Key | Action |
|-----|--------|
| `<leader><space>` | Find files (project root) |
| `<leader>ff` / `<leader>fr` | Find files / recent files |
| `<leader>/` | Live grep (search in project) |
| `<leader>,` | Switch buffer |
| `<leader>e` / `<leader>E` | File explorer (root / cwd) |

### Neovim — code & LSP

| Key | Action |
|-----|--------|
| `gd` `gr` `gI` `gy` | Go to definition / references / implementation / type |
| `K` | Hover docs |
| `<leader>ca` / `<leader>cr` | Code action / rename |
| `<leader>cf` | Format |
| `]d` / `[d` | Next / previous diagnostic |
| `<leader>cd` | Line diagnostics |

### Neovim — git, windows, UI

| Key | Action |
|-----|--------|
| `<leader>gg` | lazygit |
| `<leader>gb` | Blame line · `]h` / `[h` next/prev hunk |
| `<C-h/j/k/l>` | Move between windows |
| `<leader>\|` / `<leader>-` | Split vertical / horizontal |
| `<S-h>` / `<S-l>` | Previous / next buffer · `<leader>bd` close buffer |
| `<leader>uC` | Colorscheme picker (live preview) |
| `<leader>l` / `<leader>cm` | Lazy / Mason |

### fish — aliases & functions

| Command | What it does |
|---------|--------------|
| `v` | nvim |
| `lg` | lazygit |
| `ll` / `lt` | eza long / tree listing |
| `cat` | bat (syntax highlighting) |
| `gs` / `gd` | git status / git diff |
| `z <dir>` | zoxide jump to a frequent directory |
| `theme <name>` | [switch the whole-stack theme](#themes) |
| `sq-up` / `sq-down` / `sq-logs` | [SonarQube](#code-quality) container control |
| `grokcode` | Claude Code engine on Grok ([see below](#ai-assistants)) |
| `nvm install/use/list` | node version management |

## Per-tool notes

### Ghostty (`ghostty/config`)
- Font: `JetBrainsMono Nerd Font` (icons for LazyVim).
- Theme: set by the `theme` command (see [Themes](#themes)); the `theme = …` line uses Ghostty's exact, capitalized theme names.
- Translucent background: `background-opacity = 0.85` + `background-blur-radius = 20` (macOS blur).
- `command = /opt/homebrew/bin/fish` → fish only inside Ghostty; the system login shell stays zsh (friendlier with POSIX installers/tooling).
- Reload config: `Cmd+Shift+,`.

### fish (`fish/config.fish`)
- Loads Homebrew, sets `EDITOR=nvim`, adds Java (openjdk@21) to PATH for SonarLint.
- Initializes starship, zoxide, fzf, **atuin** and **direnv** in interactive sessions only.
- **atuin** owns `Ctrl+R` (fuzzy history). Run `atuin import auto` once to seed it from your old history; `atuin login` is optional (only for cross-machine sync).
- **direnv**: drop an `.envrc` in a project and run `direnv allow` once — vars load/unload as you `cd` in and out.
- node is managed by **nvm.fish** (`nvm install 22`, `nvm use 20`, `nvm list`).
- Aliases & functions: see the [Keybindings cheatsheet](#keybindings).

### git (`git/`) + editorconfig
- `git/config` → `~/.gitconfig`: identity, sane defaults (`pull.rebase`, `push.autoSetupRemote`, `fetch.prune`), **delta** as the diff pager, and aliases (`git s`, `git lg`, `git undo`, `git pushf`, …).
- Machine-specific or secret bits (credential helpers, signing keys, the coderabbit id) live in `~/.gitconfig.local`, pulled in via `[include]` — **not tracked**.
- `git/ignore` → `~/.gitignore_global`: OS/editor cruft ignored in every repo.
- `editorconfig` → `~/.editorconfig`: baseline indentation/charset for all projects.

### Neovim (`nvim/`)
LazyVim base. The custom bits live in:
- `lua/config/` → options, keymaps, autocmds.
- `lua/plugins/` → extra plugins: `colorscheme.lua` (themes) + `dashboard.lua` (banner) — see [Themes](#themes) — and `sonarlint.lua`.

## Code quality

Two layers that act at different moments: **SonarLint** (live, in nvim) and
**SonarQube Server** (full analysis, in Docker).

**1. SonarLint in nvim (`nvim/lua/plugins/sonarlint.lua`)** — *live* linting as you type, like VSCode's SonarLint. Runs locally, no server.
- Requires `openjdk@21` (Java) and `sonarlint-language-server` (installed by Mason).
- Active for JS/TS/Python/HTML/CSS/XML.

**2. SonarQube Server in Docker** — *full* analysis with a dashboard and quality gates. Reproducible via the tracked compose file (`sonarqube/docker-compose.yml`):

```bash
docker compose -f sonarqube/docker-compose.yml up -d
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

### Let the AI read your issues — SonarQube MCP

Claude Code can query your SonarQube **directly** through the official
[SonarQube MCP server](https://github.com/SonarSource/sonarqube-mcp-server)
(free, works with Community Build). Once wired, you can ask *"fix the SonarQube
issues in this file"* and Claude pulls the rules/issues itself — no copy-paste.

Configured **per user** (in `~/.claude.json`, **not** this repo) and reads a
token from the gitignored fish universal var `SONARQUBE_TOKEN`. One script does
the whole bridge — generate the token, store it, and register the MCP server:

```bash
sonarqube/setup-mcp.sh              # uses the default admin password
sonarqube/setup-mcp.sh 'my-pass'    # if you changed the SonarQube admin password
```

It runs `claude mcp add -s user sonarqube … sonarsource/sonarqube-mcp` under the
hood. Notes:

- `host.docker.internal:9000` is how the MCP container reaches SonarQube on the host.
- Launch `claude` from **fish** so `${SONARQUBE_TOKEN}` is in its environment.
- Issues only show up once a project has been analyzed with `sonar-scanner` (above).
- Check status with `claude mcp list`; a `USER`-type token is required (the script uses it).

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

## Tasks

Common jobs are wrapped in a [`justfile`](https://github.com/casey/just) — run
`just` to list them:

| Recipe | What it does |
|--------|--------------|
| `just install` | symlink configs (`./install.sh`) |
| `just brew` | install/update from the `Brewfile` |
| `just update` | pull + re-link + brew + fish plugins |
| `just lint` | shellcheck + `stylua --check` (same as CI) |
| `just fmt` | auto-format the Lua config |
| `just macos` | apply `macos/defaults.sh` |
| `just sonar` | start SonarQube + wire the [MCP bridge](#let-the-ai-read-your-issues--sonarqube-mcp) |

Shell scripts and Lua are linted on every push by `.github/workflows/lint.yml`.

## Updating

```bash
just update    # git pull --rebase + ./install.sh + brew bundle + fisher update
```

Inside nvim: `:Lazy sync` to update plugins (commit the changed `lazy-lock.json`),
`:Mason` to manage language servers.

## Uninstall

`install.sh` never deletes — it moves anything it replaces to `*.bak.<timestamp>`.
To roll back, remove the symlinks and restore the most recent backups, e.g.:

```bash
cd ~/.config
rm starship.toml ghostty/config fish/config.fish nvim/init.lua nvim/lua fish/functions/theme.fish
# then restore the backups you want, for example:
mv starship.toml.bak.* starship.toml
```

(The `theme.fish` symlink is the only file this repo adds to `fish/functions/`;
fisher's own functions there are left untouched.)

## Notes

- macOS Apple Silicon (Homebrew under `/opt/homebrew`).
- No secrets in the repo: `auth.json`, `.env` and `fish_variables` are in `.gitignore`.
- The active theme lives in tracked files (`ghostty/config`, `starship.toml`), so
  running `theme <x>` shows up as a diff on those two files — that's expected.
