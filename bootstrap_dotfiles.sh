#!/bin/bash

set -e

echo "📁 Copie et lien des dotfiles..."

TIMESTAMP=$(date +%Y%m%d-%H%M)
DOTFILES="$HOME/dotfiles"

# Dossiers à gérer : source => destination relative depuis $HOME
declare -A CONFIGS=(
  ["nvim"]=".config/nvim"
  ["hypr"]=".config/hypr"
  ["kitty"]=".config/kitty"
  ["waybar"]=".config/waybar"
  ["rofi"]=".config/rofi"
  ["btop"]=".config/btop"
  ["wallust"]=".config/wallust"
  ["wlogout"]=".config/wlogout"
  ["zsh"]=".config/zsh"
  ["zshrc"]=".zshrc"
)

for name in "${!CONFIGS[@]}"; do
  src_path="$HOME/${CONFIGS[$name]}"
  dst_path="$DOTFILES/$name"
  link_target="$HOME/${CONFIGS[$name]}"

  # Si le fichier existe et n'est pas un lien
  if [ -e "$src_path" ] && [ ! -L "$src_path" ]; then
    echo "📦 Copie de $src_path → $dst_path"
    cp -r "$src_path" "$dst_path"

    echo "🗃️ Sauvegarde de $src_path → $src_path.backup-$TIMESTAMP"
    mv "$src_path" "$src_path.backup-$TIMESTAMP"
  fi

  # Crée le lien
  echo "🔗 Création du lien : $link_target → $dst_path"
  ln -sf "$dst_path" "$link_target"
done

echo "✅ Tous les dotfiles ont été copiés et liés."

