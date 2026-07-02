-- LazyVim language + tooling extras. Each import wires up the full IDE
-- experience for that language: LSP (autocomplete, go-to-def, diagnostics,
-- hover), treesitter (syntax/indent), a formatter, and — where it exists — a
-- debug adapter and a neotest adapter. Equivalent to picking these in
-- `:LazyExtras`, but tracked in git. Mason installs the servers on next launch.
--
-- Note: language *servers* come from Mason, but the *toolchains* don't — Go
-- needs `go`, Rust needs `rustup`/`cargo` on PATH for full functionality.
return {
  -- languages
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.yaml" },

  -- formatting + testing
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  { import = "lazyvim.plugins.extras.test.core" }, -- neotest: run/debug tests in-editor
}
