#!/bin/sh

DOWNLOAD_PATH="$HOME/Downloads"
ONE_DRIVE_PATH="$HOME/OneDrive\ -\ Sony"
PROJECTS_PATH="$HOME/projects"
FLUTTER_PROJ_PATH="$PROJECTS_PATH/app-flutter"

SESSION_NAME="work"

tmux rename-session $SESSION_NAME

WINDOW_NAME="home"

tmux rename-window $WINDOW_NAME
tmux split-window -hc $DOWNLOAD_PATH
tmux split-window -hc $ONE_DRIVE_PATH
tmux select-layout even-horizontal

WINDOW_NAME="work"

tmux new-window  -n $WINDOW_NAME -c $FLUTTER_PROJ_PATH
tmux split-window -hc $FLUTTER_PROJ_PATH
tmux split-window -vc $FLUTTER_PROJ_PATH

WINDOW_NAME="device"

tmux new-window  -n $WINDOW_NAME -c $FLUTTER_PROJ_PATH
tmux split-window -hc $FLUTTER_PROJ_PATH
