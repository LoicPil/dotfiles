#!/bin/bash
# Setup All Required Repositories
# Run this BEFORE installing packages on a fresh system

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Setting up repositories...${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# RPM Fusion
echo -e "${YELLOW}→ Installing RPM Fusion (Free & Nonfree)...${NC}"
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable optional RPM Fusion repos
echo -e "${YELLOW}→ Enabling RPM Fusion optional repos...${NC}"
sudo dnf config-manager --set-enabled rpmfusion-nonfree-steam
sudo dnf config-manager --set-enabled rpmfusion-nonfree-nvidia-driver

# VS Code
echo -e "${YELLOW}→ Installing VS Code repository...${NC}"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Google Chrome
echo -e "${YELLOW}→ Installing Google Chrome repository...${NC}"
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome

# Opera
echo -e "${YELLOW}→ Installing Opera repository...${NC}"
sudo rpm --import https://rpm.opera.com/rpmrepo.key
sudo sh -c 'echo -e "[opera]\nname=Opera packages\nbaseurl=https://rpm.opera.com/rpm\nenabled=1\ngpgcheck=1\ngpgkey=https://rpm.opera.com/rpmrepo.key" > /etc/yum.repos.d/opera.repo'

# Belgian eID
echo -e "${YELLOW}→ Installing Belgian eID repository...${NC}"
sudo sh -c 'echo -e "[eid.belgium.be]\nname=Belgian eID package archive\nbaseurl=https://eid.belgium.be/sites/default/files/software/$basearch\nenabled=1\ngpgcheck=1\ngpgkey=https://eid.belgium.be/sites/default/files/software/eid.belgium.be.asc" > /etc/yum.repos.d/eid.belgium.be.repo'

# COPR repositories
echo -e "${YELLOW}→ Enabling COPR repositories...${NC}"
sudo dnf copr enable solopasha/hyprland -y
sudo dnf copr enable msmafra/hyprland -y
sudo dnf copr enable sdegler/hyprland -y
sudo dnf copr enable tofik/nwg-shell -y
sudo dnf copr enable erikreider/SwayNotificationCenter -y
sudo dnf copr enable phracek/PyCharm -y
sudo dnf copr enable errornointernet/packages -y

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ All repositories configured!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Run: sudo dnf check-update"
echo "  2. Install packages: sudo dnf install \$(cat packages.txt)"
echo "  3. Install Flatpaks: cat flatpaks-clean.txt | xargs -I {} flatpak install -y flathub {}"
