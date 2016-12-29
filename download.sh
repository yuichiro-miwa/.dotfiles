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

cd ${DOT_DIRECTORY}
source ./lib/homebrew
source ./lib/neovim

link_files() {

    # 各自追記
    # neovimの設定
    echo "Neovim link..."
    ln -sf ~/dotfiles/neovim/dein_lazy.toml ~/.config/nvim/dein_lazy.toml
    ln -sf ~/dotfiles/neovim/dein.toml ~/.config/nvim/dein.toml
    ln -sf ~/dotfiles/neovim/init.vim ~/.config/nvim/init.vim

    # preztoの設定
    echo "Prezto link..."
    # zplugを導入したのでlnを変更
    # ln -nfs ~/dotfiles/prezto ~/.zprezto
    ln -s $HOME/.zplug/repos/sorin-ionescu/prezto $HOME/.zprezto

    # ファイルへ
    ln -sf ~/dotfiles/.zlogin ~/.zlogin
    ln -sf ~/dotfiles/.zlogout ~/.zlogout
    ln -sf ~/dotfiles/.zpreztorc ~/.zpreztorc
    ln -sf ~/dotfiles/.zprofile ~/.zprofile
    ln -sf ~/dotfiles/.zshenv ~/.zshenv
    ln -sf ~/dotfiles/.zshrc ~/.zshrc

}


initialize() {

    # brewダウンドロード
    run_brew

    # Brewで入れたプログラム言語管理コマンドの初期処理
    if has "rbenv"; then
      # 最新のRubyを入れる
      latest=`rbenv install --list | grep -v - | tail -n 1`
      current=`rbenv versions | tail -n 1 | cut -d' ' -f 2`
      if [ ${current} != ${latest} ]; then
        rbenv install ${latest}
        rbenv global ${latest}
      fi
    fi

    # neovimのインストール
    if has "nvim -v"; then
        run_neovim
    fi

    # nodebrewのインストールと最新のnodeを導入
    if has "nodebrew"; then
       # Install latest node
       current=`nodebrew ls | tail -n 1 | cut -d' ' -f 2`
       if [ ${current} = "none"  ]; then
         curl -sL git.io/nodebrew | perl - setup
         nodebrew install-binary latest
         nodebrew use latest
       fi
     fi

    # zplugの導入
    if [ ! -e $HOME/.zplug ]; then
      # Install
      curl -sL zplug.sh/installer | zsh
    fi

    # シェルをzshにする
    [ ${SHELL} != "/bin/zsh"  ] && chsh -s /bin/zsh
    echo "$(tput setaf 2)Initialize complete!. ✔︎$(tput sgr0)"
}

command=$1
[ $# -gt 0 ] && shift

case $command in
  deploy)
    link_files
    ;;
  init*)
    initialize
    ;;
  *)
    usage
    ;;
esac

exit 0









