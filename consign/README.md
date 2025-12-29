# 🔄 System Recovery & Fresh Installation Guide

This guide provides step-by-step instructions for setting up a new machine with my complete environment.

---

## 📋 Prerequisites

Before starting, ensure you have:
- [ ] Fresh Fedora Workstation installation
- [ ] Access to Raspberry Pi backup (raspberrypinas.local)
- [ ] GitHub account access
- [ ] Internet connection

---

## 🚀 Complete Installation Process

### Step 1: Update Fresh Fedora Installation

```bash
# Update system
sudo dnf update -y

# Reboot if kernel was updated
sudo reboot
```

### Step 2: Install JaKooLit's Hyprland

**⚠️ IMPORTANT: Do NOT manually install Hyprland first! JaKooLit's script handles everything.**

```bash
# Clone JaKooLit's installer
git clone --depth=1 https://github.com/JaKooLit/Fedora-Hyprland.git
cd Fedora-Hyprland

# Run installation (installs Hyprland + all dependencies + system configs)
./install.sh

# Follow the prompts and select your preferences
# When finished, reboot into Hyprland
sudo reboot
```

**What this installs:**
- Hyprland window manager
- All required dependencies (waybar, rofi, kitty, etc.)
- SDDM login manager configuration
- Audio/video pipelines (pipewire)
- System services and configurations

---

## 🔐 Step 3: Restore SSH Keys from Backup

**Method 1: Using Pika Backup (Recommended)**

1. Install Pika Backup (if not already installed):
   ```bash
   flatpak install flathub org.gnome.World.PikaBackup
   ```

2. Open Pika Backup
3. Add backup location: `smb://raspberrypinas.local/backuploic/backup-laptop-piletteloic`
4. Browse to the most recent backup archive
5. Restore only: `~/.ssh/`

**Method 2: Manual Restore with Borg**

```bash
# Install borgbackup
sudo dnf install borgbackup

# List available backups
borg list smb://raspberrypinas.local/backuploic/backup-laptop-piletteloic

# Restore SSH directory (replace ARCHIVE_NAME with actual archive)
cd ~
borg extract smb://raspberrypinas.local/backuploic/backup-laptop-piletteloic::ARCHIVE_NAME .ssh
```

**Fix SSH Permissions (CRITICAL!):**

```bash
# Set correct permissions for SSH keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/config
chmod 644 ~/.ssh/known_hosts

# Add key to SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Test GitHub connection
ssh -T git@github.com
# Should output: "Hi LoicPil! You've successfully authenticated..."
```

---

## 📦 Step 4: Clone Dotfiles and Install Packages

```bash
# Clone your dotfiles repository
git clone git@github.com:LoicPil/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install all system packages
sudo dnf install $(cat packages.txt)

# Install Flatpak applications
cat flatpaks-clean.txt | xargs -I {} flatpak install -y flathub {}

# Apply your dotfiles configuration
# This will:
# - Backup JaKooLit's default configs
# - Create symlinks to your personal configs
# - Initialize oh-my-zsh submodule
./install.sh
```

**What this does:**
- Installs all your preferred packages (see `packages.txt`)
- Installs all your Flatpak apps (see `flatpaks-clean.txt`)
- Replaces JaKooLit's default configs with YOUR personalized configs via symlinks
- All configs are now version-controlled and synced

---

## 📂 Step 5: Restore Personal Data from Backup

Use Pika Backup to restore your personal files:

**Essential folders to restore:**

```bash
✅ ~/Documents/        # All your documents
✅ ~/Pictures/         # All your photos
✅ ~/Videos/           # All your videos (if applicable)
```

**Optional folders (only if needed):**

```bash
⚠️  ~/Downloads/                      # Only if important files
⚠️  ~/.mozilla/firefox/               # Firefox data (if not synced)
⚠️  ~/.config/discord/                # Discord settings
⚠️  ~/.local/share/applications/      # Custom .desktop files
```

**❌ DO NOT restore these (use dotfiles versions instead):**

```bash
❌ ~/.config/hypr/         # Your dotfiles has this
❌ ~/.config/waybar/       # Your dotfiles has this
❌ ~/.config/rofi/         # Your dotfiles has this
❌ ~/.config/kitty/        # Your dotfiles has this
❌ ~/.config/nvim/         # Your dotfiles has this
❌ ~/dotfiles/             # Clone fresh from GitHub
❌ ~/.cache/               # Will regenerate automatically
```

---

## ⚙️ Step 6: Final Configuration

### Configure Git (if not using dotfiles version)

Your dotfiles already include `.gitconfig`, but verify it's correct:

```bash
cat ~/.gitconfig
```

Should show:
```ini
[user]
    email = piletteloic@gmail.com
    name = Pilette Loïc
[core]
    editor = nvim
[init]
    defaultBranch = main
[color]
    status = auto
    branch = auto
    interactive = auto
    diff = auto
```

### Auto-load SSH Keys on Startup

Your `~/.zshrc` should already include this (from dotfiles), but verify:

```bash
# Check if SSH auto-load is configured
grep -A 5 "ssh-agent" ~/.zshrc
```

If not present, add this to `~/.zshrc`:

```bash
# Start SSH agent if not running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

# Add SSH keys
ssh-add ~/.ssh/id_ed25519 2>/dev/null
```

### Test Everything

```bash
# Test GitHub SSH
ssh -T git@github.com

# Test Git config
git config --list

# Check if configs are symlinked
ls -la ~/.config/hypr     # Should show → /home/piletteloic/dotfiles/hypr
ls -la ~/.config/waybar   # Should show → /home/piletteloic/dotfiles/waybar

# Reload shell
exec zsh
```

---

## 🔄 Step 7: Setup Pika Backup for New System

Configure Pika Backup to continue backing up this new installation:

1. Open Pika Backup
2. Add backup location: `smb://raspberrypinas.local/backuploic/backup-laptop-piletteloic`
3. Configure backup schedule (e.g., daily)
4. Verify exclusions:
   ```
   ✅ Exclude: ~/dotfiles/backup/
   ✅ Exclude: ~/.cache/
   ✅ Exclude: ~/Downloads/ (optional)
   ✅ Exclude: Fedora-Hyprland/
   ✅ Exclude: Elegant-grub2-themes/
   ```
5. Run initial backup

---

## 📝 Installation Order Summary

**Correct order (follow this!):**

```
1. Fresh Fedora Workstation
2. System update (dnf update)
3. JaKooLit's Hyprland installer
4. Reboot into Hyprland
5. Restore SSH keys from Raspberry Pi backup
6. Fix SSH permissions
7. Clone dotfiles from GitHub
8. Install packages from packages.txt
9. Run ./install.sh (applies your configs)
10. Restore personal data (Documents, Pictures, etc.)
11. Configure Pika Backup
```

**Why this order?**
- JaKooLit sets up the base system (Hyprland + dependencies)
- SSH keys allow you to clone from GitHub
- Dotfiles override JaKooLit's defaults with your personalized configs
- Personal data comes last (doesn't affect system setup)

---

## 🆘 Troubleshooting

### SSH Key Not Working

```bash
# Check permissions
ls -la ~/.ssh/

# Should show:
# drwx------ (700) .ssh/
# -rw------- (600) id_ed25519
# -rw-r--r-- (644) id_ed25519.pub

# Fix if wrong
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

### Dotfiles Symlinks Not Working

```bash
# Check if symlinks were created
ls -la ~/.config/hypr

# Should show: hypr -> /home/piletteloic/dotfiles/hypr

# If not, run install again
cd ~/dotfiles
./install.sh
```

### Package Installation Fails

```bash
# Some packages might have different names in newer Fedora versions
# Search for alternatives
dnf search <package-name>

# Or skip failed packages
sudo dnf install $(cat packages.txt) --skip-broken
```

### Hyprland Won't Start

If you skipped JaKooLit's installer:
1. Install JaKooLit's Hyprland properly
2. Reboot
3. Run `~/dotfiles/install.sh` again

---

## 📊 What Gets Restored vs What's New

### From Raspberry Pi Backup:
- ✅ SSH keys (critical for GitHub access)
- ✅ Documents folder (all your files)
- ✅ Pictures folder (all your photos)
- ✅ Videos folder (if applicable)
- ✅ Firefox data (if not synced)

### From GitHub Dotfiles:
- ✅ All configuration files (hypr, waybar, rofi, kitty, nvim, etc.)
- ✅ Package lists (DNF + Flatpak)
- ✅ Shell configuration (zsh)
- ✅ Git configuration

### Fresh/New:
- ✅ Hyprland installation (from JaKooLit)
- ✅ System packages (from dotfiles packages.txt)
- ✅ Flatpak apps (from dotfiles flatpaks-clean.txt)

---

## ✅ Post-Installation Checklist

- [ ] Hyprland starts correctly
- [ ] All keybinds work as expected
- [ ] Waybar displays correctly
- [ ] Rofi launcher works
- [ ] Documents folder restored
- [ ] Pictures folder restored
- [ ] SSH keys work (can push to GitHub)
- [ ] Firefox has bookmarks/passwords (if applicable)
- [ ] Pika Backup configured and running
- [ ] All Flatpak apps installed
- [ ] Shell (zsh) looks correct with your theme

---

## 🎯 Quick Commands Reference

```bash
# Update package lists (run regularly)
cd ~/dotfiles && ./update-packages.sh

# Sync external config changes (if JaKooLit updates break symlinks)
cd ~/dotfiles && ./sync-configs.sh

# Reinstall dotfiles
cd ~/dotfiles && ./uninstall.sh && ./install.sh

# Check what's symlinked
ls -la ~/.config/

# Test GitHub connection
ssh -T git@github.com

# Update dotfiles from another machine
cd ~/dotfiles && git pull
```

---

## 📚 Important Files Locations

```
~/.ssh/                         # SSH keys (from backup)
~/dotfiles/                     # Your dotfiles repo (from GitHub)
~/Documents/                    # Your documents (from backup)
~/Pictures/                     # Your photos (from backup)
~/.config/hypr/                 # Symlink → ~/dotfiles/hypr/
~/.config/waybar/               # Symlink → ~/dotfiles/waybar/
~/.zshrc                        # Symlink → ~/dotfiles/zsh/.zshrc
~/.gitconfig                    # Symlink → ~/dotfiles/git/gitconfig
~/dotfiles/backup/TIMESTAMP/    # Auto-created backups by install.sh
```

---

## 🔗 Useful Resources

- [JaKooLit's Fedora-Hyprland](https://github.com/JaKooLit/Fedora-Hyprland)
- [Your Dotfiles Repository](https://github.com/LoicPil/dotfiles)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [Pika Backup](https://apps.gnome.org/PikaBackup/)

---

**Last Updated:** December 29, 2024

**Backup Location:** `smb://raspberrypinas.local/backuploic/backup-laptop-piletteloic`

**GitHub Repository:** `git@github.com:LoicPil/dotfiles.git`
