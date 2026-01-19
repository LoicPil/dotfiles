# Repository Setup Guide

This document lists all external repositories needed for a fresh Fedora installation.

## 📋 Required Repositories

### 1. RPM Fusion (Free & Nonfree)

```bash
# Install RPM Fusion Free
sudo dnf install \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

# Install RPM Fusion Nonfree
sudo dnf install \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable Steam repository (if needed)
sudo dnf config-manager --set-enabled rpmfusion-nonfree-steam

# Enable NVIDIA repository (if needed)
sudo dnf config-manager --set-enabled rpmfusion-nonfree-nvidia-driver
```

### 2. Visual Studio Code

```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf check-update
sudo dnf install code
```

### 3. Google Chrome

```bash
sudo dnf install fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
```

**OR manually:**

```bash
sudo sh -c 'echo -e "[google-chrome]\nname=google-chrome\nbaseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64\nenabled=1\ngpgcheck=1\ngpgkey=https://dl.google.com/linux/linux_signing_key.pub" > /etc/yum.repos.d/google-chrome.repo'
```

### 4. Opera Browser

```bash
sudo rpm --import https://rpm.opera.com/rpmrepo.key

sudo sh -c 'echo -e "[opera]\nname=Opera packages\nbaseurl=https://rpm.opera.com/rpm\nenabled=1\ngpgcheck=1\ngpgkey=https://rpm.opera.com/rpmrepo.key" > /etc/yum.repos.d/opera.repo'
```

### 5. Belgian eID

```bash
sudo sh -c 'echo -e "[eid.belgium.be]\nname=Belgian eID package archive\nbaseurl=https://eid.belgium.be/sites/default/files/software/$basearch\nenabled=1\ngpgcheck=1\ngpgkey=https://eid.belgium.be/sites/default/files/software/eid.belgium.be.asc" > /etc/yum.repos.d/eid.belgium.be.repo'
```

### 6. COPR Repositories

```bash
# Hyprland (solopasha)
sudo dnf copr enable solopasha/hyprland -y

# Hyprland (msmafra)
sudo dnf copr enable msmafra/hyprland -y

# Hyprland (sdegler)
sudo dnf copr enable sdegler/hyprland -y

# nwg-shell (tofik)
sudo dnf copr enable tofik/nwg-shell -y

# SwayNotificationCenter (erikreider)
sudo dnf copr enable erikreider/SwayNotificationCenter -y

# PyCharm (phracek)
sudo dnf copr enable phracek/PyCharm -y

# errornointernet packages
sudo dnf copr enable errornointernet/packages -y
```

## 🔄 Quick Setup Script

Save this as `setup-repos.sh` in your dotfiles:

```bash
#!/bin/bash

set -e

echo "Setting up repositories..."

# RPM Fusion
echo "→ Installing RPM Fusion..."
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable optional RPM Fusion repos
sudo dnf config-manager --set-enabled rpmfusion-nonfree-steam
sudo dnf config-manager --set-enabled rpmfusion-nonfree-nvidia-driver

# VS Code
echo "→ Installing VS Code repository..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

# Google Chrome
echo "→ Installing Google Chrome repository..."
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome

# Opera
echo "→ Installing Opera repository..."
sudo rpm --import https://rpm.opera.com/rpmrepo.key
sudo sh -c 'echo -e "[opera]\nname=Opera packages\nbaseurl=https://rpm.opera.com/rpm\nenabled=1\ngpgcheck=1\ngpgkey=https://rpm.opera.com/rpmrepo.key" > /etc/yum.repos.d/opera.repo'

# Belgian eID
echo "→ Installing Belgian eID repository..."
sudo sh -c 'echo -e "[eid.belgium.be]\nname=Belgian eID package archive\nbaseurl=https://eid.belgium.be/sites/default/files/software/$basearch\nenabled=1\ngpgcheck=1\ngpgkey=https://eid.belgium.be/sites/default/files/software/eid.belgium.be.asc" > /etc/yum.repos.d/eid.belgium.be.repo'

# COPR repositories
echo "→ Enabling COPR repositories..."
sudo dnf copr enable solopasha/hyprland -y
sudo dnf copr enable msmafra/hyprland -y
sudo dnf copr enable sdegler/hyprland -y
sudo dnf copr enable tofik/nwg-shell -y
sudo dnf copr enable erikreider/SwayNotificationCenter -y
sudo dnf copr enable phracek/PyCharm -y
sudo dnf copr enable errornointernet/packages -y

echo "✓ All repositories configured!"
echo "Run 'sudo dnf check-update' to refresh package lists"
```

## 📝 Usage

### On a Fresh System

1. **Setup repositories first:**
   ```bash
   cd ~/dotfiles
   chmod +x setup-repos.sh
   ./setup-repos.sh
   ```

2. **Then install packages:**
   ```bash
   sudo dnf install $(cat packages.txt)
   cat flatpaks-clean.txt | xargs -I {} flatpak install -y flathub {}
   ```

### Updating Repository List

To save your current repository configuration:

```bash
cd ~/dotfiles
./update-repos.sh
git add repos.txt
git commit -m "Update repository list"
git push
```

## ⚠️ Notes

- Some repos (like Chrome and RPM Fusion) are widely used and stable
- COPR repos are community-maintained and may change or become unavailable
- Belgian eID is specific to Belgian citizens
- Always verify repo URLs before adding them on a fresh system
