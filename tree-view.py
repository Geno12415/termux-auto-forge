#!/usr/bin/env python3
# termux-auto-forge tree-view.py
# Recursive tree view with Nerd Font icons, file sizes, and modification dates
# Usage: tree-view.py [path]

import os
import sys
from datetime import datetime

RESET   = "\033[0m"
BLUE    = "\033[34m"
YELLOW  = "\033[33m"
RED     = "\033[31m"
CYAN    = "\033[36m"
MAGENTA = "\033[35m"
GREEN   = "\033[32m"
WHITE   = "\033[37m"
GRAY    = "\033[90m"
BOLD    = "\033[1m"

ICONS = {
    "folder": "\ue5ff",
    ".py":    "\ue606",
    ".js":    "\ue60c",
    ".ts":    "\ue628",
    ".json":  "\ue60b",
    ".html":  "\uf0bb",
    ".css":   "\ue749",
    ".md":    "\uf4aa",
    ".txt":   "\uf15c",
    ".sh":    "\ue795",
    ".zip":   "\uf41c",
    ".tar":   "\uf41c",
    ".gz":    "\uf41c",
    ".xz":    "\uf41c",
    ".7z":    "\uf41c",
    ".rar":   "\uf41c",
    ".ttf":   "\uf031",
    ".otf":   "\uf031",
    ".woff":  "\uf031",
    ".woff2": "\uf031",
}

def icon_for(name, is_dir):
    if is_dir:
        return ICONS["folder"]
    ext = os.path.splitext(name)[1].lower()
    return ICONS.get(ext, "\uf15b")

def color_for(name, is_dir):
    if is_dir:
        return BLUE
    ext = os.path.splitext(name)[1].lower()
    if ext in [".py", ".sh"]:
        return YELLOW
    if ext in [".zip", ".tar", ".gz", ".xz", ".7z", ".rar"]:
        return RED
    if ext in [".js", ".ts"]:
        return CYAN
    if ext in [".json", ".html", ".css"]:
        return MAGENTA
    if ext in [".ttf", ".otf", ".woff", ".woff2"]:
        return GREEN
    if ext in [".md", ".txt"]:
        return WHITE
    return WHITE

def human_size(size):
    if size == 0:
        return "0 B"
    units = ["B", "KB", "MB", "GB", "TB"]
    i = 0
    value = float(size)
    while value >= 1024 and i < len(units) - 1:
        value /= 1024
        i += 1
    if i == 0:
        return f"{int(value)} B"
    return f"{value:.1f} {units[i]}"

def file_info(entry):
    try:
        stat = entry.stat()
        size = "-" if entry.is_dir() else human_size(stat.st_size)
        date = datetime.fromtimestamp(stat.st_mtime).strftime("%d %b %H:%M")
        return size, date
    except Exception:
        return "-", "-"

def get_entries(path):
    try:
        entries = list(os.scandir(path))
    except PermissionError:
        return []
    entries.sort(key=lambda e: (not e.is_dir(), e.name.lower()))
    return entries

def print_tree(path, prefix=""):
    entries = get_entries(path)
    for index, entry in enumerate(entries):
        last = index == len(entries) - 1
        branch = "└── " if last else "├── "
        child_prefix = prefix + ("    " if last else "│   ")
        name = entry.name
        icon = icon_for(name, entry.is_dir())
        color = color_for(name, entry.is_dir())
        size, date = file_info(entry)
        colored_name = f"{color}{icon} {name}{RESET}"
        details = f"{GRAY}  {size:<9} {date}{RESET}"
        print(f"{GRAY}{prefix}{branch}{RESET}{colored_name}{details}")
        if entry.is_dir():
            print_tree(entry.path, child_prefix)

def main():
    root = sys.argv[1] if len(sys.argv) > 1 else "."
    root = os.path.abspath(root)
    name = os.path.basename(root)
    print(f"{BLUE}\ue5ff {name}{RESET}")
    print_tree(root)

if __name__ == "__main__":
    main()
