#!/bin/sh

# 各自追記
# neovimの設定
echo "Neovim link..."
ln -sf ~/dotfiles/dein_lazy.toml ~/.config/dein_lazy.toml
ln -sf ~/dotfiles/dein.toml ~/.config/dein.toml
ln -sf ~/dotfiles/init.vim ~/.config/init.vim

# preztoの設定
echo "Prezto link..."
ln -sf ~/dotfiles/.zlogin ~/.zlogin
ln -sf ~/dotfiles/.zlogout ~/.zlogout
ln -sf ~/dotfiles/.zpreztorc ~/.zpreztorc
ln -sf ~/dotfiles/.zshenv ~/.zshenv
ln -sf ~/dotfiles/.zshrc ~/.zshrc
