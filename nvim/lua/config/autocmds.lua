-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local hacker_theme = vim.api.nvim_create_augroup("hacker_theme", { clear = true })

local function apply_hacker_highlights()
  local set = vim.api.nvim_set_hl

  set(0, "Normal", { fg = "#c8ffd8", bg = "#000000" })
  set(0, "NormalFloat", { fg = "#c8ffd8", bg = "#03120c" })
  set(0, "FloatBorder", { fg = "#00c07a", bg = "#03120c" })

  set(0, "LineNr", { fg = "#1f6d4b", bg = "#000000" })
  set(0, "CursorLineNr", { fg = "#00ff88", bold = true })
  set(0, "CursorLine", { bg = "#06180f" })
  set(0, "Visual", { bg = "#124330" })

  set(0, "Search", { fg = "#02130d", bg = "#00ff88", bold = true })
  set(0, "IncSearch", { fg = "#02130d", bg = "#7affb9", bold = true })

  set(0, "Comment", { fg = "#4aa175", italic = true })
  set(0, "String", { fg = "#86ffb7" })
  set(0, "Function", { fg = "#9cf7ff" })
  set(0, "Keyword", { fg = "#7bffdb", bold = true })
  set(0, "Type", { fg = "#b4ffc5" })

  set(0, "DiagnosticError", { fg = "#ff6f6f" })
  set(0, "DiagnosticWarn", { fg = "#ffd975" })
  set(0, "DiagnosticInfo", { fg = "#8fd9ff" })
  set(0, "DiagnosticHint", { fg = "#7affd5" })
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  group = hacker_theme,
  callback = apply_hacker_highlights,
})

apply_hacker_highlights()

-- Rust: rust_analyzer アタッチ時に Inlay Hints と専用キーマップを設定
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("rust_lsp_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "rust_analyzer" then return end
    local buf = args.buf
    -- Inlay Hints を有効化（Neovim 0.10+ API）
    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end
    -- LazyVim の lang.rust extra が未定義のキーマップのみ追加
    local map = vim.keymap.set
    map("n", "<leader>rr", function() vim.cmd.RustLsp("runnables") end, { buffer = buf, desc = "Runnables" })
    map("n", "<leader>rt", function() vim.cmd.RustLsp("testables") end, { buffer = buf, desc = "Testables" })
    map("n", "<leader>re", function() vim.cmd.RustLsp("expandMacro") end, { buffer = buf, desc = "Expand Macro" })
    map("n", "<leader>rR", function() vim.cmd.RustLsp("renderDiagnostic") end, { buffer = buf, desc = "Render Diagnostic" })
  end,
})
