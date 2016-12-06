#!/bin/sh

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

# Update homebrew recipes
printf "Update recipes? [Y/n]: " && read ANS
if [ "${ANS}" = "Y" ]; then
    brew update
fi

# Upgrade all
printf "Upgrade? [Y/n]: " && read ANS
if [ "${ANS}" = "Y" ]; then
    brew upgrade
fi

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
  'wget'

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
  'google-chrom'

  # Communication
  'slack'
  'skype'

  # VM
  'virtualbox'
  'vagrant'

  # etc ...
  'appcleaner'
  'atom'
  'genymotion'
  ### 'dropbox'
  ### 'google-drive'
  'sketch'

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

# We need to link it
brew cask alfred link

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

# シェルをzshにする
[ ${SHELL} != "/bin/zsh"  ] && chsh -s /bin/zsh
echo "$(tput setaf 2)Initialize complete!. ✔︎$(tput sgr0)"
