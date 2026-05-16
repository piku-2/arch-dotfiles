-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Ctrl+S はZellij側でも無効化済み。LazyVimのデフォルトマッピングも解除する
pcall(vim.keymap.del, { "i", "x", "n", "s" }, "<C-s>")
