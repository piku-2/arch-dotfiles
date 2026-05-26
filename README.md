# arch-dotfiles

Arch Linux / Hyprland を中心にした `~/.config` 用の dotfiles です。

Neovim の詳細は `nvim/README.md` を参照してください。

## 収録内容

| 種別 | ディレクトリ / ファイル | 用途 |
|---|---|---|
| デスクトップ | `hypr/` | Hyprland 本体、idle/lock/paper、起動スクリプト |
| デスクトップ | `waybar/` | Waybar の設定とスタイル |
| デスクトップ | `waypaper/` | 壁紙設定 |
| デスクトップ | `cava/` | Cava の設定、テーマ、シェーダー |
| デスクトップ | `ghostty/` | Ghostty ターミナル設定 |
| デスクトップ | `foot/` | Foot の補助設定 |
| デスクトップ | `yazi/` | Yazi のキーマップ |
| 日本語入力 | `fcitx5/` | fcitx5 の設定 |
| 日本語入力 | `fcitx/`, `ibus/`, `mozc/` | 入力メソッドの状態 / キャッシュ |
| 開発 | `nvim/` | Neovim 設定（LazyVim ベース） |
| 開発 | `git/` | Git 設定（ignore など） |
| 開発 | `gh/` | GitHub CLI 設定 |
| アプリ | `google-chrome/`, `discord/` | ブラウザ / Electron アプリの設定 |
| システム | `dconf/`, `pulse/`, `gtk-3.0/`, `procps/`, `systemd/` | ユーザー環境の設定や状態 |

## 使い方

1. 既存の `~/.config` を退避する。
2. このリポジトリを `~/.config` に取り込む。

```bash
cd ~/.config
git init
git remote add origin https://github.com/piku-2/arch-dotfiles.git
git fetch origin
git checkout -t origin/main
```

既存ファイルと競合する場合は `git checkout origin/main -- <path>` で個別に戻す。
3. Hyprland / Waybar / 端末 / 入力メソッドは再ログイン、または各アプリの再起動で反映する。
4. Neovim は `nvim/README.md` の手順に従う。

## 注意

- `dconf/`、`ibus/`、`mozc/`、`pulse/` などは実機依存の状態を含むため、別環境へそのまま持っていくと再調整が必要な場合があります。
- Arch 専用なのは主に `hypr/`、`waybar/`、`fcitx5/` 周辺です。
