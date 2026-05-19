# dotfiles

Arch Linux の `~/.config` を管理する dotfiles リポジトリ。
Ubuntu + Zsh でも **Neovim / Starship / Zellij / VS Code** の設定を流用できる。

## 動作確認環境

- Arch Linux（メイン）
- Ubuntu 22.04 / 24.04 + Zsh（nvim・starship・zellij・VS Code のみ）

---

## Ubuntu セットアップ手順

### 1. 必要なツールをインストール

```bash
# Neovim（0.9 以上が必要）
sudo apt install -y neovim git curl unzip

# Starship
curl -sS https://starship.rs/install.sh | sh

# Zellij
cargo install zellij
# または GitHub Releases からバイナリを直接取得
# https://github.com/zellij-org/zellij/releases
```

VS Code は [公式サイト](https://code.visualstudio.com/) の .deb パッケージをインストール。

**Nerd Font**（アイコン表示に必須）: [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads) 等をインストールし、ターミナルのフォントに設定する。

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

### 3. Starship を Zsh に登録

`~/.zshrc` の末尾に追記する。

```bash
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
source ~/.zshrc
```

### 4. Neovim の初回起動

```bash
nvim
```

起動時に lazy.nvim がプラグインを自動インストールする。完了後 `:qa` で一度終了し、再起動すると設定が完全に適用される。

### 5. VS Code の設定を確認

clone 後、`~/.config/Code/User/settings.json` が配置されていれば VS Code が自動で読み込む。

---

## Ubuntu で使えない設定

以下は Hyprland / Wayland 固有のため Ubuntu では不要。

| ディレクトリ | 理由 |
|---|---|
| `hypr/` | Hyprland は Ubuntu の標準環境では動作しない |
| `waybar/` | Hyprland 前提の設定 |
| `waypaper/` | Wayland コンポジター前提 |
| `cava/` | オーディオビジュアライザー（任意） |
| `fcitx5/` | 日本語入力（別途セットアップが必要） |
