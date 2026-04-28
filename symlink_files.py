# SPDX-FileCopyrightText: Copyright (c) 2025 LordFckHelmchen
# SPDX-License-Identifier: GPL-3.0-or-later

"""Creates (or updates) symlinks to the files."""

import argparse
import os
import sys
from collections.abc import Iterable
from collections.abc import Iterator
from dataclasses import dataclass
from pathlib import Path

WIN_ERROR_INSUFFICIENT_PRIVILEGES = 1314


@dataclass(frozen=True)
class RepoFileMap:
    """Maps files in the repo to an explicit target directory."""

    file_names: Iterable[str]
    repo_sub_dir: str
    target_dir: Path

    def get_file_pairs(self) -> Iterator[tuple[Path, Path]]:
        """
        Generate pairs of (relative repo path, absolute target path) for each file.

        Yields
        ------
        tuple[Path, Path]
            A tuple of the relative repo file path and the absolute target file path.
        """
        for file in self.file_names:
            yield Path(self.repo_sub_dir) / file, self.target_dir / file


HOME = Path(os.environ.get("HOME", os.environ["USERPROFILE"]))
CONFIG_DIR = Path(os.environ.get("XDG_CONFIG_HOME", HOME / ".config"))

BASH_FILES = RepoFileMap(
    file_names={".bashrc", ".bash_aliases", ".bash_profile", ".bash_completion"}, repo_sub_dir="bash", target_dir=HOME
)
GIT_CONFIG_FILE = RepoFileMap(file_names={".gitconfig"}, repo_sub_dir="git", target_dir=HOME)
GIT_PROMPT_FILE = RepoFileMap(file_names={"git-prompt.sh"}, repo_sub_dir="bash", target_dir=CONFIG_DIR / "bash")
STARSHIP_CONFIG_FILE = RepoFileMap(file_names={"starship.toml"}, repo_sub_dir="themes", target_dir=CONFIG_DIR)


def symlink_files(*, link_git_prompt: bool, link_starship_config: bool, exist_ok: bool) -> None:
    """
    Create symbolic links from the configuration files in this repo to the user's home directory.

    If run on Windows, the console must be started with admin rights, otherwise symlink creation will fail.

    Parameters
    ----------
    link_git_prompt
        If True, link the git-prompt file. Mutually exclusive with `link_starship_config`.
    link_starship_config
        If True, link the starship configuration file. Mutually exclusive with `link_git_prompt`.
    exist_ok
        If True, overwrite existing files at the link location is acceptable, otherwise a warning will be displayed and
        the file ignored.

    Raises
    ------
    ValueError
        If both `link_git_prompt` and `link_starship_config` are True.
    """
    if link_git_prompt and link_starship_config:
        msg = "`link_git_prompt` and `link_starship_config` are mutually exclusive."
        raise ValueError(msg)

    files = [BASH_FILES, GIT_CONFIG_FILE]
    if link_starship_config:
        files.append(STARSHIP_CONFIG_FILE)
    elif link_git_prompt:
        files.append(GIT_PROMPT_FILE)
    clink_dir = Path(os.environ.get("LOCALAPPDATA", "")) / "clink"
    if clink_dir.is_dir():
        files.append(
            RepoFileMap(
                file_names={".inputrc", *(["starship.lua"] if link_starship_config else [])},
                repo_sub_dir="cmd",
                target_dir=clink_dir,
            )
        )
    file_pairs = [pair for file_map in files for pair in file_map.get_file_pairs()]

    # Get column widths for pretty printing
    repo_file_name_width_in_chars = max(len(repo_file.as_posix()) for repo_file, _ in file_pairs)
    target_file_name_width_in_chars = max(len(target_file.as_posix()) for _, target_file in file_pairs)

    repo = Path(__file__).parent
    print(f"Creating links to files in '{repo}'")
    for repo_file, target_file in file_pairs:
        link_target = repo / repo_file
        link = target_file
        print(
            f"   {target_file.as_posix():{target_file_name_width_in_chars}} --> "
            f"{repo_file.as_posix():{repo_file_name_width_in_chars}}   ",
            end="",
        )
        if link.exists() and not exist_ok:
            print("ERROR: File already exists! Remove it before calling this script.", file=sys.stderr)
            continue

        link.parent.mkdir(parents=True, exist_ok=True)
        link.unlink(missing_ok=True)
        link.symlink_to(link_target)
        print("SUCCESS.")


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

    try:
        symlink_files(
            link_git_prompt=args.link_git_prompt, link_starship_config=args.link_starship_config, exist_ok=args.force
        )
    except OSError as err:
        if getattr(err, "winerror", None) == WIN_ERROR_INSUFFICIENT_PRIVILEGES:
            print(
                f"ERROR: WinError {WIN_ERROR_INSUFFICIENT_PRIVILEGES} occurred. Windows requires admin "
                "rights for symlinks. Not kidding! So start the console as admin and execute this script again.",
                file=sys.stderr,
            )
            sys.exit(WIN_ERROR_INSUFFICIENT_PRIVILEGES)
        raise
