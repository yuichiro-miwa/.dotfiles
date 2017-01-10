#!/bin/bash

run_brew(){

# スクリプト実行時に制御文以外でエラーが発生した場合に スクリプトを終了させる。
set -e

# コマンドの有無は今後よく使うので
has() {
  type "$1" > /dev/null 2>&1
}

# Check for Homebrew,Install if we don't have it
if has "brew"; then
  echo "$(tput setaf 2)Already installed Homebrew ✔︎$(tput sgr0)"
else
  echo "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


if has "brew"; then
  echo "Updating Homebrew..."
  brew update && brew upgrade
  [[ $? ]] && echo "$(tput setaf 2)Update Homebrew complete. ✔︎$(tput sgr0)"

  # Add Repository
  brew tap homebrew/dupes
  brew tap homebrew/versions
  brew tap homebrew/binary
  brew tap thoughtbot/formulae
  brew tap caskroom/fonts

  local list_formulae
  local -a missing_formulae
  local -a desired_formulae=(
    # Shell
    'zsh'

    # Git
    'git'
    'tig'

    # Database
    'redis'

    # Utils
    'openssl'

    # Tools
    'curl'
    'nkf'
    'tree'
    'lv'
    'wget'
    'ctags'
    'the_silver_searcher' # ag
    'tmux',
    'reattach-to-user-namespace'

    # Languages
    ### 'python3'     # For use in Neovim
    'rbenv'       # For use in Ruby
    'ruby-build'  # For use in Ruby
  )

  local installed=`brew list`

  # desired_formulaeで指定していて、インストールされていないものだけ入れましょ
  for index in ${!desired_formulae[*]}
  do
    local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
    if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
      missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
    else
      echo "Installed ${formula}"
      [[ "${formula}" = "ricty" ]] && local installed_ricty=true
    fi
  done

  if [[ "$missing_formulae" ]]; then
    list_formulae=$( printf "%s " "${missing_formulae[@]}" )

    echo "Installing missing Homebrew formulae..."
    brew install $list_formulae

    [[ $? ]] && echo "$(tput setaf 2)Installed missing formulae ✔︎$(tput sgr0)"
  fi


  # Casks
  brew install caskroom/cask/brew-cask

  local -a missing_formulae=()
  local -a desired_formulae=(
    # Launcher
    'alfred'

    # Browser
    'firefox'
    'google-chrome'
    'blisk'
    'vivaldi'

    # Communication
    'slack'
    'skype'

    # VM
    'virtualbox'
    'vagrant'

    # etc ...
    'appcleaner'
    'atom'
    'sublime-text'
    'brackets'
    'mi'
    'genymotion'
    'dropbox'
    'evernote'
     ### 'google-drive'
    'sketch'
    'screaming-frog-seo-spider '
    'franz'

    # development
    'iterm2'
    'sourcetree'
    'sequel-pro'

    'licecap'
  )
  # cask
  local installed=`brew cask list`

  for index in ${!desired_formulae[*]}
  do
    local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
    if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
      missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
    else
      echo "Installed ${formula}"
    fi
  done

  if [[ "$missing_formulae" ]]; then
    list_formulae=$( printf "%s " "${missing_formulae[@]}" )

    echo "Installing missing Homebrew formulae..."
    brew cask install $list_formulae

    [[ $? ]] && echo "$(tput setaf 2)Installed missing formulae ✔︎$(tput sgr0)"
  fi

  echo "Cleanup Homebrew..."
  brew cleanup
  echo "$(tput setaf 2)Cleanup Homebrew complete. ✔︎$(tput sgr0)"
fi

}

