#!/bin/bash

# Update Package Lists Script
# This script updates flatpaks-clean.txt and packages.txt in ~/dotfiles

DOTFILES_DIR="$HOME/dotfiles"
FLATPAKS_FILE="$DOTFILES_DIR/flatpaks-clean.txt"
PACKAGES_FILE="$DOTFILES_DIR/packages.txt"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Updating package lists in $DOTFILES_DIR${NC}"

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${RED}Error: $DOTFILES_DIR directory not found${NC}"
    exit 1
fi

# Update Flatpak list
echo -e "${BLUE}Updating Flatpak list...${NC}"
if command -v flatpak &> /dev/null; then
    flatpak list --app --columns=application | sort > "$FLATPAKS_FILE"
    echo -e "${GREEN}✓ Updated $FLATPAKS_FILE${NC}"
    echo "  $(wc -l < "$FLATPAKS_FILE") Flatpaks listed"
else
    echo -e "${RED}Warning: flatpak command not found${NC}"
fi

# Update system packages list (DNF/RPM based)
echo -e "${BLUE}Updating system packages list...${NC}"
if command -v dnf &> /dev/null; then
    # Get explicitly installed packages (user-installed, not dependencies)
    # Format: all package names concatenated without newlines (matching your original format)
    dnf repoquery --userinstalled --qf '%{name}' | sort | tr -d '\n' > "$PACKAGES_FILE"
    echo -e "${GREEN}✓ Updated $PACKAGES_FILE${NC}"
    
    # Count packages (approximate, since they're concatenated)
    package_count=$(dnf repoquery --userinstalled | wc -l)
    echo "  Approximately $package_count packages listed"
else
    echo -e "${RED}Error: dnf command not found${NC}"
    exit 1
fi

echo -e "${GREEN}Package lists updated successfully!${NC}"
