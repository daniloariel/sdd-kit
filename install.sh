#!/usr/bin/env bash
# Instala las skills sdd-* en Claude Code.
#   ./install.sh                  → global: ~/.claude/skills (symlinks, se actualizan solas)
#   ./install.sh --copy           → global, copiando en vez de linkear
#   ./install.sh --project DIR    → DIR/.claude/skills (copia, para versionar con el repo)
#   ./install.sh --uninstall      → borra las sdd-* globales
set -euo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.claude/skills"
MODE=link

while [ $# -gt 0 ]; do
  case "$1" in
    --copy) MODE=copy ;;
    --project) DEST="$(cd "${2:?falta DIR}" && pwd)/.claude/skills"; MODE=copy; shift ;;
    --uninstall) MODE=uninstall ;;
    -h|--help) sed -n '2,6p' "$0"; exit 0 ;;
    *) echo "opción desconocida: $1" >&2; exit 1 ;;
  esac
  shift
done

mkdir -p "$DEST"
for dir in "$KIT"/skills/*/; do
  name="$(basename "$dir")"
  target="$DEST/$name"
  if [ "$MODE" = uninstall ]; then
    rm -rf "$target" && echo "– $name"
    continue
  fi
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "$target.bak.$(date +%s)"
    echo "  (backup de $name existente)"
  fi
  rm -f "$target"
  if [ "$MODE" = link ]; then ln -s "${dir%/}" "$target"; else cp -R "${dir%/}" "$target"; fi
  echo "✓ $name → $target"
done
