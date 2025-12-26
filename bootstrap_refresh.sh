#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config"
DOTFILES="$HOME/dotfiles"
BACKUP="$DOTFILES/backup/$(date +%Y%m%d-%H%M)"

# Liste des dossiers de config à synchroniser
DIRS=(hypr waybar kitty rofi wallust swaync wlogout btop nvim zsh)

echo "🔁 Mise à jour des configurations depuis ~/.config vers ~/dotfiles..."

for dir in "${DIRS[@]}"; do
    config_dir="$CONFIG/$dir"
    dotfiles_dir="$DOTFILES/$dir"
    
    # Si c'est un vrai dossier (pas un symlink), il y a eu une mise à jour
    if [ -d "$config_dir" ] && [ ! -L "$config_dir" ]; then
        echo "→ Nouvelle config détectée pour $dir"
        
        # Sauvegarde de l'ancienne version dans dotfiles
        if [ -d "$dotfiles_dir" ]; then
            mkdir -p "$BACKUP"
            echo "  📦 Sauvegarde de l'ancienne version"
            cp -r "$dotfiles_dir" "$BACKUP/"
        fi
        
        # Copie la nouvelle config dans dotfiles
        echo "  📥 Copie de la nouvelle config"
        rm -rf "$dotfiles_dir"
        cp -r "$config_dir" "$dotfiles_dir"
        
        # Supprime le dossier réel et crée le symlink
        echo "  🔗 Création du symlink"
        rm -rf "$config_dir"
        ln -s "$dotfiles_dir" "$config_dir"
        
    elif [ -L "$config_dir" ]; then
        echo "✓ $dir est déjà un symlink, rien à faire"
    else
        echo "⚠️  $dir n'existe pas dans ~/.config, ignoré"
    fi
done

echo ""
echo "✅ Mise à jour terminée!"
echo "📁 Sauvegarde dans: $BACKUP"
echo "🔍 Vérifie les changements: cd ~/dotfiles && git status"
