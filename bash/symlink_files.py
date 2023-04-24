#!/usr/bin/env python3

"""Creates (or updates) symlinks to the files."""
import argparse
from pathlib import Path

DEFAULT_FILES = [".bashrc", ".bash_aliases", ".bash_profile", ".bash_completion"]

GIT_PROMPT_FILE = "git-prompt.sh"


def symlink_bash_files(link_git_prompt: bool) -> None:
    repo_bash_dir = Path(__file__).parent

    files = DEFAULT_FILES
    if link_git_prompt:
        files.append(GIT_PROMPT_FILE)
    try:
        print("Linking")
        for file in files:
            link_target = repo_bash_dir / file
            link = Path.home() / file
            print(f"   '{link}' --> '{link_target}': ", end="")
            if not link.exists():
                link.symlink_to(link_target)
                print("success.")
            else:
                print(f"File already exists! Remove it before calling this script.")
    except OSError as err:
        if str(err).startswith("[WinError 1314]"):
            msg = (
                "A WinError occurred - this is most likely since you're on Windows 10. And Windows 10 requires "
                "admin rights for symlinks. Not kidding! So start the console as admin and execute this file"
            )
            raise OSError(msg) from err
        else:
            raise err


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-g",
        "--link_git_prompt",
        action="store_true",
        default=False,
        help="Use bash-native git-prompt. Useful if no git-enhanced prompt (e.g. starship/oh-my-posh) is available.",
    )
    args = parser.parse_args()
    symlink_bash_files(link_git_prompt=args.link_git_prompt)
