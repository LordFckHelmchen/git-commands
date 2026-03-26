# git-commands

Contains bash configurations and other useful bash modifications (e.g. git-prompts, git aliases, ...)

## Purpose

This repository contains personal shell/tooling configuration files and helper scripts for:

- Bash (`bash/`)
- Git (`git/`)
- Themes and prompt configuration (`themes/`, `windows-terminal/`, `power-toys/`)
- VS Code settings (`vscode/`)
- Small utility scripts (`python/`)

## Prerequisites

- Python 3.10+ available as `python`
- Git Bash (recommended on Windows)
- Symlink permissions on Windows (run terminal as Administrator or enable Developer Mode)

## Quick Start

From the repository root, create/update symlinks into your home directory:

```bash
python symlink_files.py
```

This links core files such as:

- `bash/.bashrc`, `bash/.bash_aliases`, `bash/.bash_profile`, `bash/.bash_completion` -> `$HOME/`
- `git/.gitconfig` -> `$HOME/.gitconfig`

### Optional prompt setup

Use the bash-native git prompt:

```bash
python symlink_files.py --link_git_prompt
```

This additionally links:

- `bash/git-prompt.sh` -> `$XDG_CONFIG_HOME/bash/git-prompt.sh` (or `$HOME/.config/bash/git-prompt.sh`)

Use Starship instead:

```bash
python symlink_files.py --link_starship_config
```

This links:

- `themes/starship.toml` -> `$XDG_CONFIG_HOME/starship.toml` (or `$HOME/.config/starship.toml`)

### Overwrite existing files

If destination files already exist, force replacement:

```bash
python symlink_files.py --force
```

## Repository Contents

- `bash/`: bash startup files and prompt script
- `git/`: git helper scripts
- `github/`: GitHub workflow YAML snippets
- `python/`: utility scripts and example configs
- `themes/`: theme docs and Starship config
- `vscode/`: VS Code settings/profile exports
- `windows-terminal/`: Windows Terminal profile and color schemes

## Notes

- `--link_git_prompt` and `--link_starship_config` are mutually exclusive.
- Re-run the symlink script any time you add or change tracked config files.
