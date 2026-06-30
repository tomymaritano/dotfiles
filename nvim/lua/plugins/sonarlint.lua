-- SonarLint in nvim (live linting, like VSCode's SonarLint)
-- Requires: openjdk (java) on PATH + sonarlint-language-server via Mason.
-- Mason installs the binary and analyzers under $MASON.
return {
  -- Make sure Mason installs the language server
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "sonarlint-language-server")
    end,
  },

  -- The SonarLint plugin
  {
    "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "python",
      "html",
      "css",
      "xml",
    },
    config = function()
      local analyzer_dir = vim.fn.expand("$MASON/share/sonarlint-analyzers")
      -- Glob all .jar files (skip .asc) so we don't hardcode versions
      local jars = vim.fn.glob(analyzer_dir .. "/*.jar", true, true)

      local cmd = { "sonarlint-language-server", "-stdio", "-analyzers" }
      vim.list_extend(cmd, jars)

      require("sonarlint").setup({
        server = {
          cmd = cmd,
        },
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "python",
          "html",
          "css",
          "xml",
        },
      })
    end,
  },
}
