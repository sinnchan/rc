#!/bin/sh

rc_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

echo $rc_dir

cd ~

ln -s $rc_dir/.config
ln -s $rc_dir/.gitconfig
ln -s $rc_dir/.gitignore
ln -s $rc_dir/.tmux.conf
ln -s $rc_dir/.vimrc
ln -s $rc_dir/.vsnip
ln -s $rc_dir/.zshrc.required
