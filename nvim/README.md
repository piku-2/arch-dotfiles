# Neovim 設定概要

このディレクトリは **LazyVim v8** ベースの Neovim 設定です。起動エントリは `init.lua` の `require("config.lazy")` のみで、実設定は `lua/config` と `lua/plugins` に分かれています。

## 有効なカスタマイズ

- **テーマ**: `gruvbox-material` を適用（`lua/plugins/colorscheme.lua`）。
- **ハイライト上書き**: `VimEnter` / `ColorScheme` で黒背景 + 緑系の独自配色を適用（`lua/config/autocmds.lua`）。
- **オプション**: `termguicolors`, `background=dark`, `clipboard=unnamedplus`, `number`, `cursorline`, `signcolumn=yes`, `scrolloff=8`, `sidescrolloff=8`（`lua/config/options.lua`）。
- **WSL クリップボード対応**: `win32yank.exe` がある場合のみ専用 clipboard 設定を利用（`lua/config/options.lua`）。
- **Colorizer**: `NvChad/nvim-colorizer.lua` を `BufReadPre` で有効化。全ファイルタイプ対象で背景色表示（`lua/plugins/colorizer.lua`）。
- **ESLint 自動修正**: `BufWritePre` で `EslintFixAll` を実行。`mason.nvim` に `eslint-lsp` と `prettierd` を追加（`lua/plugins/eslint-autofix.lua`）。
- **追加キーマップ**: なし（`lua/config/keymaps.lua`）。

## LazyVim extras（`lazyvim.json`）

- `lazyvim.plugins.extras.ai.copilot`
- `lazyvim.plugins.extras.ai.copilot-chat`
- `lazyvim.plugins.extras.formatting.prettier`
- `lazyvim.plugins.extras.lang.clangd`
- `lazyvim.plugins.extras.lang.python`
- `lazyvim.plugins.extras.lang.rust`
- `lazyvim.plugins.extras.lang.tailwind`
- `lazyvim.plugins.extras.lang.typescript`
- `lazyvim.plugins.extras.linting.eslint`

`install_version` / `version` はともに `8` です。

## 補足

- `lua/plugins/example.lua` は `if true then return {} end` のため無効です（サンプル保持用）。
- `.neoconf.json` では `neodev` ライブラリと `lua_ls` 連携を有効化しています。
- `lazy-lock.json` によりプラグインのコミットが固定されています。
- `stylua.toml` は Spaces / 幅 2 / 列幅 120。
