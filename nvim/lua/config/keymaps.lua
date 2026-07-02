-- Extra keymaps (LazyVim defaults still apply: https://www.lazyvim.org/keymaps).
-- These are additive and chosen to not clash with LazyVim's own remaps.

local map = vim.keymap.set

-- Keep the cursor centered on half-page jumps (easier to track where you are).
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Join lines without the cursor jumping to the join point.
map("n", "J", "mzJ`z", { desc = "Join line (keep cursor)" })

-- Paste over a visual selection without overwriting your yank register.
map("x", "<leader>p", [["_dP]], { desc = "Paste (keep yank)" })

-- Delete without clobbering the yank register (send it to the black hole).
map({ "n", "x" }, "<leader>d", [["_d]], { desc = "Delete (no yank)" })

-- Jump straight to this Neovim config directory.
map("n", "<leader>fD", function()
  vim.cmd("edit " .. vim.fn.stdpath("config"))
end, { desc = "Open nvim config dir" })
