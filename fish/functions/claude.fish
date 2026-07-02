function claude --description "Claude Code with secrets injected from 1Password (op run)"
    # Injects API keys (SonarQube, X, xAI) from 1Password into Claude's env at
    # launch — so the MCP servers connect and nothing sensitive lives on disk.
    # Falls back to a plain launch if op isn't available/unlocked.
    set -l envfile "$HOME/dotfiles/op/secrets.env"
    if type -q op; and test -f $envfile
        # `op run -- claude` execs the claude BINARY (via PATH), not this function.
        op run --account my.1password.com --env-file=$envfile -- claude $argv
        or command claude $argv
    else
        command claude $argv
    end
end
