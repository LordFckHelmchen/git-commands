# SPDX-FileCopyrightText: Copyright (c) 2025 LordFckHelmchen
# SPDX-License-Identifier: GPL-3.0-or-later

"""Creates (or updates) symlinks to the files."""

import argparse
import os
from collections.abc import Generator
from collections.abc import Iterable
from dataclasses import dataclass
from dataclasses import field
from pathlib import Path
from typing import Any

WIN_ERROR_INSUFFICIENT_PRIVILEGES = 1314


@dataclass(frozen=True)
class RepoFileMap:
    """
    Maps files in the repo to an explicit target directory.

    Also provides formatting information for printing the file names in a tabular format.
    """

    file_names: Iterable
    repo_sub_dir: str
    target_dir: Path
    _max_repo_file_chars: int = field(init=False)
    _max_target_file_chars: int = field(init=False)

    def __post_init__(self) -> None:
        max_repo_chars, max_target_chars = max(
            (len(str(repo_file)), len(str(target_file))) for repo_file, target_file in self.get_file_pairs()
        )
        super().__setattr__("_max_repo_file_chars", max_repo_chars)
        super().__setattr__("_max_target_file_chars", max_target_chars)

    def get_file_pairs(self) -> Generator[tuple[Path, Path], Any, None]:
        """
        Generate pairs of (relative repo path, absolute target path) for each file.

        Yields
        ------
        tuple[Path, Path]
            A tuple of the relative repo file path and the absolute target file path.
        """
        for file in self.file_names:
            yield Path(self.repo_sub_dir) / file, self.target_dir / file

    @property
    def max_repo_file_name_chars(self) -> int:
        """
        Return the maximum number of characters in any repository file name.

        Returns
        -------
        int
            The maximum length of repository file names in characters.
        """
        return self._max_repo_file_chars

    @property
    def max_target_file_name_chars(self) -> int:
        """
        Return the maximum number of characters in any target file path.

        Returns
        -------
        int
            The maximum length of target file paths in characters.
        """
        return self._max_target_file_chars


HOME = Path(os.environ.get("HOME", os.environ["USERPROFILE"]))
CONFIG_DIR = Path(os.environ.get("XDG_CONFIG_HOME", HOME / ".config"))

BASH_FILES = RepoFileMap(
    file_names={".bashrc", ".bash_aliases", ".bash_profile", ".bash_completion"}, repo_sub_dir="bash", target_dir=HOME
)
GIT_CONFIG_FILE = RepoFileMap(file_names={".gitconfig"}, repo_sub_dir="git", target_dir=HOME)
GIT_PROMPT_FILE = RepoFileMap(file_names={"git-prompt.sh"}, repo_sub_dir="bash", target_dir=CONFIG_DIR / "bash")
STARSHIP_CONFIG_FILE = RepoFileMap(file_names={"starship.toml"}, repo_sub_dir="themes", target_dir=CONFIG_DIR)


def symlink_files(*, link_git_prompt: bool, link_starship_config: bool, overwrite_existing_files: bool) -> None:
    """
    Create symbolic links from the configuration files in this repo to the user's home directory.

    If run on Windows, the console must be started with admin rights, otherwise symlink creation will fail.

    Parameters
    ----------
    link_git_prompt
        If True, link the git-prompt file. Mutually exclusive with `link_starship_config` - will be ignored if both are
        True.
    link_starship_config
        If True, link the starship configuration file. Mutually exclusive with `link_git_prompt`.
    overwrite_existing_files
        If True, overwrite existing files at the link location.

    Raises
    ------
    OSError
        If an OS-related error occurs, such as insufficient permissions for creating symlinks on Windows.
    """
    files = [BASH_FILES, GIT_CONFIG_FILE]

    if link_starship_config:
        files.append(STARSHIP_CONFIG_FILE)
        if link_git_prompt:
            print("WARNING: Cannot link both git-prompt and starship config - ignoring git-prompt.", file=sys.stderr)
    elif link_git_prompt:
        files.append(GIT_PROMPT_FILE)

    repo_file_name_width_in_chars = max(file_map.max_repo_file_name_chars for file_map in files)
    target_file_name_width_in_chars = max(file_map.max_target_file_name_chars for file_map in files)

    repo = Path(__file__).parent
    print(f"Creating links to files in '{repo}'")
    try:
        for file_map in files:
            for repo_file, target_file in file_map.get_file_pairs():
                link_target = repo / repo_file
                link = target_file
                print(
                    f"   {target_file!s:{target_file_name_width_in_chars}} --> "
                    f"{repo_file!s:{repo_file_name_width_in_chars}}   ",
                    end="",
                )
                if link.exists() and not overwrite_existing_files:
                    print("ERROR: File already exists! Remove it before calling this script.", file=sys.stderr)
                else:
                    link.parent.mkdir(parents=True, exist_ok=True)
                    link.unlink(missing_ok=True)
                    link.symlink_to(link_target)
                    print("SUCCESS.")
    except OSError as err:
        if getattr(err, "winerror", None) == WIN_ERROR_INSUFFICIENT_PRIVILEGES:
            print(
                f"ERROR: WinError {WIN_ERROR_INSUFFICIENT_PRIVILEGES} occurred. Windows requires admin rights for "
                "symlinks. Not kidding! So start the console as admin and execute this script again.",
                file=sys.stderr,
            )
            sys.exit(WIN_ERROR_INSUFFICIENT_PRIVILEGES)
        raise


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group()
    group.add_argument(
        "-g",
        "--link_git_prompt",
        action="store_true",
        default=False,
        help="Use bash-native git-prompt. Useful if no git-enhanced prompt (e.g. starship/oh-my-posh) is available.",
    )
    group.add_argument(
        "-s", "--link_starship_config", action="store_true", default=False, help="Link to starship configuration file."
    )
    parser.add_argument("-f", "--force", action="store_true", default=False, help="Force overwriting existing files.")
    args = parser.parse_args()
    symlink_files(
        link_git_prompt=args.link_git_prompt,
        link_starship_config=args.link_starship_config,
        overwrite_existing_files=args.force,
    )
