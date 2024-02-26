# -- oh my zsh --
# https://github.com/ohmyzsh/ohmyzsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="tjkirch"

# -- plugins --
plugins+=(git)
plugins+=(fzf)
plugins+=(zsh-vi-mode)

# widget
fzf_git_branch() {
  _SELECTED_BRANCH=$(git branch -a \
    | grep -v '^*' \
    | grep -v 'HEAD -> ' \
    | sed -e 's/remotes\///' -e 's/origin\///' \
    | sort \
    | uniq \
    | awk '{print $1}' \
    | fzf)
  LBUFFER+=$_SELECTED_BRANCH
}

function zvm_after_lazy_keybindings() {
  zvm_define_widget fzf_git_branch
  zvm_bindkey viins '^B' fzf_git_branch
}

source $ZSH/oh-my-zsh.sh
source $HOME/.zshrc.local

# theme
export LANG=en_US.UTF-8

# exports
export EDITOR='nvim'

# alias
alias la='ls -lah'
alias vi='nvim'
alias virc='nvim ~/.config/nvim/init.lua'

# fzf
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
