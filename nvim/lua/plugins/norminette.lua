local ns = vim.api.nvim_create_namespace("norminette")

local function run_norminette(bufnr)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then return end

  vim.fn.jobstart({ "norminette", filepath }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then return end
      local diagnostics = {}
      for _, line in ipairs(data) do
        -- "Error: RULE_NAME  (line: X, col: Y): message"
        local sev, rule, row, col, msg = line:match(
          "^(Error|Notice): (%S+)%s+%(line: (%d+), col: (%d+)%): (.+)$"
        )
        if sev then
          table.insert(diagnostics, {
            lnum     = tonumber(row) - 1,
            col      = tonumber(col) - 1,
            message  = rule .. ": " .. msg,
            severity = sev == "Error"
              and vim.diagnostic.severity.ERROR
              or  vim.diagnostic.severity.WARN,
            source   = "norminette",
          })
        end
      end
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.diagnostic.set(ns, bufnr, diagnostics)
        end
      end)
    end,
  })
end

return {
  -- nvim-lspconfig の init は lazy.nvim 起動時に必ず実行されるため
  -- FileType イベントより確実に早くオートコマンドを登録できる
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- .h ファイルの設定（filetype が cpp 等に検出されるため ftplugin では効かない）
      -- パターン一致で直接適用することで filetype に依存しない
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.h",
        group = vim.api.nvim_create_augroup("norminette_h_settings", { clear = true }),
        callback = function(args)
          local buf = args.buf
          vim.bo[buf].expandtab   = false
          vim.bo[buf].tabstop     = 4
          vim.bo[buf].shiftwidth  = 4
          vim.bo[buf].softtabstop = 0
          vim.opt_local.colorcolumn = "80"
        end,
      })

      -- 保存後とファイル読み込み後に norminette を非同期実行
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        pattern = { "*.c", "*.h" },
        group = vim.api.nvim_create_augroup("norminette_run", { clear = true }),
        callback = function(args)
          run_norminette(args.buf)
        end,
      })
    end,
  },
}
