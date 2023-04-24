#!/usr/bin/env bash

BASH_COMPLETION_FOLDER="$HOME/.bash_completion.d"
if [[ ! -d "$BASH_COMPLETION_FOLDER" ]]; then
    mkdir "$BASH_COMPLETION_FOLDER"
fi

if [ -x "$(command -v poetry)" ]; then
  poetry completions bash > "$BASH_COMPLETION_FOLDER/poetry.completion"
fi
if [ -x "$(command -v pip)" ]; then
  pip completion --bash > "$BASH_COMPLETION_FOLDER/pip.completion"
fi

unset BASH_COMPLETION_FOLDER
