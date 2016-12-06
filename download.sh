#!/bin/bash

# スクリプト実行時に制御文以外でエラーが発生した場合に スクリプトを終了させる。
set -e

# 変数設定(各自の環境に合わせて設定)
DOT_DIRECTORY="${HOME}/dotfiles"
DOT_TARBALL="https://github.com/yuichiro-miwa/dotfiles.git"
REMOTE_URL="git@github.com:yuichiro-miwa/.dotfiles.git"

# コマンド有無の確認用
has() {
  type "$1" > /dev/null 2>&1
}

# Working only OS X.
# ${OSTYPE}でOSタイプを判定
case ${OSTYPE} in
  darwin*)
    ;;
  *)
    echo $(tput setaf 1)Working only OS X!!$(tput sgr0)
    exit 1
    ;;
esac


# If missing, download and extract the dotfiles repository
if [ ! -d ${DOT_DIRECTORY} ]; then
  echo "Downloading dotfiles..."
  mkdir ${DOT_DIRECTORY}

  if has "git"; then
    git clone --recursive "${REMOTE_URL}" "${DOT_DIRECTORY}"
  else
    curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOT_TARBALL}
    tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOT_DIRECTORY}
    rm -f ${HOME}/dotfiles.tar.gz
  fi

  echo $(tput setaf 2)Download dotfiles complete!. ✔︎$(tput sgr0)
fi
