#!/bin/bash

# Dotfiles Uninstallation Script
# Removes symlinks created by install.sh

set -e

CONFIG_DIR="$HOME/.config"

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${RED}Uninstalling dotfiles symlinks...${NC}\n"

# Function to remove symlink
unlink_file() {
    local path="$1"
    
    if [ -L "$path" ]; then
        rm "$path"
        echo -e "${GREEN}  ✓ Removed $path${NC}"
    elif [ -e "$path" ]; then
        echo -e "${YELLOW}  ! $path exists but is not a symlink (skipping)${NC}"
    else
        echo -e "  - $path does not exist (skipping)"
    fi
}

# Remove all symlinks
unlink_file "$HOME/.zshrc"
unlink_file "$HOME/.oh-my-zsh"
unlink_file "$HOME/.vimrc"
unlink_file "$HOME/.gitconfig"
unlink_file "$CONFIG_DIR/nvim"
unlink_file "$CONFIG_DIR/emacs"
unlink_file "$CONFIG_DIR/hypr"
unlink_file "$CONFIG_DIR/kitty"
unlink_file "$CONFIG_DIR/waybar"
unlink_file "$CONFIG_DIR/rofi"
unlink_file "$CONFIG_DIR/wlogout"
unlink_file "$CONFIG_DIR/swaync"
unlink_file "$CONFIG_DIR/wallust"
unlink_file "$CONFIG_DIR/btop"
unlink_file "$HOME/.ssh/config"
unlink_file "$CONFIG_DIR/fastfetch"
unlink_file "$CONFIG_DIR/cava"
unlink_file "$CONFIG_DIR/Kvantum"
unlink_file "$CONFIG_DIR/qt5ct"
unlink_file "$CONFIG_DIR/qt6ct"
unlink_file "$CONFIG_DIR/swappy"
echo -e "\n${GREEN}✓ Dotfiles uninstallation complete!${NC}"
echo -e "${YELLOW}Note: Backup files (.backup_*) were not removed.${NC}"
