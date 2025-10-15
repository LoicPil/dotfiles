#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config"
DOTFILES="$HOME/dotfiles"
BACKUP="$DOTFILES/backup/$(date +%Y%m%d)"

mkdir -p "$BACKUP"

# Détecte tous les dossiers réels dans ~/.config
DIRS=($(find "$CONFIG" -mindepth 1 -maxdepth 1 -type d ! -lname '*'))

echo "🔁 Synchronisation des nouveaux fichiers vers ~/dotfiles ..."
for dirpath in "${DIRS[@]}"; do
    dir=$(basename "$dirpath")
    echo "→ $dir"
    
    # Sauvegarde existante dans dotfiles
    if [ -d "$DOTFILES/$dir" ]; then
        mkdir -p "$BACKUP/$dir"
        cp -r "$DOTFILES/$dir/"* "$BACKUP/$dir/" 2>/dev/null || true
    fi
    
    # Mise à jour de dotfiles avec le nouveau contenu
    mkdir -p "$DOTFILES/$dir"
    rsync -av --delete "$CONFIG/$dir/" "$DOTFILES/$dir/"
    
    # Supprime l'ancien dossier local et recrée le lien
    rm -rf "$CONFIG/$dir"
    ln -s "$DOTFILES/$dir" "$CONFIG/$dir"
done

echo "✅ Synchronisation terminée."
echo "Vérifie les liens : ls -l ~/.config | grep '->'"

