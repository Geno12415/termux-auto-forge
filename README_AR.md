# 🔨 termux-auto-forge

> **مُنشئ بيئة Termux التصريحي**
>
> أمر واحد لاستعادة إعدادات Termux كاملة — الخطوط، الألوان، الاختصارات، الأيقونات، وجميع الحزم الأساسية.

<p align="center">
  <img src="https://img.shields.io/badge/Termux-Android-green?logo=android&logoColor=white" alt="Termux">
  <img src="https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnu-bash&logoColor=white" alt="Bash">
  <img src="https://img.shields.io/badge/Python-3.11+-3776AB?logo=python&logoColor=white" alt="Python">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT">
</p>

---

## ✨ الميزات

- 🎨 **سمة داكنة 16 لون** — مستوحاة من GitHub Dark
- 🔤 **خط JetBrainsMono Nerd Font** — يُحمّل تلقائياً مع دعم الأيقونات
- 📁 **عرض الملفات الغني** — أيقونات، ألوان، أحجام، وتواريخ لكل ملف
- 🌳 **العرض الشجري** — شجرة تكرارية بنفس التنسيق الغني
- 🦇 **تلوين الصياغة** — `bat` يستبدل `cat`
- 🔒 **التحقق من السلامة** — بصمات SHA256 لجميع الملفات
- ⚡ **التفعيل الفوري** — شغّل بـ `source` لتفعيل الاختصارات فوراً
- 🛡️ **بدون تدخل** — لا أسئلة dpkg أثناء الاستعادة
- 🌍 **ثنائي اللغة** — الإنجليزية افتراضياً؛ العربية عبر `--lang ar`

---

## 📸 لقطات الشاشة

| قبل | بعد |
|-----|-----|
| Termux الافتراضي | termux-auto-forge |
| *(أضف لقطاتك هنا)* | *(أضف لقطاتك هنا)* |

---

## 📦 المحتويات

```text
termux-auto-forge/
├── .termux/
│   ├── colors.properties    ← سمة داكنة 16 لون
│   ├── font.ttf             ← خط Nerd Font (يُحمّل تلقائياً إن لم يكن موجوداً)
│   └── termux.properties    ← إعدادات الطرفية
├── .bashrc                  ← الاختصارات والأوامر المختصرة
├── list-view.py             ← عرض مسطح للملفات (أيقونات، أحجام، تواريخ)
├── tree-view.py             ← عرض شجري تكراري (أيقونات، أحجام، تواريخ)
├── packages.txt             ← قائمة الحزم الأساسية
├── restore.sh               ← سكربت الاستعادة بنقرة واحدة
├── backup.sh                ← إنشاء نسخة احتياطية من النظام الحالي
├── VERSION.txt              ← بيانات وصفية عن النسخة
├── CHECKSUMS.txt            ← التحقق من سلامة الملفات (SHA256)
├── LICENSE                  ← ترخيص MIT
├── CHANGELOG.md             ← تاريخ الإصدارات
├── .gitignore               ← قواعد تجاهل Git
├── README.md                ← الدليل بالإنجليزية
└── README_AR.md             ← الدليل بالعربية (هذا الملف)
```

---

## 🚀 البدء السريع

### المتطلبات
- جهاز Android
- [Termux](https://f-droid.org/packages/com.termux/) مثبت من F-Droid
- اتصال إنترنت (~1 جيجابايت للحزم)

### التثبيت

```bash
# ١) منح إذن الوصول للتخزين
termux-setup-storage
# اضغط "سماح" عند الطلب

# ٢) حمّل واستخرج المجلد (أو استنسخ من GitHub)
# ضع المجلد في: ~/storage/shared/termux-auto-forge/

# ٣) الاستعادة (تفعيل فوري — موصى به)
source ~/storage/shared/termux-auto-forge/restore.sh

# أو باللغة العربية:
# source ~/storage/shared/termux-auto-forge/restore.sh --lang ar
```

مع تسجيل كامل:
```bash
bash ~/storage/shared/termux-auto-forge/restore.sh 2>&1 | tee ~/storage/shared/termux-auto-forge/restore.log
```

---

## 🔄 الاستعادة اليدوية

```bash
# تحديث النظام
pkg update -y && pkg upgrade -y

# تثبيت الحزم
while IFS= read -r PKG; do
  [ -z "$PKG" ] && continue
  pkg install -y -o Dpkg::Options::="--force-confold" "$PKG"
done < ~/storage/shared/termux-auto-forge/packages.txt

# استعادة الإعدادات
cp -f ~/storage/shared/termux-auto-forge/.bashrc ~/
cp -f ~/storage/shared/termux-auto-forge/list-view.py ~/
cp -f ~/storage/shared/termux-auto-forge/tree-view.py ~/
mkdir -p ~/.termux
cp -rf ~/storage/shared/termux-auto-forge/.termux/* ~/.termux/

# إعادة التحميل
termux-reload-settings && hash -r
```

---

## 💾 إنشاء نسخة احتياطية

بعد تخصيص Termux، احفظ إعداداتك الحالية:

```bash
bash ~/storage/shared/termux-auto-forge/backup.sh
```

يولد هذا:
- ملفات إعدادات محدّثة في `~/storage/shared/termux-auto-forge/`
- أرشيف مضغوط `termux-auto-forge.tar.gz`

---

## ✅ التحقق من النجاح

```bash
ls    # قائمة مسطحة مع أيقونات، أحجام، تواريخ
ll    # نفس ls (تفصيلي افتراضياً)
la    # قائمة مسطحة تشمل الملفات المخفية
lt    # شجرة تكرارية مع أيقونات، أحجام، تواريخ
tv    # نفس lt
cat   # عرض ملف مُلوّن
```

---

## 📝 ملاحظات

- **لا تنسخ** مجلد `usr/` من تثبيت قديم.
- هذه النسخة تحفظ **الإعدادات فقط**؛ الحزم تُثبَّت تلقائياً.
- حجم تحميل الحزم: ~1 جيجابايت (أكبرها: `python`، `command-not-found`، `git`).
- الخط: يُضمن إن وُجد، وإلا يُحمّل تلقائياً.

---

## 📄 الترخيص

[MIT](LICENSE) © 2026 مساهمو termux-auto-forge

---

<p align="center">
  صُنع بـ ❤️ لمجتمع Termux
</p>
