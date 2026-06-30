# dotfiles

My macOS (Apple Silicon) terminal setup: **Ghostty + fish + Neovim (LazyVim)**, all themed with **Catppuccin Mocha**, plus modern CLI tools, code-quality tooling (SonarLint + SonarQube), and AI assistants (Claude Code, Grok, CodeRabbit).

## Stack

```
Ghostty (terminal)  →  fish (shell)  →  Neovim / LazyVim (editor)
   mocha theme          starship prompt     LSP + Telescope + SonarLint
   JetBrains Nerd Font  zoxide · eza · bat  ripgrep · fd
   blur + transparency  fzf · nvm.fish      Mason
```

| Layer | Tool | What for |
|-------|------|----------|
| Terminal | [Ghostty](https://ghostty.org) | fast GPU terminal, Nerd Font, blur + transparency |
| Shell | [fish](https://fishshell.com) 4.x | interactive shell (default only in Ghostty; the system stays on zsh) |
| Prompt | [starship](https://starship.rs) | prompt with git/language/duration, Catppuccin palette |
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

## Per-tool notes

### Ghostty (`ghostty/config`)
- Font: `JetBrainsMono Nerd Font` (icons for LazyVim).
- Theme: `Catppuccin Mocha` (mind the exact name, capitalized!).
- Translucent background: `background-opacity = 0.85` + `background-blur-radius = 20` (macOS blur).
- `command = /opt/homebrew/bin/fish` → fish only inside Ghostty; the system login shell stays zsh (friendlier with POSIX installers/tooling).
- Reload config: `Cmd+Shift+,`.

### fish (`fish/config.fish`)
- Loads Homebrew, sets `EDITOR=nvim`, adds Java (openjdk@21) to PATH for SonarLint.
- Initializes starship, zoxide and fzf in interactive sessions only.
- node is managed by **nvm.fish** (`nvm install 22`, `nvm use 20`, `nvm list`).
- Aliases: `v` (nvim), `lg` (lazygit), `ll`/`lt` (eza), `cat` (bat), `gs`/`gd`, `sq-up`/`sq-down`/`sq-logs` (SonarQube).

### Neovim (`nvim/`)
LazyVim base. The custom bits live in:
- `lua/config/` → options, keymaps, autocmds.
- `lua/plugins/` → extra plugins (includes `sonarlint.lua`).

Key bindings (`<leader>` = space): `<space><space>` find files · `<space>/` grep · `<space>e` explorer · `gd` definition · `<space>ca` code actions · `<space>gg` lazygit.

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

## AI assistants (not versioned here)

Installed as global CLIs (their auth is local and **not** in this repo):
- **Claude Code** — `claude`
- **Grok** (xAI) — `grok`
- **CodeRabbit** — `coderabbit` / `cr`

## Notes

- macOS Apple Silicon (Homebrew under `/opt/homebrew`).
- No secrets in the repo: `auth.json`, `.env` and `fish_variables` are in `.gitignore`.
