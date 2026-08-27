export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git mise)

source $ZSH/oh-my-zsh.sh

source $HOME/.config/shell/aliases
source $HOME/.config/shell/init

export PATH="$HOME/.local/bin:$PATH:./bin"
