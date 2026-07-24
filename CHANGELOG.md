# Changelog

All notable changes to this project will be documented in this file.

## [3.0.0] - 2026-07-24

### Added
- `list-view.py` — flat file listing with icons, colors, sizes, and dates
- Bilingual support (`--lang ar|en`) in `restore.sh` and `backup.sh`
- Smart `source` detection in `restore.sh` — aliases activate instantly when run with `source`
- Automatic JetBrainsMono Nerd Font download if not present in backup
- Full `termux.properties` with documented settings
- 16-color dark theme (`colors.properties`)
- `tree-view.py` with Nerd Font icons, file sizes, and modification dates
- `CHECKSUMS.txt` for file integrity verification
- `backup.sh` for creating backups (renamed from `update-backup.sh`)
- `LICENSE` (MIT)
- `CHANGELOG.md`

### Changed
- `ls`, `ll`, `la` now use `list-view.py` by default (rich flat listing)
- `lt`, `ltr`, `tv` use `tree-view.py` (recursive tree)
- All user-facing text defaults to English; Arabic available via `--lang ar`
- Project renamed to `termux-auto-forge`
- Restructured for GitHub publication

### Fixed
- `pkg upgrade -y` no longer triggers interactive dpkg prompts
- `.bashrc` loading issues resolved
- `font.ttf` empty file bug fixed

## [2.0.0] - 2026-07-24

### Added
- `apt-get install` instead of `pkg install`
- `set -u` for safer scripting
- `CHECKSUMS.txt` generation

## [1.0.0] - 2026-07-24

### Added
- Initial backup and restore scripts
- Basic `.bashrc` aliases
- Simple `tree-view.py`
- `packages.txt` manifest
