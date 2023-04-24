#!/usr/bin/env bash

# Creates (or updates) symlinks to the files.
REPO_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ln -sf "$REPO_DIR"/bash/.bashrc "$HOME"/.
ln -sf "$REPO_DIR"/bash/.bash_aliases "$HOME"/.
ln -sf "$REPO_DIR"/bash/.bash_profile "$HOME"/.
ln -sf "$REPO_DIR"/bash/.bash_completion "$HOME"/.
# ln -sf "$REPO_DIR"/bash/git-prompt.sh "$HOME"/.
unset REPO_DIR
