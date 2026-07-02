function tweet --description "Jot a tweet idea to ~/notes/tweets.md (no args: open the file)"
    set -l file "$HOME/notes/tweets.md"
    mkdir -p (dirname $file)

    # no args → open the drafts file in the editor
    if test (count $argv) -eq 0
        test -e $file; or printf "# tweet drafts\n\n" >$file
        $EDITOR $file
        return
    end

    set -l ts (date "+%Y-%m-%d %H:%M")
    printf -- "- [%s] %s\n" "$ts" "$argv" >>$file
    echo "✎ saved → $file"
end
