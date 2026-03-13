#!/bin/bash
# Sync Updated Configs Script
# Use this after external installers (like JaKooLit) overwrite your configs
# This script copies the new configs to your dotfiles and recreates symlinks
set -e
DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$DOTFILES_DIR/backup/$TIMESTAMP"
# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
echo -e "${BLUE}🔄 Syncing updated configs to dotfiles...${NC}\n"
# Create backup directory
mkdir -p "$BACKUP_DIR"
# Function to sync a config directory (~/.config/<name>)
sync_config() {
  local name="$1"
  local config_path="$CONFIG_DIR/$name"
  local dotfiles_path="$DOTFILES_DIR/$name"

  # Check if config exists and is NOT a symlink (meaning it was replaced)
  if [ -e "$config_path" ] && [ ! -L "$config_path" ]; then
    echo -e "${YELLOW}📦 Found updated $name config (not a symlink)${NC}"

    # Backup old dotfiles version
    if [ -e "$dotfiles_path" ]; then
      echo -e "${BLUE}  Backing up old dotfiles/$name${NC}"
      cp -r "$dotfiles_path" "$BACKUP_DIR/$name"
    fi

    # Copy new version to dotfiles
    echo -e "${GREEN}  Copying new $name to dotfiles${NC}"
    rm -rf "$dotfiles_path"
    cp -r "$config_path" "$dotfiles_path"

    # Remove the directory and create symlink
    echo -e "${GREEN}  Creating symlink${NC}"
    rm -rf "$config_path"
    ln -sf "$dotfiles_path" "$config_path"

    echo -e "${GREEN}  ✓ Synced $name${NC}\n"
    return 0
  elif [ -L "$config_path" ]; then
    echo -e "${GREEN}✓ $name is already a symlink (no sync needed)${NC}"
    return 1
  else
    echo -e "${BLUE}- $name doesn't exist${NC}"
    return 1
  fi
}

# Function to sync a home dotfile (~/<name>)
# $1: filename (e.g. ".zshrc")
# $2: subfolder in dotfiles (e.g. "zsh")
sync_home_dotfile() {
  local name="$1"
  local subdir="$2"
  local home_path="$HOME/$name"
  local dotfiles_path="$DOTFILES_DIR/$subdir/$name"

  if [ -e "$home_path" ] && [ ! -L "$home_path" ]; then
    echo -e "${YELLOW}📦 Found updated $name (not a symlink)${NC}"

    if [ -e "$dotfiles_path" ]; then
      echo -e "${BLUE}  Backing up old dotfiles/$subdir/$name${NC}"
      cp "$dotfiles_path" "$BACKUP_DIR/${subdir}_${name}"
    fi

    echo -e "${GREEN}  Copying new $name to dotfiles/$subdir/${NC}"
    cp "$home_path" "$dotfiles_path"

    echo -e "${GREEN}  Creating symlink${NC}"
    rm -f "$home_path"
    ln -sf "$dotfiles_path" "$home_path"

    echo -e "${GREEN}  ✓ Synced $name${NC}\n"
    return 0
  elif [ -L "$home_path" ]; then
    echo -e "${GREEN}✓ $name is already a symlink (no sync needed)${NC}"
    return 1
  else
    echo -e "${BLUE}- $name doesn't exist${NC}"
    return 1
  fi
}

# Check common configs that might be updated
SYNCED=0
echo -e "${BLUE}Checking for updated configs...${NC}\n"

# ~/.config/* configs
sync_config "hypr" && SYNCED=1
sync_config "waybar" && SYNCED=1
sync_config "rofi" && SYNCED=1
sync_config "kitty" && SYNCED=1
sync_config "wlogout" && SYNCED=1
sync_config "swaync" && SYNCED=1
sync_config "wallust" && SYNCED=1
sync_config "btop" && SYNCED=1
sync_config "fastfetch" && SYNCED=1
sync_config "cava" && SYNCED=1
sync_config "Kvantum" && SYNCED=1
sync_config "qt5ct" && SYNCED=1
sync_config "qt6ct" && SYNCED=1
sync_config "swappy" && SYNCED=1

# ~/* home dotfiles
sync_home_dotfile ".zshrc" "zsh" && SYNCED=1

if [ $SYNCED -eq 1 ]; then
  echo -e "\n${GREEN}✅ Sync complete!${NC}"
  echo -e "${BLUE}📁 Old configs backed up to: $BACKUP_DIR${NC}"
  echo -e "\n${YELLOW}Next steps:${NC}"
  echo -e "  cd ~/dotfiles"
  echo -e "  git status"
  echo -e "  git add ."
  echo -e "  git commit -m \"Update configs from JaKooLit\""
  echo -e "  git push"
else
  rmdir "$BACKUP_DIR" 2>/dev/null || true
  echo -e "\n${GREEN}✅ All configs are already symlinked. No sync needed!${NC}"
fi
