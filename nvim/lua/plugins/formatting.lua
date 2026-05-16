return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- Rust: rustfmt（rustup で管理、Mason 不要）
      opts.formatters_by_ft.rust = { "rustfmt" }

      -- rustfmt: Rust 2021 edition をデフォルトに設定
      -- プロジェクトに rustfmt.toml があればそちらが優先される
      opts.formatters = opts.formatters or {}
      opts.formatters.rustfmt = {
        args = { "--edition", "2021", "--emit=stdout", "--" },
      }

      return opts
    end,
  },
}
