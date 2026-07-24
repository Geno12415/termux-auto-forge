# termux-auto-forge .bashrc
# Modern shell aliases for Termux

# ─── Flat File Listing (icons, colors, sizes, dates) ──────────
alias ls='python ~/list-view.py'
alias ll='python ~/list-view.py'
alias la='python ~/list-view.py --all'

# ─── Tree File Listing (recursive with branches) ──────────────
alias lt='python ~/tree-view.py'
alias ltr='python ~/tree-view.py'
alias tv='python ~/tree-view.py'

# ─── Syntax-Highlighted File Viewer ───────────────────────────
alias cat='bat --paging=never --style=numbers,changes,header'
