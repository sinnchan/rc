#!/bin/sh

rc_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

cd $HOME

if [ -d "$HOME/.config" ]; then
  for p in "$rc_dir/.config/"*; do
    [ -e "$p" ] || continue
    ln -s "$p" "$HOME/.config/"
  done
else
  ln -s "$rc_dir/.config" "$HOME/.config"
fi

ln -s $rc_dir/.config
ln -s $rc_dir/.gitconfig
ln -s $rc_dir/.gitignore
ln -s $rc_dir/.tmux.conf
ln -s $rc_dir/.vimrc
ln -s $rc_dir/.vsnip
ln -s $rc_dir/.zshrc.required
