# arch-dotfiles

Arch Linux / Hyprland を中心にした `~/.config` 用の dotfiles です。

この README は公開しても大きな問題がない範囲の環境説明だけをまとめています。
個人的な作業ログや詳細な判断メモは `~/codex-adventure-log/` 側に残します。

## 環境概要

| 種別 | 内容 |
|---|---|
| OS | Arch Linux |
| WM | Hyprland |
| Shell | Bash |
| Terminal | Ghostty / kitty などを想定 |
| Editor | Neovim |
| Dotfiles | `~/.config` を Git 管理 |

## 収録内容

| 種別 | ディレクトリ / ファイル | 用途 |
|---|---|---|
| デスクトップ | `hypr/` | Hyprland 本体、idle/lock/wallpaper、起動スクリプト |
| デスクトップ | `waybar/` | Waybar の設定とスタイル |
| デスクトップ | `swaync/`, `wlogout/` | 通知、ログアウト UI |
| デスクトップ | `waypaper/`, `cava/` | 壁紙、ビジュアライザ |
| ターミナル | `ghostty/`, `kitty/` | 端末設定 |
| ファイル操作 | `yazi/` | Yazi の設定 |
| 日本語入力 | `fcitx5/`, `fcitx/`, `ibus/`, `mozc/` | 入力メソッド関連 |
| 開発 | `nvim/` | LazyVim ベースの Neovim 設定 |
| 開発 | `git/`, `gh/` | Git / GitHub CLI 設定 |
| アプリ | `google-chrome/`, `discord/` | アプリ設定。プロファイル本体は不用意に消さない |
| システム | `dconf/`, `pulse/`, `gtk-3.0/`, `systemd/` | ユーザー環境の設定や状態 |

## 管理方針

- `~/.config` は Git 管理する。
- 現行設定本体は小さく保ち、キャッシュ・一時ファイル・機密情報は含めない。
- 実機依存の状態ファイルは、別環境へ移す前に差分を確認する。
- `~/.config/git/`, `~/.config/nvim/`, `~/.config/hypr/`, `~/.config/eww/` は破壊的変更を避ける。
- ブラウザプロファイル、認証情報、秘密鍵、トークン類は Git 管理・整理対象にしない。

## Neovim

Neovim は LazyVim ベースです。主な周辺ツールは Mason / Lazy で管理します。

残す前提の重要ツール:

- `clangd`
- `lua-language-server`
- `stylua`
- `shfmt`
- LazyVim 本体

Mason / Lazy のキャッシュや一時生成物は再生成可能ですが、`~/.config/nvim/` の設定本体は直接削除しません。

## C / Linux / 42 Piscine 学習環境

次の系統は維持対象です。

- C コンパイラ: `clang`, `gcc`
- ビルド: `make`
- デバッグ: `gdb`, `lldb`, `valgrind`
- 42 関連: `norminette`
- shell script lint/format: `shellcheck`, `shfmt`
- Linux / Unix 学習に必要な CLI

Piscine 向け C コードでは、`printf` や `strlen` などの標準関数制限を確認し、必要なら `ft_` 関数を自作します。

## AI CLI

Codex / Claude は開発補助用 CLI として扱います。

- 現行 CLI 本体と設定は残す。
- 古いバージョンやキャッシュだけを整理候補にする。
- API キー、トークン、認証情報は表示・コピー・削除しない。

## メンテナンス手順

1. `git -C ~/.config status --short` で差分を確認する。
2. `du -sh ~/.config ~/.local ~/.cache ~/.local/share/nvim ~/.local/share/nvim/mason ~/.local/share/nvim/lazy 2>/dev/null` で容量を見る。
3. キャッシュは復旧可能なものだけ削除する。
4. 判断が難しい設定候補は `~/.trash-codex-review/YYYYMMDD-HHMMSS/` へ quarantine する。
5. 変更後に `nvim --version`, `shellcheck --version`, `hyprctl configerrors` を確認する。

## バックアップと復旧

- dotfiles 変更前のバックアップは `~/dotfiles-backup/YYYYMMDD-HHMMSS/` に置く。
- quarantine は `~/.trash-codex-review/YYYYMMDD-HHMMSS/` に置く。
- 作業ログは `~/codex-adventure-log/YYYYMMDD-HHMMSS/` に置く。
- `~/.config` の変更を戻す場合は、Git の差分とバックアップを確認してから戻す。

## 触ってはいけないもの

- `~/.vimrc`
- `~/.ssh/`
- `~/.gnupg/`
- `~/.password-store/`
- ブラウザプロファイル本体
- API キー、トークン、認証情報
- `~/Documents/`, `~/Downloads/`, `~/Desktop/`, `~/Pictures/`, `~/Videos/`, `~/Music/`
- `~/src/` 配下のソースコード本体
