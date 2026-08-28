export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git mise)

source $ZSH/oh-my-zsh.sh

source $HOME/.config/shell/aliases
source $HOME/.config/shell/init

export PATH="$HOME/.local/bin:$PATH:./bin"

# Machine-local additions: PATH entries added by third-party installers,
# per-machine overrides. Sourced last so those entries win. Untracked on
# purpose — see the repo's .gitignore.
[ -f "$HOME/.config/shell/local" ] && source "$HOME/.config/shell/local"
