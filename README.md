# dotfiles

Arch Linux（Hyprland）のメイン環境と、42 Tokyo Piscine 向け Ubuntu 環境の両方を意識した設定。

## 管理している設定

| ディレクトリ / ファイル | 用途 |
|---|---|
| `nvim/` | Neovim（LazyVim + Copilot + TypeScript LSP） |
| `ghostty/` | ターミナル（Ubuntu GNOME Terminal 外観に準拠） |
| `Code/User/settings.json` | VS Code |
| `hypr/` | Hyprland（Arch 専用） |
| `waybar/` | ステータスバー（Arch 専用） |
| `cava/` | オーディオビジュアライザー（Arch 専用） |
| `fcitx5/` | 日本語入力（Arch 専用） |

---

## Ubuntu セットアップ手順（Neovim + VS Code）

### 1. 必要なツールをインストール

```bash
sudo apt install -y neovim git curl unzip
```

VS Code は [公式サイト](https://code.visualstudio.com/) の .deb パッケージをインストール。

**Nerd Font**（nvim のアイコン表示に必須）: [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads) をインストールし、ターミナルのフォントに設定する。

### 2. リポジトリを clone

`~/.config` はすでに存在するため、`git init` で取り込む。

```bash
cd ~/.config
git init
git remote add origin https://github.com/piku-2/arch-dotfiles.git
git fetch
git checkout main
```

> 既存ファイルと競合する場合は `git checkout main -- <ファイル>` で個別に取り込む。

### 3. Neovim の初回起動

```bash
nvim
```

起動時に lazy.nvim がプラグインを自動インストールする。完了後 `:qa` で終了し、再起動すると設定が完全に適用される。

### 4. VS Code の設定を確認

clone 後、`~/.config/Code/User/settings.json` が配置されていれば VS Code が自動で読み込む。

---

## 42 Tokyo Piscine 向け設定

42 の本番環境（sudo なし Ubuntu）を再現するための最小構成。リポジトリには含まれず、手動で作成する。

### `~/.bashrc`（末尾に追記）

```bash
alias cc='gcc -Wall -Wextra -Werror'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
export EDITOR='vim'
```

### `~/.vimrc`（暗記推奨・7行）

```vim
syntax on
set number
set tabstop=4
set shiftwidth=4
set noexpandtab
set cindent
set colorcolumn=80
```

---

## Ubuntu で使えない設定

| ディレクトリ | 理由 |
|---|---|
| `hypr/` | Hyprland は Ubuntu の標準環境では動作しない |
| `waybar/` | Hyprland 前提の設定 |
| `cava/` | オーディオビジュアライザー（任意） |
| `fcitx5/` | 日本語入力（別途セットアップが必要） |
