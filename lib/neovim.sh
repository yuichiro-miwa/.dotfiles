#!/bin/sh

run_neovim(){

    # スクリプト実行時に制御文以外でエラーが発生した場合に スクリプトを終了させる。
    # ↓をいれているとbrewですでにインストール済みのものを再インストールするとエラーになりスクリプトが止まる
    set -e

    echo "installing Neovim..."
    brew install neovim/neovim/neovim

    echo "installing Neovim(pip3)..."
    pip3 install --upgrade neovim

    export XDG_CONFIG_HOME=~./.config

    echo "Creation settings file..."
    touch $XDG_CONFIG_HOME/nvim/dein.toml
    touch $XDG_CONFIG_HOME/nvim/dein_lazy.toml
    touch $XDG_CONFIG_HOME/nvim/init.vim

    echo "Neovim complete!"

}
