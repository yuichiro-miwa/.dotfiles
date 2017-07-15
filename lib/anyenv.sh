#!/bin/sh

run_anyenv(){

    # スクリプト実行時に制御文以外でエラーが発生した場合に スクリプトを終了させる。
    # ↓をいれているとbrewですでにインストール済みのものを再インストールするとエラーになりスクリプトが止まる
    set -e

    echo "installing anyenv..."
    git clone https://github.com/riywo/anyenv

    echo "installing rbenv / pynev / ndenv..."
    anyenv install rbenv
    anyenv install pyenv
    anyenv install ndenv
    exec $SHELL -l

    echo "anyenv complete!"

}
