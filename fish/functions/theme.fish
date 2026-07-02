function theme --description "Switch theme across Ghostty + starship + Neovim"
    set -l name $argv[1]

    set -l ghostty_cfg "$HOME/.config/ghostty/config"
    set -l starship_cfg "$HOME/.config/starship.toml"
    set -l nvim_state "$HOME/.config/nvim/theme.txt"

    # Map the short key -> Ghostty theme name + starship palette name.
    set -l ghostty
    set -l palette
    switch $name
        case mocha catppuccin
            set name mocha
            set ghostty "Catppuccin Mocha"
            set palette catppuccin_mocha
        case tokyonight tokyo
            set name tokyonight
            set ghostty "TokyoNight Moon"
            set palette tokyonight
        case kanagawa
            set name kanagawa
            set ghostty "Kanagawa Wave"
            set palette kanagawa
        case rose-pine rosepine rose
            set name rose-pine
            set ghostty "Rose Pine Moon"
            set palette rose_pine
        case '' -h --help
            echo "theme — switch Ghostty + starship + Neovim together"
            echo "usage: theme <mocha|tokyonight|kanagawa|rose-pine>"
            return 0
        case '*'
            echo "theme: unknown theme '$name'"
            echo "       options: mocha | tokyonight | kanagawa | rose-pine"
            return 1
    end

    # Rewrite one line in a file. Uses a temp file + redirect instead of
    # `sed -i` so it works when the target is a symlink (writing through the
    # symlink edits the repo file and keeps the link intact).
    function __theme_sub --no-scope-shadowing
        set -l pattern $argv[1]
        set -l file $argv[2]
        set -l tmp (mktemp)
        sed -E "$pattern" $file >$tmp; and cat $tmp >$file
        rm -f $tmp
    end

    # Ghostty: swap the `theme = ...` line.
    __theme_sub "s|^theme = .*|theme = $ghostty|" $ghostty_cfg

    # starship: swap the active `palette = ...` line.
    __theme_sub "s|^palette = .*|palette = \"$palette\"|" $starship_cfg

    functions -e __theme_sub

    # Neovim: write the state file its config reads at startup.
    echo $name >$nvim_state

    # fzf colors follow the theme (bat follows the terminal palette via BAT_THEME).
    switch $name
        case kanagawa
            set -Ux FZF_DEFAULT_OPTS "--color=fg:#dcd7ba,bg:#1f1f28,hl:#7e9cd8,fg+:#dcd7ba,bg+:#2a2a37,hl+:#7fb4ca,border:#54546d,prompt:#e6c384,pointer:#d27e99,info:#727169,header:#98bb6c"
        case mocha
            set -Ux FZF_DEFAULT_OPTS "--color=fg:#cdd6f4,bg:#1e1e2e,hl:#89b4fa,fg+:#cdd6f4,bg+:#313244,hl+:#b4befe,border:#585b70,prompt:#cba6f7,pointer:#f5c2e7,info:#6c7086,header:#a6e3a1"
        case tokyonight
            set -Ux FZF_DEFAULT_OPTS "--color=fg:#c8d3f5,bg:#222436,hl:#82aaff,fg+:#c8d3f5,bg+:#2f334d,hl+:#c099ff,border:#444a73,prompt:#82aaff,pointer:#ff757f,info:#636da6,header:#c3e88d"
        case rose-pine
            set -Ux FZF_DEFAULT_OPTS "--color=fg:#e0def4,bg:#232136,hl:#c4a7e7,fg+:#e0def4,bg+:#2a273f,hl+:#ea9a97,border:#44415a,prompt:#eb6f92,pointer:#f6c177,info:#6e6a86,header:#9ccfd8"
    end

    set_color green
    echo "theme → $name"
    set_color normal
    echo "  starship  applied on the next prompt"
    echo "  ghostty   reload with Cmd+Shift+, (or open a new window)"
    echo "  nvim      restart nvim  (or <leader>uC to preview live)"
end
