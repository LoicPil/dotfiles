# Dotfiles

My personal configuration files for Fedora Workstation with Hyprland, including Zsh, Neovim, Kitty, Rofi, Waybar, and more.

---

## 🚀 Quick Start

### Installation on a New System

```bash
# Clone the repository
git clone git@github.com:LoicPil/dotfiles.git ~/dotfiles

# Navigate to the directory
cd ~/dotfiles

# Initialize submodules (oh-my-zsh, etc.)
git submodule update --init --recursive

# Install dotfiles (creates symlinks)
./install.sh

# Optional: Install all packages from backup
sudo dnf install $(cat packages.txt)
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
- `packages.txt` - All user-installed DNF packages (628 packages)
- `flatpaks-clean.txt` - All installed Flatpak applications (14 apps)

### Restore Packages on a Fresh System

```bash
# Install DNF packages
sudo dnf install $(cat ~/dotfiles/packages.txt)

# Install Flatpaks
cat ~/dotfiles/flatpaks-clean.txt | xargs -I {} flatpak install -y flathub {}
```

**Note:** Some package names may differ between Fedora versions. Use `dnf search <package>` to find replacements.

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
| `install.sh` | Creates symlinks and sets up dotfiles |
| `uninstall.sh` | Removes all symlinks |
| `update-packages.sh` | Updates package lists with currently installed packages |

---

## 📁 Repository Structure

```
dotfiles/
├── backup/              # Timestamped backups (gitignored)
├── btop/                # System monitor configuration
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
└── update-packages.sh   # Package list updater
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
- **Backups**: Created automatically in `~/dotfiles/backup/` when running `install.sh`
- **Oh-my-zsh**: Managed as a git submodule
- **Package Lists**: Auto-generated - don't edit manually

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

---

**Keep your dotfiles safe and your system consistent!** 🎉
