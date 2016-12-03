#!/bin/sh

# 各自追記
# neovimの設定
echo "Neovim link..."
ln -sf ~/dotfiles/neovim/dein_lazy.toml ~/.config/nvim/dein_lazy.toml
ln -sf ~/dotfiles/neovim/dein.toml ~/.config/nvim/dein.toml
ln -sf ~/dotfiles/neovim/init.vim ~/.config/nvim/init.vim

# preztoの設定
echo "Prezto link..."
# ディレクトリへ
ln -nfs ~/dotfiles/prezto ~/.zprezto

# ファイルへ
ln -sf ~/dotfiles/.zlogin ~/.zlogin
ln -sf ~/dotfiles/.zlogout ~/.zlogout
ln -sf ~/dotfiles/.zpreztorc ~/.zpreztorc
ln -sf ~/dotfiles/.zprofile ~/.zprofile
ln -sf ~/dotfiles/.zshenv ~/.zshenv
ln -sf ~/dotfiles/.zshrc ~/.zshrc
