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
