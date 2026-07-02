-- Extra autocmds (LazyVim already does highlight-on-yank, restore cursor,
-- close some filetypes with q, etc.). These add what it doesn't.

-- Create missing parent directories when saving a new file.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_mkdir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return -- skip URLs (e.g. oil://, fugitive://)
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Stop auto-inserting comment leaders on the next line (a common annoyance).
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("no_auto_comment", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "o", "r" })
  end,
})
