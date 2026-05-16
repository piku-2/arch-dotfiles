# Zellij 設定メモ（このディレクトリの実ファイル準拠）

## 対象ファイル
- `config.kdl`（現在の有効設定。先頭コメントに「Zellij 自動生成」と記載あり）
- `themes/gruvbox-material.kdl`
- `themes/ice-hacker.kdl`
- `config.kdl.bak` / `config.kdl.bak2` / `config.kdl.bak-20260428-220021`（バックアップ）

## 現在有効な主要設定（`config.kdl`）
- `theme "gruvbox-material"`
- `pane_frames false`
- `simplified_ui false`
- `default_shell "zsh"`
- `mouse_mode true`
- `scroll_buffer_size 50000`
- `copy_on_select true`
- `scrollback_editor "nvim"`
- `show_startup_tips false`
- `web_client { font "monospace" }`
- `load_plugins {}` は空（追加の自動ロードなし）

## キーバインド概要（`keybinds clear-defaults=true`）
- モード切替: `Ctrl+p`(pane), `Ctrl+t`(tab), `Ctrl+n`(resize), `Ctrl+h`(move), `Ctrl+s`(scroll), `Ctrl+b`(tmux), `Ctrl+o`(session), `Ctrl+g`(lock), `Ctrl+q`(quit)
- ペイン: 移動（矢印 / `hjkl`）、分割（`d`/`r`/`s`/`n`）、全画面（`f`）、フロート切替（`w`）
- タブ: `1..9` 直接移動、`n` 新規、`x` 閉じる、`r` リネーム、`tab` トグル
- スクロール/検索: `Ctrl+s` でスクロール、`s` で検索入力、`n`/`p` で次/前検索

## テーマファイル
- `themes/gruvbox-material.kdl`: 暖色寄りのダーク配色（赤・黄・緑・青を強調色として定義）
- `themes/ice-hacker.kdl`: 青系のクールトーン配色
- 現在は `config.kdl` で `gruvbox-material` が選択されているため、`ice-hacker` は未選択
