# 🔨 termux-auto-forge

> **Declarative Termux Environment Bootstrapper**
>
> One command to restore your complete Termux setup — fonts, colors, aliases, icons, and all essential packages.

<p align="center">
  <img src="https://img.shields.io/badge/Termux-Android-green?logo=android&logoColor=white" alt="Termux">
  <img src="https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash&logoColor=white" alt="Bash">
  <img src="https://img.shields.io/badge/Python-3.11+-3776AB?logo=python&logoColor=white" alt="Python">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT">
</p>

---

## ✨ Features

- 🎨 **16-Color Dark Theme** — Inspired by GitHub Dark
- 🔤 **JetBrainsMono Nerd Font** — Auto-downloaded with icons support
- 📁 **Rich File Listing** — Icons, colors, sizes, and dates for every file
- 🌳 **Tree View** — Recursive tree with the same rich formatting
- 🦇 **Syntax Highlighting** — `bat` replaces `cat`
- 🔒 **Integrity Verification** — SHA256 checksums for all files
- ⚡ **Instant Activation** — Run with `source` to activate aliases immediately
- 🛡️ **Non-Interactive** — No dpkg prompts during restore
- 🌍 **Bilingual** — English default; Arabic via `--lang ar`

---

## 📸 Screenshots

| Before | After |
|--------|-------|
| Default Termux | termux-auto-forge |
| *(Add your before/after screenshots here)* | *(Add your before/after screenshots here)* |

---

## 📦 Contents

```text
termux-auto-forge/
├── .termux/
│   ├── colors.properties    ← 16-color dark theme
│   ├── font.ttf             ← Nerd Font (auto-downloaded if missing)
│   └── termux.properties    ← Terminal settings
├── .bashrc                  ← Aliases & shortcuts
├── list-view.py             ← Flat file listing (icons, sizes, dates)
├── tree-view.py             ← Recursive tree view (icons, sizes, dates)
├── packages.txt             ← Essential packages list
├── restore.sh               ← One-click restore script
├── backup.sh                ← Create backup from current system
├── VERSION.txt              ← Backup metadata
├── CHECKSUMS.txt            ← File integrity verification
├── LICENSE                  ← MIT License
├── CHANGELOG.md             ← Version history
├── .gitignore               ← Git ignore rules
├── README.md                ← English guide (this file)
└── README_AR.md             ← Arabic guide
```

---

## 🚀 Quick Start

### Prerequisites
- Android device
- [Termux](https://f-droid.org/packages/com.termux/) installed from F-Droid
- Internet connection (~1 GB for packages)

### Installation

```bash
# 1. Grant storage permission
termux-setup-storage
# Tap "Allow" when prompted

# 2. Download and extract (or clone from GitHub)
# Place the folder in ~/storage/shared/termux-auto-forge/

# 3. Restore (instant activation — recommended)
source ~/storage/shared/termux-auto-forge/restore.sh

# Or with Arabic output:
# source ~/storage/shared/termux-auto-forge/restore.sh --lang ar
```

With logging:
```bash
bash ~/storage/shared/termux-auto-forge/restore.sh 2>&1 | tee ~/storage/shared/termux-auto-forge/restore.log
```

---

## 🔄 Manual Restore

```bash
# Update system
pkg update -y && pkg upgrade -y

# Install packages
while IFS= read -r PKG; do
  [ -z "$PKG" ] && continue
  pkg install -y -o Dpkg::Options::="--force-confold" "$PKG"
done < ~/storage/shared/termux-auto-forge/packages.txt

# Restore configs
cp -f ~/storage/shared/termux-auto-forge/.bashrc ~/
cp -f ~/storage/shared/termux-auto-forge/list-view.py ~/
cp -f ~/storage/shared/termux-auto-forge/tree-view.py ~/
mkdir -p ~/.termux
cp -rf ~/storage/shared/termux-auto-forge/.termux/* ~/.termux/

# Reload
termux-reload-settings && hash -r
```

---

## 💾 Create a Backup

After customizing Termux, save your current setup:

```bash
bash ~/storage/shared/termux-auto-forge/backup.sh
```

This generates:
- Updated config files in `~/storage/shared/termux-auto-forge/`
- Compressed archive `termux-auto-forge.tar.gz`

---

## ✅ Verify Success

```bash
ls    # flat list with icons, sizes, dates
ll    # same as ls (detailed by default)
la    # flat list including hidden files
lt    # recursive tree with icons, sizes, dates
tv    # same as lt
cat   # syntax-highlighted file view
```

---

## 📝 Notes

- **Never** copy `usr/` from an old installation.
- This stores **configurations only**; packages install automatically.
- Package download: ~1 GB (mainly `python`, `command-not-found`, `git`).
- Font: Included if present; otherwise auto-downloaded.

---

## 📄 License

[MIT](LICENSE) © 2026 termux-auto-forge contributors

---

<p align="center">
  Made with ❤️ for the Termux community
</p>
