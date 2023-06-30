# +-----------+
# | oh my zsh |
# +-----------+
# https://github.com/ohmyzsh/ohmyzsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="simple"

# plugins
plugins+=(git)
plugins+=(zsh-vi-mode)
plugins+=(fzf)

source $ZSH/oh-my-zsh.sh

# -- alias --
alias la='ls -lah'
alias vi='nvim'

# -- flutter --
alias flutter='fvm flutter'
alias frun='(){fvm flutter run -d $3 --dart-define FLAVOR=$1 --dart-define ENV=$2}'
alias fcheck='~/scripts/git-scripts/fcheck.sh'
alias cbranch='git branch --show-current'

# dart
if [[ -f ~/.dvm/scripts/dvm ]]; then
  . ~/.dvm/scripts/dvm
fi

# python

eval "$(_PIPENV_COMPLETE=zsh_source pipenv)"

# -- path --
#
export PATH="/Users/higa/fvm/default/bin:$PATH"
export PATH="$PATH:/Users/higa/Library/Android/sdk/platform-tools"
export PATH="$PATH:$HOME/.pub-cache/bin"

# -- fzf --
#
# https://github.com/junegunn/fzf#key-bindings-for-command-line
# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

# -- java --
export PATH="/usr/local/opt/openjdk@17/bin:$PATH"

