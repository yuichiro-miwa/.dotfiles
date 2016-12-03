#!/bin/sh

# スクリプト実行時に制御文以外でエラーが発生した場合に スクリプトを終了させる。
set -e

# Check for Homebrew,Install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
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

packages=(

    # Shell
    zsh

    # Git
    git
    tig

    # Database

    # Utils
    openssl

    # Tools
    curl
    nkf
    tree
    wget

    # Languages
    python3 # For use in Neovim

)

echo "installing binaries..."
brew install ${packages[@]} && brew cleanup

# Casks
brew install caskroom/cask/brew-cask

# Apps
apps=(

    # Launcher
    alfred

    # Browser
    firefox
    google-chrom

    # Communication
    slack
    skype

    # VM
    virtualbox
    vagrant

    # etc ...
    atom
    genymotion
    ### dropbox
    ### google-drive
    ### sketch

    # development
    iterm2
    sourcetree
    sequel-pro
)

# Install apps to /Applications
echo "installing applications..."
brew cask install ${apps[@]}

# We need to link it
brew cask alfred link

# シェルをzshにする
[ ${SHELL} != "/bin/zsh"  ] && chsh -s /bin/zsh
echo "$(tput setaf 2)Initialize complete!. ✔︎$(tput sgr0)"
