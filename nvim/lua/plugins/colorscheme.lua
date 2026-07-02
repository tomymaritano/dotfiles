-- Colorschemes + whole-stack theme switching.
--
-- The active theme is chosen by a single state file (~/.config/nvim/theme.txt)
-- that the `theme` fish function writes. That same function also updates
-- Ghostty and starship, so all three stay in sync. See the repo README.
--
-- To preview themes live inside nvim (without touching the rest of the stack):
--   <leader>uC   →  colorscheme picker
-- That change is not persisted; `theme <name>` in the shell is what sticks.

-- theme.txt key  ->  nvim colorscheme
local COLORSCHEMES = {
  mocha = "catppuccin-mocha",
  tokyonight = "tokyonight-moon",
  kanagawa = "kanagawa-wave",
  ["rose-pine"] = "rose-pine-moon",
}

local DEFAULT = "catppuccin-mocha"

local function active_colorscheme()
  local path = vim.fn.stdpath("config") .. "/theme.txt"
  local f = io.open(path, "r")
  if not f then
    return DEFAULT
  end
  local key = vim.trim(f:read("*l") or "")
  f:close()
  return COLORSCHEMES[key] or DEFAULT
end

return {
  -- The theme plugins (loaded eagerly so the picker can preview them).
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
  { "rose-pine/neovim", name = "rose-pine", lazy = false, priority = 1000 },

  -- Tell LazyVim which one to use at startup.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = active_colorscheme(),
    },
  },
}
