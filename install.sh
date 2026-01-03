#!/bin/bash

# Dotfiles Installation Script
# Creates symlinks from dotfiles to their proper locations

set -e  # Exit on error

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$DOTFILES_DIR/backup/$BACKUP_DATE"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 Installation des dotfiles depuis $DOTFILES_DIR${NC}\n"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to create symlink with backup
link_file() {
    local src="$1"
    local dest="$2"
    
    # Check if source exists
    if [ ! -e "$src" ]; then
        echo -e "${RED}  ⚠️  Source n'existe pas: $src (ignoré)${NC}"
        return
    fi
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"
    
    # Backup existing file/directory
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo -e "${YELLOW}  📦 Backup de $(basename "$dest")${NC}"
        mv "$dest" "$BACKUP_DIR/$(basename "$dest")"
    elif [ -L "$dest" ]; then
        rm "$dest"
    fi
    
    # Create symlink
    ln -sf "$src" "$dest"
    echo -e "${GREEN}  ✓ Lié: $dest${NC}"
}

# ZSH
echo -e "${BLUE}Configuration ZSH...${NC}"
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/oh-my-zsh" "$HOME/.oh-my-zsh"

# Neovim
echo -e "\n${BLUE}Configuration Neovim...${NC}"
# Remove circular symlink if it exists
[ -L "$DOTFILES_DIR/nvim/nvim" ] && rm "$DOTFILES_DIR/nvim/nvim"
link_file "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"

# Vim
echo -e "\n${BLUE}Configuration Vim...${NC}"
link_file "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"

# Emacs
echo -e "\n${BLUE}Configuration Emacs...${NC}"
link_file "$DOTFILES_DIR/emacs" "$CONFIG_DIR/emacs"

# Hyprland
echo -e "\n${BLUE}Configuration Hyprland...${NC}"
link_file "$DOTFILES_DIR/hypr" "$CONFIG_DIR/hypr"

# Kitty
echo -e "\n${BLUE}Configuration Kitty...${NC}"
link_file "$DOTFILES_DIR/kitty" "$CONFIG_DIR/kitty"

# Waybar
echo -e "\n${BLUE}Configuration Waybar...${NC}"
link_file "$DOTFILES_DIR/waybar" "$CONFIG_DIR/waybar"

# Rofi
echo -e "\n${BLUE}Configuration Rofi...${NC}"
link_file "$DOTFILES_DIR/rofi" "$CONFIG_DIR/rofi"

# Wlogout
echo -e "\n${BLUE}Configuration Wlogout...${NC}"
link_file "$DOTFILES_DIR/wlogout" "$CONFIG_DIR/wlogout"

# SwayNC
echo -e "\n${BLUE}Configuration SwayNC...${NC}"
link_file "$DOTFILES_DIR/swaync" "$CONFIG_DIR/swaync"

# Wallust
echo -e "\n${BLUE}Configuration Wallust...${NC}"
link_file "$DOTFILES_DIR/wallust" "$CONFIG_DIR/wallust"

# Btop
echo -e "\n${BLUE}Configuration Btop...${NC}"
link_file "$DOTFILES_DIR/btop" "$CONFIG_DIR/btop"

# Git
echo -e "\n${BLUE}Configuration Git...${NC}"
link_file "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
# Fastfetch
echo -e "\n${BLUE}Configuration Fastfetch...${NC}"
link_file "$DOTFILES_DIR/fastfetch" "$CONFIG_DIR/fastfetch"

# Cava
echo -e "\n${BLUE}Configuration Cava...${NC}"
link_file "$DOTFILES_DIR/cava" "$CONFIG_DIR/cava"

# Kvantum
echo -e "\n${BLUE}Configuration Kvantum...${NC}"
link_file "$DOTFILES_DIR/Kvantum" "$CONFIG_DIR/Kvantum"

# Qt5ct
echo -e "\n${BLUE}Configuration Qt5ct...${NC}"
link_file "$DOTFILES_DIR/qt5ct" "$CONFIG_DIR/qt5ct"

# Qt6ct
echo -e "\n${BLUE}Configuration Qt6ct...${NC}"
link_file "$DOTFILES_DIR/qt6ct" "$CONFIG_DIR/qt6ct"

# Swappy
echo -e "\n${BLUE}Configuration Swappy...${NC}"
link_file "$DOTFILES_DIR/swappy" "$CONFIG_DIR/swappy"
# SSH (config only, not keys!)
echo -e "\n${BLUE}Configuration SSH...${NC}"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ -f "$DOTFILES_DIR/ssh/config" ]; then
    link_file "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
fi

# Initialize submodules (oh-my-zsh)
if [ -f "$DOTFILES_DIR/.gitmodules" ]; then
    echo -e "\n${BLUE}📚 Initializing Git submodules (oh-my-zsh)...${NC}"
    cd "$DOTFILES_DIR"
    git submodule update --init --recursive
    echo -e "${GREEN}  ✓ Submodules initialized${NC}"
fi

echo -e "\n${GREEN}✅ Installation complete!${NC}"

# Show backup info
if [ "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
    echo -e "${BLUE}📁 Backups saved in: $BACKUP_DIR${NC}"
    ls -lh "$BACKUP_DIR"
else
    rmdir "$BACKUP_DIR" 2>/dev/null || true
    echo -e "${BLUE}No backups needed${NC}"
fi

echo -e "\n${YELLOW}⚠️  Note: SSH private keys are NOT managed by this script.${NC}"
echo -e "${YELLOW}Place your SSH keys manually in ~/.ssh/${NC}"
