# Dotfiles

My personal configuration files for Fedora Workstation with Hyprland, including Zsh, Neovim, Kitty, Rofi, Waybar, and more.

---

## 🆕 Setting Up a New PC

### Full Installation (Recommended)

**Do NOT manually install Hyprland first!** JaKooLit's script handles everything.

1. **Install Fedora Workstation (fresh installation)**

2. **Install JaKooLit's Hyprland (handles all system setup)**
   ```bash
   # This installs Hyprland + all dependencies + system configs
   git clone --depth=1 https://github.com/JaKooLit/Fedora-Hyprland.git
   cd Fedora-Hyprland
   ./install.sh
   
   # Reboot into Hyprland
   sudo reboot
   ```

3. **Clone and install your dotfiles**
   ```bash
   # Clone your personal dotfiles
   git clone git@github.com:LoicPil/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   
   # Install your packages
   sudo dnf install $(cat packages.txt)
   cat flatpaks-clean.txt | xargs -I {} flatpak install -y flathub {}
   
   # Apply your configs (will backup JaKooLit's defaults automatically)
   ./install.sh
   ```

Your personalized Hyprland setup is now ready! 🎉

### Alternative: Dotfiles Only (Advanced Users)

⚠️ **Warning:** This skips JaKooLit's system setup. Only use if you know what you're doing.

```bash
git clone git@github.com:LoicPil/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install all packages (includes Hyprland)
sudo dnf install $(cat packages.txt)
cat flatpaks-clean.txt | xargs -I {} flatpak install -y flathub {}

# Apply configs
./install.sh

# Reboot
sudo reboot
```

**Note:** JaKooLit's installer does more than install packages - it configures SDDM, audio pipelines, systemd services, etc. Using only dotfiles might miss critical system setup.

---

## 📖 Complete Recovery Guide

For detailed step-by-step instructions on setting up a new machine, including:
- ✅ Restoring SSH keys from Raspberry Pi backup
- ✅ Recovering personal data (Documents, Pictures, Videos)
- ✅ Complete installation checklist with proper order
- ✅ Troubleshooting common issues
- ✅ Post-installation verification steps

**📚 See: [consign/README.md](consign/README.md)**

This comprehensive guide includes everything you need to completely restore your system from scratch, including data recovery from your Raspberry Pi backup.

---

## 🚀 Quick Start (Existing Installation)

### Installation on a New System

```bash
# Clone the repository
git clone git@github.com:LoicPil/dotfiles.git ~/dotfiles

# Navigate to the directory
cd ~/dotfiles

# Install dotfiles (automatically initializes submodules and creates symlinks)
./install.sh

# Optional: Install all packages from backup
sudo dnf install $(cat packages.txt)

# Optional: Install Flatpak applications
cat flatpaks-clean.txt | xargs -I {} flatpak install -y flathub {}
```

### Uninstallation

To remove all dotfiles symlinks:

```bash
cd ~/dotfiles
./uninstall.sh
```

---

## 📦 Package Management

### Update Package Lists

Keep your package lists synchronized with your current system:

```bash
cd ~/dotfiles
./update-packages.sh
```

This updates both:
- `packages.txt` - All user-installed DNF packages
- `flatpaks-clean.txt` - All installed Flatpak applications

### Restore Packages on a Fresh System

```bash
# Install DNF packages
sudo dnf install $(cat ~/dotfiles/packages.txt)

# Install Flatpaks
cat ~/dotfiles/flatpaks-clean.txt | xargs -I {} flatpak install -y flathub {}
```

**Note:** Some package names may differ between Fedora versions. Use `dnf search <package>` to find replacements.

---

## 🔄 Updating Configs from External Scripts

### If you update Hyprland via JaKooLit or similar installers

**First, check if your configs are still symlinked:**
```bash
ls -la ~/.config/hypr
# Should show: hypr -> /home/username/dotfiles/hypr
```

**Scenario 1: Configs are still symlinked (most common)**

If the symlink is intact, changes from external installers go directly to your dotfiles:

```bash
# Changes are already in your dotfiles! Just commit:
cd ~/dotfiles
git status
git add .
git commit -m "Update Hyprland from JaKooLit"
git push
```

**Scenario 2: Installer replaced the symlink with a real directory**

If an external installer removed the symlink and created a new directory:

```bash
# Use the sync script to copy new configs to dotfiles
cd ~/dotfiles
./sync-configs.sh

# Review and commit the changes
git status
git add .
git commit -m "Update configs from JaKooLit"
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

This means:
- ✅ Edit files in `~/dotfiles/` and changes apply immediately
- ✅ All configs are version controlled
- ✅ Easy to sync across multiple machines
- ✅ Backups are created automatically before linking

### Scripts Overview

| Script | Purpose |
|--------|---------|
| `install.sh` | Creates symlinks, initializes submodules, and sets up dotfiles |
| `uninstall.sh` | Removes all symlinks |
| `update-packages.sh` | Updates package lists with currently installed packages |
| `sync-configs.sh` | Syncs configs after external installers break symlinks |

---

## 📁 Repository Structure

```
dotfiles/
├── backup/              # Timestamped backups (gitignored)
├── btop/                # System monitor configuration
├── consign/             # Complete recovery & installation guide
├── emacs/               # Emacs configuration
├── git/                 # Git configuration
├── hypr/                # Hyprland window manager
├── kitty/               # Kitty terminal emulator
├── nvim/                # Neovim configuration
├── oh-my-zsh/           # Oh My Zsh framework (submodule)
├── rofi/                # Application launcher
├── ssh/                 # SSH config (keys NOT tracked!)
├── swaync/              # Notification daemon
├── vim/                 # Vim configuration
├── wallust/             # Wallpaper & color scheme manager
├── waybar/              # Status bar
├── wlogout/             # Logout menu
├── zsh/                 # Zsh configuration
├── flatpaks-clean.txt   # Flatpak applications list
├── packages.txt         # DNF packages list
├── install.sh           # Installation script
├── uninstall.sh         # Uninstallation script
├── update-packages.sh   # Package list updater
└── sync-configs.sh      # Sync script for external updates
```

---

## 🐍 Python Development with UV

[UV](https://github.com/astral-sh/uv) is a fast Python package installer and resolver.

### Install UV

```bash
# Install UV
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or via pip
pip install uv
```

### Initialize a New Python Project

```bash
# Create a new project directory
mkdir ~/my-python-project
cd ~/my-python-project

# Initialize UV project (creates pyproject.toml and virtual environment)
uv init

# Or create with specific Python version
uv init --python 3.12
```

### Working with UV

```bash
# Add dependencies
uv add requests pandas numpy

# Add development dependencies
uv add --dev pytest black ruff

# Install all dependencies from pyproject.toml
uv sync

# Run Python with the virtual environment
uv run python script.py

# Run a specific command
uv run pytest
uv run black .

# Activate the virtual environment manually (if needed)
source .venv/bin/activate
```

### UV Project Structure

After running `uv init`, you'll have:

```
my-python-project/
├── .venv/              # Virtual environment (auto-created)
├── pyproject.toml      # Project configuration and dependencies
├── README.md           # Project documentation
└── src/                # Your source code
    └── __init__.py
```

### Common UV Commands

```bash
uv add <package>        # Add a package
uv remove <package>     # Remove a package
uv sync                 # Install all dependencies
uv run <command>        # Run command in virtual environment
uv pip list             # List installed packages
uv pip freeze           # Export dependencies
uv lock                 # Update lockfile
```

### Example: Quick Python Script

```bash
# Create new project
mkdir ~/scripts/data-analysis
cd ~/scripts/data-analysis

# Initialize with UV
uv init

# Add dependencies
uv add pandas matplotlib

# Create a script
cat > analyze.py << 'EOF'
import pandas as pd
import matplotlib.pyplot as plt

data = {'x': [1, 2, 3, 4], 'y': [10, 20, 25, 30]}
df = pd.DataFrame(data)
df.plot(x='x', y='y')
plt.show()
EOF

# Run it
uv run python analyze.py
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

For multiple keys:

```bash
KEYS=(~/.ssh/id_ed25519 ~/.ssh/id_github_rsa)
for key in "${KEYS[@]}"; do
    [ -f "$key" ] && ssh-add -q "$key" 2>/dev/null
done
```

### Test Connection

```bash
ssh -T git@github.com
```

---

## 🔄 Daily Workflow

### Making Changes

Since configs are symlinked, just edit and commit:

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
git add packages.txt flatpaks-clean.txt
git commit -m "Update package lists"
git push
```

---

## ⚠️ Important Notes

- **SSH Keys**: Private keys are NOT tracked in git (see `.gitignore`)
- **Backups**: Created automatically in `~/dotfiles/backup/TIMESTAMP/` when running `install.sh`
- **Oh-my-zsh**: Managed as a git submodule (automatically initialized by `install.sh`)
- **Package Lists**: Auto-generated by `update-packages.sh` - don't edit manually
- **External Installers**: Use `sync-configs.sh` if installers like JaKooLit break your symlinks
- **JaKooLit First**: Always install JaKooLit's Hyprland setup before applying your dotfiles on a new system
- **Recovery Guide**: See `consign/README.md` for complete system recovery instructions

---

## 🆘 Troubleshooting

### Restore from Backup

If something breaks, backups are in `~/dotfiles/backup/TIMESTAMP/`

### Reinstall Dotfiles

```bash
./uninstall.sh
./install.sh
```

### Check What's Linked

```bash
ls -la ~/.config/nvim  # Should show → /home/username/dotfiles/nvim
```

### After External Installer Breaks Symlinks

```bash
./sync-configs.sh
```

### Hyprland Won't Start

If you installed dotfiles without JaKooLit first:
1. Install JaKooLit's Hyprland
2. Reboot
3. Run `./install.sh` again to apply your configs

---

## 📚 Additional Resources

- **[Complete Recovery Guide](consign/README.md)** - Detailed instructions for fresh installations and data recovery
- [JaKooLit's Fedora-Hyprland](https://github.com/JaKooLit/Fedora-Hyprland)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [UV Documentation](https://github.com/astral-sh/uv)
- [Oh My Zsh](https://ohmyz.sh/)

---

**Backup Location:** `smb://raspberrypinas.local/backuploic/backup-laptop-piletteloic`

**Keep your dotfiles safe and your system consistent!** 🎉
