#!/data/data/com.termux/files/usr/bin/bash
# termux-auto-forge backup.sh
# Create a backup of current Termux environment
# Usage: bash backup.sh [--lang ar|en]

set -u

# ─── Language Selection ───────────────────────────────────────
LANG="en"
while [[ $# -gt 0 ]]; do
    case $1 in
        --lang)
            LANG="$2"
            shift 2
            ;;
        *)
            shift
            ;;
    esac
done

# ─── Message Helper ───────────────────────────────────────────
msg() {
    if [ "$LANG" = "ar" ]; then
        echo "$2"
    else
        echo "$1"
    fi
}

BACKUP="$HOME/storage/shared/termux-auto-forge"
ARCHIVE="$HOME/storage/shared/termux-auto-forge.tar.gz"

# ─── Package List ─────────────────────────────────────────────
PACKAGES=(
    bash
    bat
    command-not-found
    coreutils
    curl
    eza
    git
    less
    nano
    net-tools
    openssh
    python
    tar
    termux-am
    termux-tools
    unzip
    xz-utils
)

mkdir -p "$BACKUP"
mkdir -p "$HOME/storage/shared"

# ─── Sync Configuration Files ─────────────────────────────────
msg "== Syncing configuration files ==" "== مزامنة ملفات التخصيص =="

cp -f "$HOME/.bashrc" "$BACKUP/.bashrc"
cp -f "$HOME/list-view.py" "$BACKUP/list-view.py"
cp -f "$HOME/tree-view.py" "$BACKUP/tree-view.py"

mkdir -p "$BACKUP/.termux"
cp -rf "$HOME/.termux/"* "$BACKUP/.termux/" 2>/dev/null || true

# ─── Generate packages.txt ────────────────────────────────────
msg "== Generating packages.txt ==" "== توليد packages.txt =="
{
    for pkg in "${PACKAGES[@]}"; do
        printf '%s\n' "$pkg"
    done
} > "$BACKUP/packages.txt"

# ─── Generate VERSION.txt ─────────────────────────────────────
msg "== Generating VERSION.txt ==" "== توليد VERSION.txt =="
NOW="$(date '+%Y.%m.%d-%H%M')"
{
    echo "========================================"
    echo "           termux-auto-forge"
    echo "========================================"
    echo
    echo "Backup Version : $NOW"
    echo "Backup Type    : Configuration Only"
    echo
    echo "Description:"
    echo "Backup of a customized Termux environment."
    echo
    echo "Includes:"
    echo "- .bashrc"
    echo "- .termux"
    echo "- list-view.py"
    echo "- tree-view.py"
    echo "- packages.txt"
    echo "- restore.sh"
    echo "- backup.sh"
    echo "- VERSION.txt"
    echo "- CHECKSUMS.txt"
    echo "- README.md"
    echo
    echo "Restores:"
    echo "✓ Font (JetBrainsMono Nerd Font)"
    echo "✓ Colors (16-color dark theme)"
    echo "✓ Aliases"
    echo "✓ eza icons"
    echo "✓ Tree view with sizes & dates"
    echo "✓ Wrapped output"
    echo "✓ Essential packages"
    echo
    echo "Notes:"
    echo "- Install Termux first."
    echo "- Run: termux-setup-storage"
    echo "- Then execute:"
    echo "  source ~/storage/shared/termux-auto-forge/restore.sh"
    echo
    echo "Optional log:"
    echo "  bash ~/storage/shared/termux-auto-forge/restore.sh 2>&1 | tee ~/storage/shared/termux-auto-forge/restore.log"
    echo
    echo "========================================"
} > "$BACKUP/VERSION.txt"

# ─── Generate CHECKSUMS.txt ───────────────────────────────────
msg "== Generating CHECKSUMS.txt ==" "== توليد CHECKSUMS.txt =="
(
    cd "$BACKUP" || exit 1
    sha256sum \
        README.md \
        restore.sh \
        backup.sh \
        VERSION.txt \
        packages.txt \
        list-view.py \
        tree-view.py \
        .bashrc \
        .termux/colors.properties \
        .termux/font.ttf \
        .termux/termux.properties \
        > CHECKSUMS.txt
)

# ─── Create Archive ───────────────────────────────────────────
msg "== Creating compressed archive ==" "== إنشاء الأرشيف المضغوط =="
tar -czf "$ARCHIVE" -C "$HOME/storage/shared" termux-auto-forge

echo
msg "✅ Backup updated successfully." "✅ اكتمل تحديث النسخة الاحتياطية."
echo "📦 Folder: $BACKUP"
echo "🗜️  Archive: $ARCHIVE"
