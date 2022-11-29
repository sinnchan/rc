#!/bin/sh


DOWNLOAD_PATH="$HOME/Downloads"
ONE_DRIVE_PATH="$HOME/OneDrive - Sony/"
PROJECTS_PATH="$HOME/Projects"

FREFLOW_SDK_ANDROID_PATH="$PROJECTS_PATH/freflow-android"
FREFLOW_SDK_IOS_PATH="$PROJECTS_PATH/freflow-ios"

FREFLOW_APP_ANDROID_PATH="$PROJECTS_PATH/freflow-app-android"
FREFLOW_APP_IOS_PATH="$PROJECTS_PATH/freflow-app-ios"

SESSION_NAME="work"

tmux rename-session $SESSION_NAME

WINDOW_NAME="home"

tmux rename-window $WINDOW_NAME
tmux split-window -hc $DOWNLOAD_PATH
tmux split-window -hc $ONE_DRIVE_PATH
tmux select-layout even-horizontal

WINDOW_NAME="vim"

source ~/.vimrc
tmux new-window  -n $WINDOW_NAME -c $HOME

WINDOW_NAME="freflow-app"

tmux new-window  -n $WINDOW_NAME -c $FREFLOW_APP_ANDROID_PATH
tmux split-window -hc $FREFLOW_APP_IOS_PATH
tmux select-layout even-horizontal

WINDOW_NAME="freflow-sdk"

tmux new-window  -n $WINDOW_NAME -c $FREFLOW_SDK_ANDROID_PATH
tmux split-window -hc $FREFLOW_SDK_IOS_PATH
tmux select-layout even-horizontal

