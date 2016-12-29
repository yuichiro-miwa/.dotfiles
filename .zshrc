#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

### node
export PATH=$HOME/.nodebrew/current/bin:$PATH

### rbenv
export RBENV_ROOT=/usr/local/var/rbenv
eval "$(rbenv init - zsh)"

### gulpコマンドのpathを通す
export PATH=$PATH:./node_modules/.bin

############################################################ 以下zplug関連

source ~/.zplug/init.zsh

# prezto
zplug "sorin-ionescu/prezto"

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load --verbose
