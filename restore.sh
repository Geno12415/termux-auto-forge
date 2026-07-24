#!/data/data/com.termux/files/usr/bin/bash
# termux-auto-forge restore.sh
# Restore Termux environment from backup
# Usage:
#   source restore.sh [--lang ar|en]    (instant activation)
#   bash restore.sh [--lang ar|en]      (restart required for aliases)

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
FAILED_PACKAGES=""
INSTALLED_COUNT=0

# ─── Banner ───────────────────────────────────────────────────
msg "========================================\n      termux-auto-forge  v3.0\n========================================" "========================================\n      termux-auto-forge  الإصدار ٣.٠\n========================================"
echo

# ─── Version Info ─────────────────────────────────────────────
if [ -f "$BACKUP/VERSION.txt" ]; then
    cat "$BACKUP/VERSION.txt"
    echo
fi

# ─── Check Storage Permission ─────────────────────────────────
if [ ! -d "$HOME/storage/shared" ]; then
    msg "❌ Storage permission not granted.\n   Run first: termux-setup-storage\n   Then tap 'Allow' and run this script again." "❌ لم يتم منح إذن التخزين.\n   نفّذ أولاً: termux-setup-storage\n   ثم اضغط 'سماح' وشغّل السكربت مرة أخرى."
    exit 1
fi

# ─── Validate Backup Files ────────────────────────────────────
msg "== Checking backup files ==" "== التحقق من ملفات النسخة الاحتياطية =="

REQUIRED_FILES=(
    ".bashrc"
    "packages.txt"
    "list-view.py"
    "tree-view.py"
    "README.md"
    "VERSION.txt"
    "CHECKSUMS.txt"
)

for FILE in "${REQUIRED_FILES[@]}"; do
    if [ ! -e "$BACKUP/$FILE" ]; then
        msg "❌ Missing file: $FILE" "❌ الملف مفقود: $FILE"
        exit 1
    fi
done

if [ ! -d "$BACKUP/.termux" ]; then
    msg "❌ .termux directory not found." "❌ المجلد .termux غير موجود."
    exit 1
fi

msg "✅ Backup files are valid." "✅ النسخة الاحتياطية سليمة."
echo

# ─── Verify Checksums ─────────────────────────────────────────
msg "== Verifying file integrity (checksums) ==" "== التحقق من سلامة الملفات (checksums) =="
if ( cd "$BACKUP" && sha256sum -c CHECKSUMS.txt ); then
    msg "✅ Integrity check passed." "✅ التحقق من السلامة ناجح."
else
    msg "❌ Integrity check failed." "❌ فشل التحقق من سلامة الملفات."
    exit 1
fi
echo

# ─── Update Repositories ──────────────────────────────────────
msg "== Updating repositories ==" "== تحديث المستودعات =="
export DEBIAN_FRONTEND=noninteractive
pkg update -y || true
echo

# ─── Upgrade System ───────────────────────────────────────────
msg "== Upgrading system ==" "== ترقية النظام =="
apt-get upgrade -y -o Dpkg::Options::="--force-confold" || true
echo

# ─── Install Packages ─────────────────────────────────────────
msg "== Installing packages ==" "== تثبيت الحزم =="

while IFS= read -r PKG; do
    PKG="${PKG%%#*}"
    PKG="$(printf '%s' "$PKG" | xargs)"

    [ -z "$PKG" ] && continue

    echo "➜ $PKG"

    if apt-get install -y -o Dpkg::Options::="--force-confold" "$PKG"; then
        INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
    else
        msg "⚠ Failed to install: $PKG" "⚠ فشل تثبيت: $PKG"
        FAILED_PACKAGES="$FAILED_PACKAGES $PKG"
    fi
done < "$BACKUP/packages.txt"

# ─── Download Nerd Font ───────────────────────────────────────
echo
msg "== Downloading Nerd Font ==" "== تحميل Nerd Font =="
FONT_URL="https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/JetBrainsMonoNerdFontMono-Regular.ttf"

if [ -s "$BACKUP/.termux/font.ttf" ]; then
    msg "✅ Using font from backup." "✅ استخدام الخط من النسخة الاحتياطية."
    cp -f "$BACKUP/.termux/font.ttf" "$HOME/.termux/font.ttf"
elif [ ! -s "$HOME/.termux/font.ttf" ]; then
    msg "⬇️  Downloading JetBrainsMono Nerd Font..." "⬇️  جاري تحميل JetBrainsMono Nerd Font..."
    if curl -fsSL -o "$HOME/.termux/font.ttf" "$FONT_URL" 2>/dev/null; then
        msg "✅ Font downloaded successfully." "✅ تم تحميل الخط بنجاح."
    else
        msg "⚠️  Could not download font — icons may not display correctly." "⚠️  تعذر تحميل الخط — الأيقونات قد لا تظهر بشكل صحيح."
        msg "   You can manually download it later to ~/.termux/font.ttf" "   يمكنك تحميله يدوياً لاحقاً ووضعه في ~/.termux/font.ttf"
    fi
else
    msg "✅ Font already exists." "✅ الخط موجود مسبقاً."
fi

# ─── Restore Configuration Files ──────────────────────────────
echo
msg "== Restoring configuration files ==" "== استعادة الملفات =="

cp -f "$BACKUP/.bashrc" "$HOME/.bashrc"
cp -f "$BACKUP/list-view.py" "$HOME/list-view.py"
cp -f "$BACKUP/tree-view.py" "$HOME/tree-view.py"

mkdir -p "$HOME/.termux"
cp -rf "$BACKUP/.termux/"* "$HOME/.termux/" 2>/dev/null || true

# ─── Reload Termux Settings ───────────────────────────────────
echo
msg "== Reloading Termux settings ==" "== إعادة تحميل إعدادات Termux =="

termux-reload-settings || true
hash -r || true

# ─── Activate Aliases ─────────────────────────────────────────
echo
msg "== Activating new settings ==" "== تفعيل الإعدادات الجديدة =="

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    source "$HOME/.bashrc" 2>/dev/null || true
    msg "✅ Aliases activated automatically in this session." "✅ تم تفعيل الاختصارات تلقائياً في هذه الجلسة."
else
    msg "🔄 To activate aliases now without closing, run:" "🔄 لتفعيل الاختصارات الآن بدون إغلاق، نفّذ:"
    echo "   source ~/.bashrc"
    echo ""
    msg "   Or close Termux and reopen it." "   أو أغلق Termux وافتحه من جديد."
fi

# ─── Summary ──────────────────────────────────────────────────
echo
echo "======================================"
msg "Installed $INSTALLED_COUNT packages." "تم تثبيت $INSTALLED_COUNT حزمة."
echo

if [ -n "$FAILED_PACKAGES" ]; then
    msg "Failed packages:" "الحزم التي تعذر تثبيتها:"
    for PKG in $FAILED_PACKAGES; do
        echo " - $PKG"
    done
    echo
fi

msg "✅ Restore completed." "✅ اكتملت عملية الاستعادة."
echo "======================================"
