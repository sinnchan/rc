# path
alias path="echo $PATH | sed -e 's/:/\n/g'" | sort

# nvim
alias vi="nvim"
## nvim plugin manager
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "download nvim plugin manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# dir_color
test -r ~/.dir_colors && eval "$(dircolors -b ~/.dir_colors)" || eval "$(dircolors -b)"

