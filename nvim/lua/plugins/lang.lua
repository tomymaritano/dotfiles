-- Enable LazyVim language + formatting extras for the stack I actually use
-- (same filetypes sonarlint targets). Each import pulls in the right LSP,
-- treesitter parsers, and tools (installed by Mason on next launch).
-- Equivalent to picking these in `:LazyExtras`, but tracked in git.
return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.formatting.prettier" },
}
