-- LazyVim の自動フォーマット（clangd LSP フォールバック含む）を無効化
-- 保存時に clangd がタブをスペースに変換するのを防ぐ
vim.b.autoformat = false

-- Norminette 規約準拠: タブをスペースに変換しない（ハードタブを使用する）
vim.opt_local.expandtab = false

-- タブ文字の表示幅を4スペース分に設定
vim.opt_local.tabstop = 4

-- >> / << によるインデント幅を4に設定
vim.opt_local.shiftwidth = 4

-- Tab キー押下時の挙動をハードタブのみに統一（softtabstop=0 で無効化）
vim.opt_local.softtabstop = 0

-- 80 桁目に視覚ガイドラインを表示（Norminette: 1行最大80文字）
vim.opt_local.colorcolumn = "80"

-- タブとスペースを視覚的に区別する
vim.opt_local.list = true
vim.opt_local.listchars = {
  tab = "→ ", -- タブを矢印で表示
  trail = "·", -- 行末の余分なスペースを点で表示
  space = "·", -- スペースを点で表示（うっとうしければ削除）
}
