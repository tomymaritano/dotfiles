-- Editor productivity extras (LazyVim). Each is one import; `:LazyExtras` lists
-- the rest. Toggle/inspect any of these with which-key after enabling.
return {
  -- Debugging: breakpoints, step-through, inspect variables (nvim-dap + UI).
  -- Pairs with neotest. Language debug adapters come from the lang.* extras.
  { import = "lazyvim.plugins.extras.dap.core" },

  -- Harpoon: pin a handful of files and jump between them instantly.
  --   <leader>H add file · <leader>h menu · <leader>1..5 jump to pinned file
  { import = "lazyvim.plugins.extras.editor.harpoon2" },

  -- Octo: review, comment on and manage GitHub PRs/issues inside nvim
  -- (uses the gh CLI you're already authed with).  :Octo pr list
  { import = "lazyvim.plugins.extras.util.octo" },

  -- Treesitter context: keep the current function/class "stuck" at the top of
  -- the window while you scroll through a long body.
  { import = "lazyvim.plugins.extras.ui.treesitter-context" },
}
