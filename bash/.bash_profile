#!/bin/bash

# Init bash
# shellcheck disable=SC1090  # We don't know the home directory of the user running the script
test -f ~/.profile && . ~/.profile
test -f ~/.bashrc && . ~/.bashrc
