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

    set_color green
    echo "theme → $name"
    set_color normal
    echo "  starship  applied on the next prompt"
    echo "  ghostty   reload with Cmd+Shift+, (or open a new window)"
    echo "  nvim      restart nvim  (or <leader>uC to preview live)"
end
