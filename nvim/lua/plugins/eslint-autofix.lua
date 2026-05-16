return {
  -- prettierd と eslint-lsp を Mason 経由で自動インストール
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "eslint-lsp", "prettierd" })
    end,
  },
  -- ESLint LSP: JS/TS ファイルの保存時に EslintFixAll を自動実行
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.cmd("EslintFixAll")
              end,
            })
          end,
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },
      },
    },
  },
}
