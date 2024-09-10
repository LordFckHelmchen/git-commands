#!/usr/bin/env python3

"""Creates (or updates) symlinks to the files."""

import argparse
import os
import warnings
from collections.abc import Iterable
from dataclasses import dataclass, field
from pathlib import Path


@dataclass(frozen=True)
class RepoFileMap:
    file_names: Iterable
    repo_sub_dir: str
    home_sub_dir: str = ""  # Omit, if copying to HOME directly
    _max_repo_file_chars: int = field(init=False)
    _max_home_file_chars: int = field(init=False)

    def __post_init__(self):
        max_repo_chars, max_home_chars = max(
            (len(str(repo_file)), len(str(home_file)))
            for repo_file, home_file in self.get_relative_file_names()
        )
        super().__setattr__("_max_repo_file_chars", max_repo_chars)
        super().__setattr__("_max_home_file_chars", max_home_chars)

    def get_relative_file_names(self):
        for file in self.file_names:
            yield Path(self.repo_sub_dir) / file, Path(self.home_sub_dir) / file

    @property
    def max_repo_file_name_chars(self) -> int:
        return self._max_repo_file_chars

    @property
    def max_home_file_name_chars(self) -> int:
        return self._max_home_file_chars


HOME = Path(os.environ["HOME"])
CONFIG_SUBDIR = os.environ.get("XDG_CONFIG_HOME", ".config")

BASH_FILES = RepoFileMap(
    file_names={".bashrc", ".bash_aliases", ".bash_profile", ".bash_completion"},
    repo_sub_dir="bash",
)
GIT_PROMPT_FILE = RepoFileMap(
    file_names={"git-prompt.sh"},
    repo_sub_dir="bash",
    home_sub_dir=f"{CONFIG_SUBDIR}/bash",
)
STARSHIP_CONFIG_FILE = RepoFileMap(
    file_names={"starship.toml"},
    repo_sub_dir="themes",
    home_sub_dir=CONFIG_SUBDIR,
)
XONSH_CONFIG_FILE = RepoFileMap(
    file_names={"rc.xsh"},
    repo_sub_dir="xonsh",
    home_sub_dir=os.environ.get("XONSH_CONFIG_DIR", f"{CONFIG_SUBDIR}/xonsh"),
)


def symlink_files(
    link_git_prompt: bool, link_starship_config: bool, link_xonsh_config: bool
) -> None:
    files = [BASH_FILES]
    if link_git_prompt:
        files.append(GIT_PROMPT_FILE)
    if link_starship_config:
        files.append(STARSHIP_CONFIG_FILE)
    if link_xonsh_config:
        files.append(XONSH_CONFIG_FILE)

    repo_file_name_width_in_chars = max(
        file_map.max_repo_file_name_chars for file_map in files
    )
    home_file_name_width_in_chars = max(
        file_map.max_home_file_name_chars for file_map in files
    )

    repo = Path(__file__).parent
    print(f"Creating links from HOME='{HOME}' to files in '{repo}'")
    try:
        for file_map in files:
            for repo_file, home_file in file_map.get_relative_file_names():
                link_target = repo / repo_file
                link = HOME / home_file
                print(
                    f"   {str(home_file):{repo_file_name_width_in_chars}} --> "
                    f"{str(repo_file):{home_file_name_width_in_chars}}   ",
                    end="",
                )
                if not link.exists():
                    if not link.parent.is_dir():
                        print(
                            "INFO: Creating parent directory and linking file. ", end=""
                        )
                        link.parent.mkdir()
                    link.symlink_to(link_target)
                    print("SUCCESS.")
                else:
                    print(
                        "ERROR: File already exists! Remove it before calling this script."
                    )
    except OSError as err:
        if str(err).startswith("[WinError 1314]"):
            msg = (
                "A WinError occurred - this is most likely since you're on Windows 10. And Windows 10 requires "
                "admin rights for symlinks. Not kidding! So start the console as admin and execute this file_map"
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
    parser.add_argument(
        "-s",
        "--link_starship_config",
        action="store_true",
        default=False,
        help="Link to starship configuration file.",
    )
    parser.add_argument(
        "-x",
        "--link_xonsh_config",
        action="store_true",
        default=False,
        help="Link to xonsh configuration file.",
    )
    args = parser.parse_args()
    if args.link_git_prompt and args.link_xonsh_config:
        warnings.warn(
            "Using bash-native git-prompt and starship is superfluous. Use starship alone instead."
        )
    symlink_files(
        link_git_prompt=args.link_git_prompt,
        link_starship_config=args.link_starship_config,
        link_xonsh_config=args.link_xonsh_config,
    )
