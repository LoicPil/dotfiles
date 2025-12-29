#!/bin/bash

# Dotfiles Installation Script
# Creates symlinks from dotfiles to their proper locations

set -e  # Exit on error

DOTFILES_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Installing dotfiles from $DOTFILES_DIR${NC}\n"

# Function to create symlink with backup
link_file() {
    local src="$1"
    local dest="$2"
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"
    
    # Backup existing file/directory
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ ! -L "$dest" ]; then
            echo -e "${YELLOW}  Backing up existing $(basename "$dest")${NC}"
            mv "$dest" "${dest}.backup_${BACKUP_DATE}"
        else
            rm "$dest"
        fi
    fi
    
    # Create symlink
    ln -sf "$src" "$dest"
    echo -e "${GREEN}  ✓ Linked $dest${NC}"
}

# ZSH
echo -e "${BLUE}Setting up ZSH...${NC}"
link_file "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/oh-my-zsh" "$HOME/.oh-my-zsh"

# Neovim
echo -e "\n${BLUE}Setting up Neovim...${NC}"
# Remove circular symlink first
[ -L "$DOTFILES_DIR/nvim/nvim" ] && rm "$DOTFILES_DIR/nvim/nvim"
link_file "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim"

# Vim
echo -e "\n${BLUE}Setting up Vim...${NC}"
link_file "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"

# Emacs
echo -e "\n${BLUE}Setting up Emacs...${NC}"
link_file "$DOTFILES_DIR/emacs" "$CONFIG_DIR/emacs"

# Hyprland
echo -e "\n${BLUE}Setting up Hyprland...${NC}"
link_file "$DOTFILES_DIR/hypr" "$CONFIG_DIR/hypr"

# Kitty
echo -e "\n${BLUE}Setting up Kitty...${NC}"
link_file "$DOTFILES_DIR/kitty" "$CONFIG_DIR/kitty"

# Waybar
echo -e "\n${BLUE}Setting up Waybar...${NC}"
link_file "$DOTFILES_DIR/waybar" "$CONFIG_DIR/waybar"

# Rofi
echo -e "\n${BLUE}Setting up Rofi...${NC}"
link_file "$DOTFILES_DIR/rofi" "$CONFIG_DIR/rofi"

# Wlogout
echo -e "\n${BLUE}Setting up Wlogout...${NC}"
link_file "$DOTFILES_DIR/wlogout" "$CONFIG_DIR/wlogout"

# SwayNC
echo -e "\n${BLUE}Setting up SwayNC...${NC}"
link_file "$DOTFILES_DIR/swaync" "$CONFIG_DIR/swaync"

# Wallust
echo -e "\n${BLUE}Setting up Wallust...${NC}"
link_file "$DOTFILES_DIR/wallust" "$CONFIG_DIR/wallust"

# Btop
echo -e "\n${BLUE}Setting up Btop...${NC}"
link_file "$DOTFILES_DIR/btop" "$CONFIG_DIR/btop"

# Git
echo -e "\n${BLUE}Setting up Git...${NC}"
link_file "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"

# SSH (config only, not keys!)
echo -e "\n${BLUE}Setting up SSH config...${NC}"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ -f "$DOTFILES_DIR/ssh/config" ]; then
    link_file "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
    chmod 600 "$HOME/.ssh/config"
fi

echo -e "\n${GREEN}✓ Dotfiles installation complete!${NC}"
echo -e "${YELLOW}Note: SSH keys are NOT managed by this script for security reasons.${NC}"
echo -e "${YELLOW}Place your SSH keys manually in ~/.ssh/${NC}"
