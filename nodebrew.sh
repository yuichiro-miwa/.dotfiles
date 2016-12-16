#!/bin/sh

# スクリプト実行時に制御文以外でエラーが発生した場合に スクリプトを終了させる。
set -e

echo "installing Nodebrew..."
curl -L git.io/nodebrew | perl - setup
