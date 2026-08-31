# Dotfiles

My personal configuration files for Fedora Workstation with Hyprland, including Zsh, Neovim, Kitty, Rofi, Waybar, and more.

![Fedora](https://img.shields.io/badge/Fedora-51A2DA?style=for-the-badge&logo=fedora&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-58C4DC?style=for-the-badge&logo=hyprland&logoColor=white)
![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Zsh](https://img.shields.io/badge/Zsh-F15A24?style=for-the-badge&logo=zsh&logoColor=white)

---

## 📋 Table of Contents

- [Setting Up a New PC](#-setting-up-a-new-pc)
- [Quick Start](#-quick-start-existing-installation)
- [Scripts Overview](#-scripts-overview)
- [Repository Management](#-repository-management)
- [Package Management](#-package-management)
- [Updating Configurations](#-updating-configurations)
- [How It Works](#-how-it-works)
- [Development Tools](#-development-tools)
- [SSH Key Setup](#-ssh-key-setup)
- [Daily Workflow](#-daily-workflow)
- [Troubleshooting](#-troubleshooting)
- [Quick Reference](#-quick-reference)

---

## 🆕 Setting Up a New PC

### Full Installation (Recommended)

**Do NOT manually install Hyprland first!** JaKooLit's script handles everything.

#### Step 1: Install Fedora Workstation

Start with a fresh Fedora Workstation installation.

#### Step 2: Install JaKooLit's Hyprland

This handles all system setup (Hyprland, SDDM, audio pipelines, systemd services, etc.):

```bash
git clone --depth=1 https://github.com/JaKooLit/Fedora-Hyprland.git
cd Fedora-Hyprland
./install.sh

# Reboot into Hyprland
sudo reboot
```

#### Step 3: Clone Your Dotfiles

```bash
# Clone your personal dotfiles
git clone git@github.com:LoicPil/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

#### Step 4: Setup Repositories (CRITICAL!)

**⚠️ IMPORTANT:** You MUST setup repositories BEFORE installing packages!

```bash
# Setup all required repositories
./setup-repos.sh
```

This installs:

- RPM Fusion (Free & Nonfree)
- Visual Studio Code
- Google Chrome
- Opera Browser
- Belgian eID
- All COPR repos (Hyprland, PyCharm, SwayNotificationCenter, etc.)

#### Step 5: Install Packages

```bash
# Install DNF packages
sudo dnf install $(cat packages.txt)

# Install Flatpaks
cat flatpaks.txt | xargs -I {} flatpak install -y flathub {}
```

#### Step 6: Apply Your Dotfiles

```bash
# Apply your configs (automatically creates backups and symlinks)
./install.sh
```

#### Step 7: Install Development Tools (Optional)

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Install UV (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Your personalized Hyprland setup is now ready! 🎉

---

## 🚀 Quick Start (Existing Installation)

### Installation on a New System

```bash
# Clone the repository
git clone git@github.com:LoicPil/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Setup repositories (REQUIRED FIRST!)
./setup-repos.sh

# Install dotfiles
./install.sh

# Optional: Install all packages from backup
sudo dnf install $(cat packages.txt)
cat flatpaks.txt | xargs -I {} flatpak install -y flathub {}
```

### Uninstallation

```bash
cd ~/dotfiles
./uninstall.sh
```

---

## 🔧 Scripts Overview

All scripts are organized in the `scripts/` directory. Symlinks at the root provide easy access.

### Main Scripts

| Script | Purpose |
|--------|---------|
| `install.sh` | Creates symlinks, initializes submodules, sets up dotfiles |
| `uninstall.sh` | Removes all symlinks |
| `sync-configs.sh` | Syncs configs after external installers break symlinks |
| `backup-system.sh` | Full system backup (repos + packages + flatpaks) |
| `restore-system.sh` | Full system restore from backup |
| `cleanup-backups.sh` | Keep only the 2 most recent backups |

### Maintenance Scripts

| Script | Purpose |
|--------|---------|
| `setup-repos.sh` | Configures all required DNF repositories |
| `update-repos.sh` | Saves current repository configuration |
| `update-packages.sh` | Updates package lists (DNF + Flatpak) |

### Usage Examples

```bash
cd ~/dotfiles

# Full system backup
./backup-system.sh

# Restore everything on a new system
./restore-system.sh

# Clean old backups (keeps only 2 most recent)
./cleanup-backups.sh

# Setup repositories only
./setup-repos.sh

# Update package lists only
./update-packages.sh
```

---

## 📦 Repository Management

### Setup Repositories on Fresh System

**⚠️ CRITICAL:** Always setup repositories BEFORE installing packages!

```bash
cd ~/dotfiles
./setup-repos.sh
```

This configures:

- **RPM Fusion** (Free & Nonfree) - Additional software packages
- **Visual Studio Code** - Microsoft's code editor
- **Google Chrome** - Google's web browser
- **Opera** - Opera web browser
- **Belgian eID** - Belgian electronic ID card support
- **COPR Repositories:** Hyprland, PyCharm, SwayNotificationCenter, lazygit, and more

### Update Repository List

```bash
cd ~/dotfiles
./update-repos.sh

git add repos.txt
git commit -m "Update repository list"
git push
```

---

## 📦 Package Management

### Update Package Lists

```bash
cd ~/dotfiles
./update-packages.sh
```

This updates both:

- `packages.txt` - All user-installed DNF packages
- `flatpaks.txt` - All installed Flatpak applications

### Restore Packages on a Fresh System

```bash
# FIRST: Setup repositories
cd ~/dotfiles
./setup-repos.sh

# THEN: Install packages
sudo dnf install $(cat packages.txt)
cat flatpaks.txt | xargs -I {} flatpak install -y flathub {}
```

---

## 🔄 Updating Configurations

### Method 1: Automatic Updates via Waybar Button (Recommended)

1. Click the update button in Waybar
2. Compares your local version with JaKooLit's GitHub
3. Shows notification if update available
4. One-click update process

### After Update: Review and Commit

```bash
cd ~/dotfiles
git status
git diff

git add .
git commit -m "Update from JaKooLit v2.X.X"
git push
```

### Method 2: Manual Update

```bash
cd ~/Hyprland-Dots
git pull
~/.config/hypr/UserScripts/upgrade-custom.sh

cd ~/dotfiles
git add .
git commit -m "Update from JaKooLit"
git push
```

### Method 3: Sync After Broken Symlinks

```bash
cd ~/dotfiles
./sync-configs.sh

git add .
git commit -m "Sync configs after external update"
git push
```

---

## 🔧 How It Works

### Symlink Structure

The install script creates symlinks from your home directory to the dotfiles repository:

```
~/.config/nvim    → ~/dotfiles/nvim
~/.config/hypr    → ~/dotfiles/hypr
~/.zshrc          → ~/dotfiles/zsh/.zshrc
~/.gitconfig      → ~/dotfiles/git/gitconfig
# etc...
```

### Repository Structure

```
dotfiles/
├── backup/              # Timestamped backups (gitignored)
├── backups/             # System backups from backup-system.sh
├── consign/             # Complete recovery & installation guide
├── scripts/             # ALL scripts organized here
│   ├── install.sh
│   ├── uninstall.sh
│   ├── sync-configs.sh
│   ├── backup-system.sh
│   ├── restore-system.sh
│   ├── cleanup-backups.sh
│   ├── setup-repos.sh
│   ├── update-repos.sh
│   └── update-packages.sh
├── btop/                # System monitor configuration
├── cava/                # Audio visualizer
├── emacs/               # Emacs configuration
├── git/                 # Git configuration
├── hypr/                # Hyprland window manager
├── kitty/               # Kitty terminal emulator
├── Kvantum/             # Theme engine
├── nvim/                # Neovim configuration
├── oh-my-zsh/           # Oh My Zsh framework (submodule)
├── qt5ct/ qt6ct/        # Qt configuration
├── rofi/                # Application launcher
├── ssh/                 # SSH config (keys NOT tracked!)
├── swaync/              # Notification daemon
├── swappy/              # Screenshot tool
├── wallust/             # Wallpaper & color scheme manager
├── waybar/              # Status bar
├── wlogout/             # Logout menu
├── zsh/                 # Zsh configuration
├── flatpaks.txt         # Flatpak applications list
├── packages.txt         # DNF packages list
├── repos.txt            # Repository configuration
└── [symlinks to scripts/*.sh]
```

---

## 🛠️ Development Tools

### Python Development with UV

UV is a fast Python package installer and resolver.

#### Install UV

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

#### Initialize a New Python Project

```bash
mkdir ~/my-python-project
cd ~/my-python-project
uv init

# Or with specific Python version
uv init --python 3.12
```

#### Working with UV

```bash
# Add dependencies
uv add requests pandas numpy

# Add development dependencies
uv add --dev pytest black ruff

# Install all dependencies
uv sync

# Run Python with virtual environment
uv run python script.py
```

#### Common UV Commands

```bash
uv add <package>        # Add a package
uv remove <package>     # Remove a package
uv sync                 # Install all dependencies
uv run <command>        # Run command in virtual environment
uv pip list             # List installed packages
uv pip freeze           # Export dependencies
uv lock                 # Update lockfile
```

### Rust Development

Rust is a systems programming language focused on safety, speed, and concurrency.

#### Install Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Verify installation
rustc --version
cargo --version
```

#### Creating a New Rust Project

```bash
mkdir ~/projects
cd ~/projects
cargo new my-app
```

#### Working with Cargo

```bash
cd project-name
cargo build                  # Build in debug mode
cargo build --release        # Build optimized
cargo run                    # Build and run
cargo test                   # Run tests
cargo check                  # Check code without building
cargo clippy                 # Run linter
cargo fmt                    # Format code

# Dependencies
cargo add serde              # Add a dependency
cargo remove serde           # Remove a dependency
cargo update                 # Update dependencies
```

#### Common Cargo Commands

```bash
cargo new <name>             # Create new project
cargo build                  # Build project
cargo run                    # Build and run
cargo test                   # Run tests
cargo check                  # Fast compile check
cargo clippy                 # Linting
cargo fmt                    # Format code
cargo clean                  # Clean build artifacts
cargo doc --open             # Generate and open docs
```

#### Updating Rust

```bash
rustup update
rustc --version
```

---

## 🔐 SSH Key Setup

### Generate SSH Key

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

### Add to SSH Agent

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### Add to GitHub

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the output and add it at [GitHub SSH Keys](https://github.com/settings/keys)

### Auto-load SSH Keys at Startup

Add to `~/.zshrc`:

```bash
# Start SSH agent if not running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

# Add SSH keys
ssh-add ~/.ssh/id_ed25519 2>/dev/null
```

### Test Connection

```bash
ssh -T git@github.com
```

---

## 🔄 Daily Workflow

### Making Changes

```bash
# Edit any config file
nvim ~/dotfiles/hypr/hyprland.conf

# Changes apply immediately (it's a symlink!)

# Commit when satisfied
cd ~/dotfiles
git add .
git commit -m "Update Hyprland keybinds"
git push
```

### Syncing to Another Machine

```bash
cd ~/dotfiles
git pull
# Changes apply immediately via symlinks
```

### Updating Package Lists

```bash
cd ~/dotfiles
./update-packages.sh
git add packages.txt flatpaks.txt
git commit -m "Update package lists"
git push
```

### Updating Repository Lists

```bash
cd ~/dotfiles
./update-repos.sh
git add repos.txt
git commit -m "Update repository list"
git push
```

---

## ⚠️ Important Notes

- **Repositories First**: Always run `./setup-repos.sh` BEFORE installing packages
- **SSH Keys**: Private keys are NOT tracked in git (see `.gitignore`)
- **Backups**: Created automatically in `~/dotfiles/backup/TIMESTAMP/` during updates
- **Oh-my-zsh**: Managed as a git submodule (automatically initialized by `install.sh`)
- **Package Lists**: Auto-generated by `update-packages.sh` - don't edit manually
- **Repository List**: Auto-generated by `update-repos.sh` - don't edit manually
- **Protected Configs**: UserConfigs/, UserScripts/, and personal waybar styles are never overwritten
- **JaKooLit First**: Always install JaKooLit's Hyprland setup before applying your dotfiles

---

## 🆘 Troubleshooting

### Repository Issues

**"Package not found" errors during installation**

```bash
# You probably forgot to setup repositories first!
cd ~/dotfiles
./setup-repos.sh

# Then retry package installation
sudo dnf install $(cat packages.txt)
```

**Check which repositories are enabled**

```bash
dnf repolist
```

### Update Issues

**"No update available" message**

```bash
# You're already on the latest version
# Check manually:
ls ~/Hyprland-Dots/config/hypr/v*
```

### Restore from Backup

**List available backups:**

```bash
ls ~/dotfiles/backup/
```

**Restore specific config:**

```bash
cp -r ~/dotfiles/backup/TIMESTAMP/hypr ~/dotfiles/

cd ~/dotfiles
git add .
git commit -m "Restore hypr config from backup"
git push
```

### Check Symlinks

```bash
# Verify symlinks are correct
ls -la ~/.config/nvim   # Should show → /home/username/dotfiles/nvim
ls -la ~/.config/hypr   # Should show → /home/username/dotfiles/hypr
```

---

## 🎯 Quick Reference

### First-Time Setup (Correct Order!)

```bash
# 1. Install JaKooLit's Hyprland
git clone --depth=1 https://github.com/JaKooLit/Fedora-Hyprland.git
cd Fedora-Hyprland && ./install.sh && sudo reboot

# 2. Clone your dotfiles
git clone git@github.com:LoicPil/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 3. Setup repositories FIRST (CRITICAL!)
./setup-repos.sh

# 4. Install packages
sudo dnf install $(cat packages.txt)
cat flatpaks.txt | xargs -I {} flatpak install -y flathub {}

# 5. Apply dotfiles
./install.sh

# 6. Install development tools (optional)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Maintenance

```bash
# Full system backup (repos + packages + flatpaks)
./backup-system.sh

# Full system restore
./restore-system.sh

# Update package lists only
./update-packages.sh

# Update repository list only
./update-repos.sh

# Clean old backups (keeps 2 most recent)
./cleanup-backups.sh

# Reinstall dotfiles
./uninstall.sh && ./install.sh

# Restore from backup
cp -r backup/20260831_114623/hypr ~/dotfiles/
```

---

**Keep your dotfiles safe and your system consistent!** 🎉
