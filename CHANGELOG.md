# Changelog

## [2.0.0](https://github.com/LordFckHelmchen/git-commands/compare/v1.0.0...v2.0.0) (2026-03-30)


### ⚠ BREAKING CHANGES

* **windows-terminal:** Remove unused themes
* **windows-terminal:** Fix wrong folder name

### Features

* **bash:** Add new aliases for ping, mkdir & rm ([dddab4f](https://github.com/LordFckHelmchen/git-commands/commit/dddab4f571acb64ce54f82bfe39d7c87d322d4b8))
* **bash:** Enhance updateTools function to support multiple command updates ([e644f9a](https://github.com/LordFckHelmchen/git-commands/commit/e644f9ab3e80e2f0dff4ceb3bdf3d55e7b6b7c23))
* **vscode:** Update settings & profile ([c6d5d8c](https://github.com/LordFckHelmchen/git-commands/commit/c6d5d8cd21bc77f4cd1d3c7340aa492b3a01908f))
* **windows-terminal:** Update Git Bash profile and remove unused entries ([7318572](https://github.com/LordFckHelmchen/git-commands/commit/73185729208612fe4f08202f5a89906ca018524b))


### Bug Fixes

* Use USERPROFILE as fallback if HOME is not in the environment ([0387dce](https://github.com/LordFckHelmchen/git-commands/commit/0387dce9421ad5e0c0655518ef729721c4961e6d))
* **windows-terminal:** Fix wrong folder name ([9fed6da](https://github.com/LordFckHelmchen/git-commands/commit/9fed6da4b0acbaa23d01a298b46f86a8d3572724))


### Code Refactoring

* **windows-terminal:** Remove unused themes ([bd7513e](https://github.com/LordFckHelmchen/git-commands/commit/bd7513e2d4db7f114872066d0e11899c192a13cf))

## 1.0.0 (2026-03-20)


### ⚠ BREAKING CHANGES

* Rename vscode & windows-terminal folders to match cc scopes
* **bash:** Remove several functions & modularize code
* **bash:** Switch to gittyup for repo updates
* **bash:** Remove all GH Copilot aliases
* **nushell:** Drop nu support
* Make overwrite_existing_files mandatory & reformat
* **xonsh:** Remove xonsh support
* **bash:** Remove default log-level & refactor logging function
* **git:** Use gitconfig to store aliases & symlink it
* **bash:** Rename gitup to gu
* Move completion scripts
* Add OS-specificity & other cools things and drop conda stuff

### Features

* Add auto-detect of repo dir to setup script ([1a56ea4](https://github.com/LordFckHelmchen/git-commands/commit/1a56ea4f0f6f1a6f0d398162abf20add05dc823b))
* Add git-prompt & update symlink_files.sh ([1c0fa09](https://github.com/LordFckHelmchen/git-commands/commit/1c0fa091a5b58819132463b4395af5bd7978a7a6))
* Add OS-specificity & other cools things and drop conda stuff ([9fdab59](https://github.com/LordFckHelmchen/git-commands/commit/9fdab5919cb2cfc365de675eb08079eeceee4efa))
* Add script to add completions for pip & poetry ([d84b111](https://github.com/LordFckHelmchen/git-commands/commit/d84b11131e1a73b2f8a9d6d853e8785576f676e8))
* Add updateAll function & local bin paths ([6254f8d](https://github.com/LordFckHelmchen/git-commands/commit/6254f8db9e51b0629287df332fef903670208001))
* Allow overwriting of existing symlinks ([9e71e33](https://github.com/LordFckHelmchen/git-commands/commit/9e71e33c8372121b7b8ab7181a0e1939992699a4))
* **bash:** Add & use logging function ([0619d0b](https://github.com/LordFckHelmchen/git-commands/commit/0619d0b8f4d73a9f90598880b3ccd02e1d044c13))
* **bash:** Add aliases for GH Copilot and enable VSCode terminal shell integration ([5229a09](https://github.com/LordFckHelmchen/git-commands/commit/5229a095380f1503257dfb069c7c364959f37245))
* **bash:** Add completion for ADR ([eb68cef](https://github.com/LordFckHelmchen/git-commands/commit/eb68cefa5af805003fc95ffe21dd7bafa8815e2c))
* **bash:** Add completions for pipx ([819786c](https://github.com/LordFckHelmchen/git-commands/commit/819786cdf9181e6712849d0a888398bc08d46395))
* **bash:** Add deduplicate_path function to clean up PATH variable ([7f0ac82](https://github.com/LordFckHelmchen/git-commands/commit/7f0ac8227ec0ca35cf5a5e5d75de09857623041f))
* **bash:** Add gh cli & copilot support ([1e18086](https://github.com/LordFckHelmchen/git-commands/commit/1e180869b14e9c84290d612bc4abe52491f394ac))
* **bash:** Add git shortcuts gs, gD, gb, gp, gpf ([219df53](https://github.com/LordFckHelmchen/git-commands/commit/219df53a36015b30698802fd03a9625fe40b47de))
* **bash:** Add gitl & poetry support ([e7f0013](https://github.com/LordFckHelmchen/git-commands/commit/e7f0013ee451e0872115a50b761f38ad267cb25b))
* **bash:** Add global log-level & fix script name logging ([d6d2109](https://github.com/LordFckHelmchen/git-commands/commit/d6d21098fe865b59c8a478a475f83757591967f0))
* **bash:** Add human-readable file-sizes to ls-family ([3ead3c2](https://github.com/LordFckHelmchen/git-commands/commit/3ead3c24e1d83fcf224a9e5c36849332f4008cf3))
* **bash:** Add is_command alias ([430ef3a](https://github.com/LordFckHelmchen/git-commands/commit/430ef3ad7f162097f0f490bef70f1794b6028635))
* **bash:** Add moar aliases ([1aef895](https://github.com/LordFckHelmchen/git-commands/commit/1aef89588dc887dbc0a192bd5fc2c2bf283fa0dc))
* **bash:** Add now alias ([b732a6a](https://github.com/LordFckHelmchen/git-commands/commit/b732a6a6942fe680586ca0f4e1c5d0292736b881))
* **bash:** Add pipx to updateAll ([b596c7e](https://github.com/LordFckHelmchen/git-commands/commit/b596c7eb1f9a7c1bd752eb1c52e5bce5ed08da7a))
* **bash:** Add rumdl completions & refactor bash completion management ([84e7755](https://github.com/LordFckHelmchen/git-commands/commit/84e77553cbdbf1e458349bbab87408ce60e13090))
* **bash:** Add support for system-specific configuration via local file ([dd3110a](https://github.com/LordFckHelmchen/git-commands/commit/dd3110a09ec660800fcb2a6fc520f58dd3525c5d))
* **bash:** Add update for ADR in updateAll ([df57b77](https://github.com/LordFckHelmchen/git-commands/commit/df57b77ef087559d86ae99f88aedd37d84c045c9))
* **bash:** Add update for rust & uv ([aed8a1e](https://github.com/LordFckHelmchen/git-commands/commit/aed8a1e4581f2b86c0ca980c5faf38c64e913fbf))
* **bash:** Add uv completions if uv is present ([46b8fc0](https://github.com/LordFckHelmchen/git-commands/commit/46b8fc09f8640e55f647600d91f5e7b2f36dc93a))
* **bash:** Allow to log the duration of a script when done ([858b5d7](https://github.com/LordFckHelmchen/git-commands/commit/858b5d70ac03657e47b4a03d3beb1ccf0e589f21))
* **bash:** Create completion dir if not existing ([2f971c1](https://github.com/LordFckHelmchen/git-commands/commit/2f971c1030b1d30ac3e3487de02c9679cd473ec6))
* **bash:** Create completions only once per day ([a927ecd](https://github.com/LordFckHelmchen/git-commands/commit/a927ecd48ba9a2234c4a1b401f7aa779af1978c8))
* **bash:** Define env var for ADR_HOME ([127fa68](https://github.com/LordFckHelmchen/git-commands/commit/127fa68283a1530dab5cdbefd08df3a6ca8edb13))
* **bash:** Enhance bash completion management with new functions ([20d5891](https://github.com/LordFckHelmchen/git-commands/commit/20d5891af32517f94c1352b91a799d6aa37d3d8d))
* **bash:** Enhance update functions to modularize tool & repository updates ([618345f](https://github.com/LordFckHelmchen/git-commands/commit/618345f6edc54965cb9d0cec2df467e3f7db6582))
* **bash:** Make git-prompt & starship config conditional on each other & the OS ([6945429](https://github.com/LordFckHelmchen/git-commands/commit/69454298d49b3721a535bcc35d6fe7220959d384))
* **bash:** Make l alias show everything in a single column ([5b13214](https://github.com/LordFckHelmchen/git-commands/commit/5b1321440c064c114c8fe2a76b5a0a95d187d68e))
* **bash:** Make log level a top-level env var ([4ac2aea](https://github.com/LordFckHelmchen/git-commands/commit/4ac2aeaf1a105fde6c3f2cd42fc3132fcb42ed47))
* **bash:** Omit "." & ".." in all ls-related commands ([2f79a6b](https://github.com/LordFckHelmchen/git-commands/commit/2f79a6bead9bb46b259cf884abfd4b98ce5d1d3f))
* **bash:** Prefix time to log messages ([e4acfb7](https://github.com/LordFckHelmchen/git-commands/commit/e4acfb70d6b536bd4e57794ca238ef8088794b3e))
* **bash:** Reintroduce suppress-error flag in source_if_exists ([1d97e00](https://github.com/LordFckHelmchen/git-commands/commit/1d97e008fd2f4c3d3a1a7267a47dea8f09c0f7b1))
* **bash:** Set default log level to info ([14774ea](https://github.com/LordFckHelmchen/git-commands/commit/14774ead68e84aefd53e53e0144ee8bbd1ff0d33))
* **bash:** Show directories first in ls-related commands ([2a49f61](https://github.com/LordFckHelmchen/git-commands/commit/2a49f61862359775c98f2836232e1cef2c99aa53))
* **bash:** Switch to gittyup for repo updates ([4a0f9a6](https://github.com/LordFckHelmchen/git-commands/commit/4a0f9a66b2742d7dc487a2b2add6cb512c64e619))
* **bash:** Update bash scripts ([630dd98](https://github.com/LordFckHelmchen/git-commands/commit/630dd9808293287106665b2d75379087ab04f593))
* **bash:** Update uvx & pyenv in updateAll & refactor a little ([6f4f91b](https://github.com/LordFckHelmchen/git-commands/commit/6f4f91bf72e6cdbf0161d0f1105c60b9ca1bd779))
* **git:** Add alias for listing unique conventional commit scopes ([df85f87](https://github.com/LordFckHelmchen/git-commands/commit/df85f872ffd9ca5a8a77e9e91304b2795227d33d))
* **git:** Add alias for rebasing most recent changes on main ([4df7787](https://github.com/LordFckHelmchen/git-commands/commit/4df7787ffbdaf2a9f0d396c252968b53875b4f2d))
* **git:** Add git graph alias ([230f6a9](https://github.com/LordFckHelmchen/git-commands/commit/230f6a994da30de499325a7fab12c9d4e607d1d0))
* **git:** Add script to convert a lightweight into an annotated tag ([56a43b5](https://github.com/LordFckHelmchen/git-commands/commit/56a43b58fbd19925e4e3091e9a1c4e8a15725f85))
* **git:** Add support for system-specific configuration via local file ([057404e](https://github.com/LordFckHelmchen/git-commands/commit/057404e103d538b1d231024d34ac6ef2e05c412a))
* **github:** Add actions for pre-commit update & pr-title validation ([4f47470](https://github.com/LordFckHelmchen/git-commands/commit/4f47470e386ac6377bb72365df5adcda69066479))
* **git:** Update core, pull, and init configurations in .gitconfig ([983db89](https://github.com/LordFckHelmchen/git-commands/commit/983db89881df21b77c44fc380cdbdfe97cf1750a))
* **git:** Use gitconfig to store aliases & symlink it ([54087d3](https://github.com/LordFckHelmchen/git-commands/commit/54087d31404de41f1c858fed849e53d41923673c))
* Make git-prompt & starship CLI flags mutually exclusive ([8d90c94](https://github.com/LordFckHelmchen/git-commands/commit/8d90c94332c0ec7414c50578f21456ee5b0595f5))
* **nushell:** Add config ([1f7b3ab](https://github.com/LordFckHelmchen/git-commands/commit/1f7b3ab7648431653f70e1d9e675aa94c3cfafa3))
* **nushell:** Add nushell config & theming ([87ff730](https://github.com/LordFckHelmchen/git-commands/commit/87ff73019da8035ce17e67d20c4fe871e335ba96))
* **nushell:** Polish nushell configs & settings ([450c146](https://github.com/LordFckHelmchen/git-commands/commit/450c1468ab735bee0c6bd8e8ee8c827bcbd2e4c1))
* **prek:** Update hooks and revisions in pre-commit configuration files ([9f0ba06](https://github.com/LordFckHelmchen/git-commands/commit/9f0ba063e9e432fcf3d7eadc6968c33541e87364))
* **python:** Add example configs ([d3a5800](https://github.com/LordFckHelmchen/git-commands/commit/d3a58006ae03e134f210e43f1fdb781c31acbe09))
* **python:** Add license headers & refine ruff config ([db5020a](https://github.com/LordFckHelmchen/git-commands/commit/db5020a561f98dce931966ec54d43fae7d5e70bd))
* **python:** Add module import timing estimation script ([3340838](https://github.com/LordFckHelmchen/git-commands/commit/33408381a43ba2c3e3159954e83bbdcad9162461))
* **python:** Update pre-commit example & config ([c197a29](https://github.com/LordFckHelmchen/git-commands/commit/c197a2912ee4b664f0e9c2a6aab8b0f9bae136df))
* **starship:** Add git state ([db6ed5b](https://github.com/LordFckHelmchen/git-commands/commit/db6ed5b32a9bab72683d5cc3a1785d41326c0a07))
* **starship:** Add starship config ([db93017](https://github.com/LordFckHelmchen/git-commands/commit/db93017acf1f7620edf7cd4ed7233985688fd76b))
* **starship:** Attempt to speed-up git status on windows ([db6ed5b](https://github.com/LordFckHelmchen/git-commands/commit/db6ed5b32a9bab72683d5cc3a1785d41326c0a07))
* **starship:** Extend directory display & add git status ([db6ed5b](https://github.com/LordFckHelmchen/git-commands/commit/db6ed5b32a9bab72683d5cc3a1785d41326c0a07))
* **starship:** Improve readability of directory segment ([16acab1](https://github.com/LordFckHelmchen/git-commands/commit/16acab13dc8dca71ab4244413c989413b5319456))
* **starship:** Include venv name in Python prompt & disable pyenv discovery ([58c2f98](https://github.com/LordFckHelmchen/git-commands/commit/58c2f9859de30f44f9794c12abdf1ca297afb1a6))
* **starship:** Increase timeout to 10s ([fd7e459](https://github.com/LordFckHelmchen/git-commands/commit/fd7e459185c2f5b4d0ecacbf132de40eaba62040))
* **themes:** Add theme link-list ([33c0c0b](https://github.com/LordFckHelmchen/git-commands/commit/33c0c0ba3efa4b96703dcca5ead0aa0fff587f51))
* Use xonsh config path env var if present ([7683cce](https://github.com/LordFckHelmchen/git-commands/commit/7683cce631e6fdeeaf67597dc37729b2d111881b))
* **vscode:** Add vs code config ([3b4dd36](https://github.com/LordFckHelmchen/git-commands/commit/3b4dd36ad475ae473a6ce2080b250692070be52c))
* **vscode:** Add vs code profile ([11691e3](https://github.com/LordFckHelmchen/git-commands/commit/11691e313e9d7868bdebe1d85cf2c173fc69ad78))
* **windows-terminal:** Add xonsh profile to windows terminal ([b3d19f3](https://github.com/LordFckHelmchen/git-commands/commit/b3d19f333c38c70690f5a51e3875d11ae2125703))
* **windows-terminal:** Update config to latest state ([919c222](https://github.com/LordFckHelmchen/git-commands/commit/919c222d959c491610ef3d1f313a16039c8f668b))
* **windows-terminal:** Update profile & add settings ([539f1fb](https://github.com/LordFckHelmchen/git-commands/commit/539f1fb4c98dc2c30be96239883ef4e6a1ec054b))
* **windows-terminal:** Update settings.json & python icon ([ee14a38](https://github.com/LordFckHelmchen/git-commands/commit/ee14a38e00c4fbef84ad6803c324064515cd4148))
* **xonsh:** Add gitinfo xontrib with onefetch ([64b65eb](https://github.com/LordFckHelmchen/git-commands/commit/64b65eb3b86af3fb0f15df197dbc8e648d8a8e55))
* **xonsh:** Add xonsh config ([ce97b6c](https://github.com/LordFckHelmchen/git-commands/commit/ce97b6cc8d52ecfc8083ddcd0e77483b5ac34f7e))


### Bug Fixes

* **bash:** Add directory existence check during git repo update ([7ac9033](https://github.com/LordFckHelmchen/git-commands/commit/7ac90330f1b18b5e93d90515c285ebb7a3d15ea1))
* **bash:** Add error handling if completion commands fails ([13befe6](https://github.com/LordFckHelmchen/git-commands/commit/13befe62cf7a9e9bb26929f91c5130be0cd6df64))
* **bash:** Change to overwrite completion files instead of append ([19ff2c7](https://github.com/LordFckHelmchen/git-commands/commit/19ff2c72e7e744c02c103c8d80435f8d82414580))
* **bash:** Extend is_windows check to MSYS ([59eb930](https://github.com/LordFckHelmchen/git-commands/commit/59eb93052e47b45e5a815b51fe82c8183da82bb9))
* **bash:** Fix add_completion not having access to bash-completion folder variable ([55fa676](https://github.com/LordFckHelmchen/git-commands/commit/55fa6768b979a4bf4f6d83a4457154017ff410ff))
* **bash:** Make log_done respect the current script name ([8c34760](https://github.com/LordFckHelmchen/git-commands/commit/8c347600f1e3b7f73073fe6ce21936a04d61263a))
* **bash:** Missing newlines in update function ([c95f2bf](https://github.com/LordFckHelmchen/git-commands/commit/c95f2bfcd5cd2391344e08239d7b3a15605e44ff))
* **bash:** Unalias 'winget' to avoid output parsing issues ([85c78d5](https://github.com/LordFckHelmchen/git-commands/commit/85c78d5756cd3d5343db4f73ac151150fe07163c))
* **bash:** Undo accidental execution of gh ([b68cbb3](https://github.com/LordFckHelmchen/git-commands/commit/b68cbb308711cfd2f24d45803d1221c217c98289))
* **bash:** Use correct directory when updating pyenv repo on windows ([69dc114](https://github.com/LordFckHelmchen/git-commands/commit/69dc114bb4a9198f50db02acffab5bf089f91b63))
* Change git prompt color & reformat ([577b7ae](https://github.com/LordFckHelmchen/git-commands/commit/577b7aeafb6ad754a5a7a4c7b6d09b2e4584cad8))
* Correctly remove duplicates from history ([075ae4e](https://github.com/LordFckHelmchen/git-commands/commit/075ae4ea8f7a58843c93c54112266c1fac9a7fec))
* Don't add custom completion mechanism when bash-completion is available ([26296cf](https://github.com/LordFckHelmchen/git-commands/commit/26296cf7f6209682175559363040542bf0a78264))
* Error when sourcing file names with spaces ([f1336a8](https://github.com/LordFckHelmchen/git-commands/commit/f1336a885fe616ba273387097ecde9adfa0fac45))
* Fix current directory for dirtree alias ([f08bad0](https://github.com/LordFckHelmchen/git-commands/commit/f08bad0a08d4a0dbeb07726200b9476555d153f1))
* Fix error on missing parents of parents & reword windows err msg ([2cc26e0](https://github.com/LordFckHelmchen/git-commands/commit/2cc26e0384f3277d16ad0d63841a0af7c077c215))
* Fix error with unquoted strings ([3e6d0a1](https://github.com/LordFckHelmchen/git-commands/commit/3e6d0a1f4e5299960f813be8a5a33d5d61ac40b4))
* Fix wrong boolean check ([4ecee3a](https://github.com/LordFckHelmchen/git-commands/commit/4ecee3a02ccdc8b79bc8f097949d05f8c069683c))
* **git:** Update push alias to use --force-with-lease for safer pushes ([8e5db54](https://github.com/LordFckHelmchen/git-commands/commit/8e5db54da4f5cfee96e2dff0909617c9986c2629))
* Handle case if no bash completions are there ([e2e79a9](https://github.com/LordFckHelmchen/git-commands/commit/e2e79a9bf0f60e71abab94c36e14432aa1ecf7bb))
* **prek:** Allow 'starship' as conventional commit scope ([914c257](https://github.com/LordFckHelmchen/git-commands/commit/914c25754cf697e5d2560cbe307874d7bbee7d91))
* **python:** Disallow positional booleans in symlink script ([460c033](https://github.com/LordFckHelmchen/git-commands/commit/460c033d41327263d73a1b32c51abfa84f663657))
* Use completions from usr/share first ([1821688](https://github.com/LordFckHelmchen/git-commands/commit/1821688e4ea08e97363b46f4a6a2baafbba5d87a))
* **windows-terminal:** Fix incorrect icon path for ptpython ([de481d7](https://github.com/LordFckHelmchen/git-commands/commit/de481d763369ebeeea2662aa0ed810ca852aaedb))
* **windows-terminal:** Follow system theme & update tab setting ([c21121e](https://github.com/LordFckHelmchen/git-commands/commit/c21121e8e1129c986073a05b5c8a364c5ac23371))
* **xonsh:** Add newline to py-version info ([9aed5e3](https://github.com/LordFckHelmchen/git-commands/commit/9aed5e3f85e74f491f86c37614c059c79e087661))


### Code Refactoring

* **bash:** Remove all GH Copilot aliases ([2bb2041](https://github.com/LordFckHelmchen/git-commands/commit/2bb20417431df1100c0cf44a17e1bbde8bc63ba8))
* **bash:** Remove default log-level & refactor logging function ([3f60c56](https://github.com/LordFckHelmchen/git-commands/commit/3f60c56a44bad83e452e758a75c46162b76bb969))
* **bash:** Remove several functions & modularize code ([4b59439](https://github.com/LordFckHelmchen/git-commands/commit/4b59439f2a75ef7061d982fd97c7dd0451920ebb))
* **bash:** Rename gitup to gu ([3644920](https://github.com/LordFckHelmchen/git-commands/commit/36449209a08a36d36dad1f2974189da813a4b1a9))
* Make overwrite_existing_files mandatory & reformat ([0fb575c](https://github.com/LordFckHelmchen/git-commands/commit/0fb575cc152e3428d9c1f07c11ab1f58d80326dd))
* Move completion scripts ([3e993e7](https://github.com/LordFckHelmchen/git-commands/commit/3e993e79ed8682d6b4ff0120eabf8831a39e01f4))
* **nushell:** Drop nu support ([99abf11](https://github.com/LordFckHelmchen/git-commands/commit/99abf11561ffe8f2df50bf715ec311ae000b605a))
* Rename vscode & windows-terminal folders to match cc scopes ([5b5f23c](https://github.com/LordFckHelmchen/git-commands/commit/5b5f23c6a00dfd317dd320739499a918050c5e65))
* **xonsh:** Remove xonsh support ([3814111](https://github.com/LordFckHelmchen/git-commands/commit/381411112e32d2ecbf9ab1c0f64cadddaab35a10))
