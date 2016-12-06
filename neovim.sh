#!/bin/sh

# スクリプト実行時に制御文以外でエラーが発生した場合に スクリプトを終了させる。
# ↓をいれているとbrewですでにインストール済みのものを再インストールするとエラーになりスクリプトが止まる
set -e

echo "installing Neovim..."
brew install neovim
brew install python3

echo "installing Neovim(pip3)..."
pip3 install --upgrade neovim

echo "Creation settings file..."
touch $XDG_CONFIG_HOME/nvim/dein.toml
touch $XDG_CONFIG_HOME/nvim/dein_lazy.toml
touch $XDG_CONFIG_HOME/nvim/init.vim

echo "Neovim complete!"
