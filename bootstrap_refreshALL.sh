#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"
BACKUP="$DOTFILES/backup/$(date +%Y%m%d)"

echo "🔁 Sauvegarde de tous les dotfiles actuels..."

# Trouve tous les dossiers dans ~/dotfiles (sauf backup, .git, etc.)
cd "$DOTFILES"
for dir in */; do
    dir="${dir%/}"  # Remove trailing slash
    
    # Skip special directories
    [[ "$dir" == "backup" ]] && continue
    [[ "$dir" == ".git" ]] && continue
    
    if [ -d "$dir" ]; then
        echo "→ Sauvegarde de $dir"
        mkdir -p "$BACKUP/$dir"
        cp -r "$dir/"* "$BACKUP/$dir/" 2>/dev/null || true
    fi
done

echo "✅ Sauvegarde terminée dans $BACKUP"
echo "💡 Les changements sont déjà dans ~/dotfiles (via symlinks)"
echo "   Utilise 'git status' pour voir les modifications"
