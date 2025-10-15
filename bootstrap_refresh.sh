#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config"
DOTFILES="$HOME/dotfiles"

# Liste des dossiers de config à synchroniser
DIRS=(hypr waybar kitty rofi wallust swaync wlogout btop)

echo "🔁 Synchronisation des nouveaux fichiers vers ~/dotfiles ..."
for dir in "${DIRS[@]}"; do
    if [ -d "$CONFIG/$dir" ]; then
        echo "→ $dir"
        # Sauvegarde dans un dossier daté
        mkdir -p "$DOTFILES/backup/$(date +%Y%m%d)/$dir"
        cp -r "$DOTFILES/$dir/"* "$DOTFILES/backup/$(date +%Y%m%d)/$dir/" 2>/dev/null || true
        
        # Mise à jour de dotfiles
        rsync -av --delete "$CONFIG/$dir/" "$DOTFILES/$dir/"
        
        # Suppression de l'ancien dossier local et recréation du lien
        rm -rf "$CONFIG/$dir"
        ln -s "$DOTFILES/$dir" "$CONFIG/$dir"
    else
        echo "⚠️  $dir n'existe pas dans ~/.config, ignoré."
    fi
done

echo "✅ Synchronisation terminée."
echo "Vérifie avec : ls -l ~/.config | grep '->'"

