# Dotfiles

My personal configuration files for Fedora Workstation with Hyprland, including Zsh, Neovim, Kitty, Rofi, Waybar, and more.

---

## 📋 Table of Contents

- [Setting Up a New PC](#-setting-up-a-new-pc)
- [Quick Start](#-quick-start-existing-installation)
- [Package Management](#-package-management)
- [Updating Configurations](#-updating-configurations)
- [How It Works](#-how-it-works)
- [Development Tools](#-development-tools)
  - [Python with UV](#python-development-with-uv)
  - [Rust](#rust-development)
- [SSH Key Setup](#-ssh-key-setup)
- [Daily Workflow](#-daily-workflow)
- [Troubleshooting](#-troubleshooting)

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

#### Step 3: Clone and Install Your Dotfiles

```bash
# Clone your personal dotfiles
git clone git@github.com:LoicPil/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install your packages
sudo dnf install $(cat packages.txt)
cat flatpaks-clean.txt | xargs -I {} flatpak install -y flathub {}

# Apply your configs (automatically creates backups and symlinks)
./install.sh
```

#### Step 4: Install Development Tools (Optional)

```bash
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Install UV (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Your personalized Hyprland setup is now ready! 🎉

### Alternative: Dotfiles Only (Advanced Users)

⚠️ **Warning:** This skips JaKooLit's system setup. Only use if you know what you're doing.

```bash
git clone git@github.com:LoicPil/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install all packages
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

For detailed step-by-step instructions on setting up a new machine:

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
cd ~/dotfiles

# Install dotfiles (automatically initializes submodules and creates symlinks)
./install.sh

# Optional: Install all packages from backup
sudo dnf install $(cat packages.txt)
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

## 🔄 Updating Configurations

### Method 1: Automatic Updates via Waybar Button (Recommended)

Your Waybar includes an automatic update checker that monitors JaKooLit's repository.

#### How It Works

1. **Click the update button** in Waybar
2. Compares your local version with JaKooLit's GitHub
3. Shows notification if update available
4. One-click update process

#### Update Process

When you click **"Update"**:

```bash
# The system automatically:
1. Opens Kitty terminal
2. Updates ~/Hyprland-Dots (git pull)
3. Runs upgrade-custom.sh from UserScripts/
4. Creates backups in ~/dotfiles/backup/TIMESTAMP/
5. Applies changes directly to your dotfiles (via symlinks)
```

#### After Update: Review and Commit

Since your configs are symlinked to `~/dotfiles/`, changes go directly there:

```bash
# Review what changed
cd ~/dotfiles
git status
git diff

# Commit and push
git add .
git commit -m "Update from JaKooLit v2.X.X"
git push
```

#### What Gets Updated

The script compares and updates these directories:

- `hypr/` (excludes UserConfigs/ and UserScripts/)
- `waybar/` (excludes your config and style.css)
- `rofi/`, `kitty/`, `swaync/`, `wlogout/`, `wallust/`, etc.

**Your personal files are NEVER touched:**

- ✅ `hypr/UserConfigs/` - Safe
- ✅ `hypr/UserScripts/` - Safe
- ✅ `waybar/config` and `waybar/style.css` - Safe

### Method 2: Manual Update

Update manually from terminal:

```bash
# Update Hyprland-Dots
cd ~/Hyprland-Dots
git pull

# Run the custom upgrade script
~/.config/hypr/UserScripts/upgrade-custom.sh

# Review and commit
cd ~/dotfiles
git status
git add .
git commit -m "Update from JaKooLit"
git push
```

### Method 3: Sync After Broken Symlinks

If an external installer breaks your symlinks:

```bash
cd ~/dotfiles
./sync-configs.sh

# Review and commit the changes
git status
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

**Benefits:**

- ✅ Edit files in `~/dotfiles/` and changes apply immediately
- ✅ All configs are version controlled
- ✅ Easy to sync across multiple machines
- ✅ Backups created automatically before any changes

### Scripts Overview

| Script | Purpose |
|--------|---------|
| `install.sh` | Creates symlinks, initializes submodules, sets up dotfiles |
| `uninstall.sh` | Removes all symlinks |
| `update-packages.sh` | Updates package lists with currently installed packages |
| `sync-configs.sh` | Syncs configs after external installers break symlinks |
| `hypr/scripts/KooLsDotsUpdate.sh` | Checks for updates from Waybar button |
| `hypr/UserScripts/upgrade-custom.sh` | Custom upgrade script with dotfiles backup |

### Repository Structure

```
dotfiles/
├── backup/              # Timestamped backups (gitignored)
├── Upgrade-Logs/        # Update logs (gitignored)
├── btop/                # System monitor configuration
├── consign/             # Complete recovery & installation guide
├── emacs/               # Emacs configuration
├── git/                 # Git configuration
├── hypr/                # Hyprland window manager
│   ├── UserConfigs/     # Your personal Hyprland settings (preserved during updates)
│   ├── UserScripts/     # Your custom scripts (preserved during updates)
│   └── scripts/         # System scripts
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

## 🛠️ Development Tools

### Python Development with UV

[UV](https://github.com/astral-sh/uv) is a fast Python package installer and resolver.

#### Install UV

```bash
# Install UV
curl -LsSf https://astral.sh/uv/install.sh | sh

# Or via pip
pip install uv
```

#### Initialize a New Python Project

```bash
# Create a new project directory
mkdir ~/my-python-project
cd ~/my-python-project

# Initialize UV project (creates pyproject.toml and virtual environment)
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

# Run specific commands
uv run pytest
uv run black .

# Activate virtual environment manually (if needed)
source .venv/bin/activate
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

#### Example: Quick Python Script

```bash
# Create new project
mkdir ~/projects/data-analysis
cd ~/projects/data-analysis

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

### Rust Development

[Rust](https://www.rust-lang.org/) is a systems programming language focused on safety, speed, and concurrency.

#### Install Rust

Rust is installed via `rustup`, which manages Rust versions and associated tools:

```bash
# Install Rust (interactive installer)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Reload shell to use Rust
source ~/.cargo/env

# Verify installation
rustc --version
cargo --version
```

**What gets installed:**

- `~/.cargo/` - Cargo home directory (packages and binaries)
- `~/.rustup/` - Rustup home directory (Rust toolchains)

#### Creating a New Rust Project

```bash
# Create a new binary project
mkdir ~/projects
cd ~/projects
cargo new my-app

# This creates:
# my-app/
# ├── Cargo.toml       # Project manifest
# └── src/
#     └── main.rs      # Main source file
```

#### Working with Cargo

```bash
# Create a new project
cargo new project-name       # Binary (application)
cargo new --lib library-name # Library

# Build and run
cd project-name
cargo build                  # Build in debug mode
cargo build --release        # Build optimized
cargo run                    # Build and run
cargo run -- arg1 arg2       # Run with arguments

# Testing and checking
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

#### Example: Hello World

```bash
# Create a new project
cd ~/projects
cargo new hello-rust
cd hello-rust

# Edit src/main.rs
cat > src/main.rs << 'EOF'
fn main() {
    println!("Hello, Rust!");
    
    let name = "World";
    println!("Hello, {}!", name);
}
EOF

# Run it
cargo run
```

#### Example: Project with Dependencies

```bash
# Create a project
cargo new json-parser
cd json-parser

# Add a dependency
cargo add serde serde_json

# Edit src/main.rs
cat > src/main.rs << 'EOF'
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
struct Person {
    name: String,
    age: u32,
}

fn main() {
    let person = Person {
        name: "Alice".to_string(),
        age: 30,
    };
    
    // Serialize to JSON
    let json = serde_json::to_string(&person).unwrap();
    println!("JSON: {}", json);
    
    // Deserialize from JSON
    let parsed: Person = serde_json::from_str(&json).unwrap();
    println!("Parsed: {:?}", parsed);
}
EOF

# Run it
cargo run
```

#### Updating Rust

```bash
# Update Rust toolchain
rustup update

# Check current version
rustc --version
```

#### Useful Resources

- [The Rust Book](https://doc.rust-lang.org/book/) - Official learning resource
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/) - Learn by examples
- [Cargo Book](https://doc.rust-lang.org/cargo/) - Cargo documentation
- [crates.io](https://crates.io/) - Rust package registry

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
- **Backups**: Created automatically in `~/dotfiles/backup/TIMESTAMP/` during updates
- **Update Logs**: Saved in `~/dotfiles/Upgrade-Logs/`
- **Oh-my-zsh**: Managed as a git submodule (automatically initialized by `install.sh`)
- **Package Lists**: Auto-generated by `update-packages.sh` - don't edit manually
- **Protected Configs**: UserConfigs/, UserScripts/, and personal waybar styles are never overwritten
- **JaKooLit First**: Always install JaKooLit's Hyprland setup before applying your dotfiles on a new system
- **Version Tracking**: File `hypr/v2.X.X` tracks your current Hyprland dots version
- **Development Tools**: Rust and UV are installed in user directories (`~/.cargo/` and `~/.local/`)

---

## 🆘 Troubleshooting

### Update Issues

**"No update available" message**

```bash
# You're already on the latest version
# Check manually:
ls ~/Hyprland-Dots/config/hypr/v*
```

**Want to skip specific updates**

- The upgrade script asks confirmation for each directory
- Simply answer "N" for directories you don't want to update

### Restore from Backup

**List available backups:**

```bash
ls ~/dotfiles/backup/
```

**Restore specific config:**

```bash
# Restore from backup
cp -r ~/dotfiles/backup/TIMESTAMP/hypr ~/dotfiles/

# Commit the restoration
cd ~/dotfiles
git add .
git commit -m "Restore hypr config from backup"
git push
```

### Reinstall Dotfiles

```bash
cd ~/dotfiles
./uninstall.sh
./install.sh
```

### Check Symlinks

```bash
# Verify symlinks are correct
ls -la ~/.config/nvim   # Should show → /home/username/dotfiles/nvim
ls -la ~/.config/hypr   # Should show → /home/username/dotfiles/hypr
```

### After External Installer Breaks Symlinks

```bash
cd ~/dotfiles
./sync-configs.sh
```

### Hyprland Won't Start

If you installed dotfiles without JaKooLit first:

1. Install JaKooLit's Hyprland setup
2. Reboot into Hyprland
3. Run `./install.sh` again to apply your configs

### View Update Logs

```bash
# View recent update logs
ls ~/dotfiles/Upgrade-Logs/
cat ~/dotfiles/Upgrade-Logs/upgrade-*.log
```

### Development Tools Issues

**Rust not found after restart**

```bash
# Make sure Rust is in PATH
source ~/.cargo/env

# Or restart shell
exec zsh
```

**UV not found**

```bash
# Reinstall UV
curl -LsSf https://astral.sh/uv/install.sh | sh
```

---

## 📚 Additional Resources

### Dotfiles & Hyprland

- **[Complete Recovery Guide](consign/README.md)** - Detailed instructions for fresh installations and data recovery
- [JaKooLit's Fedora-Hyprland](https://github.com/JaKooLit/Fedora-Hyprland) - System installation
- [JaKooLit's Hyprland-Dots](https://github.com/JaKooLit/Hyprland-Dots) - Upstream configurations
- [Hyprland Wiki](https://wiki.hyprland.org/) - Official documentation

### Development Tools

- [UV Documentation](https://github.com/astral-sh/uv) - Python package manager
- [The Rust Book](https://doc.rust-lang.org/book/) - Learn Rust
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/) - Practical examples
- [crates.io](https://crates.io/) - Rust packages

### Shell & Config

- [Oh My Zsh](https://ohmyz.sh/) - Zsh framework

---

## 💾 Backup Information

**Primary Backup Location:** `smb://raspberrypinas.local/backuploic/backup-laptop-piletteloic`

**Local Backups:**

- Configuration backups: `~/dotfiles/backup/TIMESTAMP/`
- Update logs: `~/dotfiles/Upgrade-Logs/`

**Development Tools:**

- Rust: `~/.cargo/` and `~/.rustup/` (not backed up)
- UV: `~/.local/share/uv/` (not backed up)

---

## 🎯 Quick Reference

### First-Time Setup

```bash
# 1. Install JaKooLit's Hyprland
git clone --depth=1 https://github.com/JaKooLit/Fedora-Hyprland.git
cd Fedora-Hyprland && ./install.sh && sudo reboot

# 2. Install your dotfiles
git clone git@github.com:LoicPil/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh

# 3. Install development tools (optional)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Daily Usage

```bash
# Update from Waybar button → Click update button
# OR manually:
cd ~/Hyprland-Dots && git pull
~/.config/hypr/UserScripts/upgrade-custom.sh

# Then commit changes:
cd ~/dotfiles && git status && git add . && git commit -m "Update" && git push
```

### Development

```bash
# Python project
cd ~/projects && uv init my-project && cd my-project
uv add requests && uv run python script.py

# Rust project
cd ~/projects && cargo new my-app && cd my-app
cargo run
```

### Maintenance

```bash
# Update package lists
cd ~/dotfiles && ./update-packages.sh

# Reinstall dotfiles
cd ~/dotfiles && ./uninstall.sh && ./install.sh

# Restore from backup
cp -r ~/dotfiles/backup/TIMESTAMP/config ~/dotfiles/

# Update development tools
rustup update  # Update Rust
```

---

**Keep your dotfiles safe and your system consistent!** 🎉
