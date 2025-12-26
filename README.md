# Dotfiles

This repository contains my configuration files (dotfiles) for various tools and environments, including Zsh, Neovim, Hyprland, Kitty, Rofi, and more.

---

## Installation

To clone this repository and apply the configurations:

```bash
# Clone the repository
git clone git@github.com:LoicPil/dotfiles.git ~/.dotfiles

# Go into the folder
cd ~/.dotfiles

# Run the main installation script
./bootstrap_dotfiles.sh
```

### Bootstrap Scripts Explained

**bootstrap_dotfiles.sh** - Initial setup (run once on a new system)
- Copies your existing configs to `~/dotfiles/`
- Creates symlinks: `~/.config/hypr` → `~/dotfiles/hypr`
- Backs up originals with timestamp

**bootstrap_refresh.sh** - Update after external changes
- Use when you install updated configs (e.g., new JaKooLit Hyprland version)
- Detects new real directories in `~/.config/`
- Backs up old versions, copies new configs, recreates symlinks
- Run this after any external script that overwrites your configs

**bootstrap_refreshALL.sh** - Backup all configs
- Creates dated backups of all dotfiles
- Use before system updates or major experiments

**Workflow after updating configs externally:**
```bash
# After JaKooLit (or similar) installs new configs
cd ~/dotfiles
./bootstrap_refresh.sh
git status  # See what changed
git add .
git commit -m "Update Hyprland to new version"
git push
```

**Note:** When you manually edit configs, changes are automatic (via symlinks). Only use refresh scripts when external installers create new directories.

---

## Package Management

### Backup Installed Packages

To update your package list with currently installed packages:

```bash
cd ~/dotfiles
dnf repoquery --userinstalled --qf "%{name}" | sort > packages.txt
git add packages.txt
git commit -m "Update package list"
git push origin main
```

### Restore Packages on a New System

After setting up a fresh Fedora installation and cloning this repository:

```bash
# Install all packages from the list
sudo dnf install $(cat ~/dotfiles/packages.txt)

# Or if you encounter issues, install one by one:
cat ~/dotfiles/packages.txt | xargs sudo dnf install -y
```

**Note:** Some package names may differ between Fedora versions. If a package fails to install, you can search for its replacement:

```bash
dnf search <package-name>
```

---

## Connecting to GitHub with an SSH Key

### 1. Check existing SSH keys

```bash
ls -al ~/.ssh
```

If you see a file like `id_rsa.pub` or `id_ed25519.pub`, you already have an SSH key.

### 2. Generate a new SSH key

```bash
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
```

* Press **Enter** to accept the default location (`~/.ssh/id_rsa`).
* Set a strong passphrase to protect the key.

### 3. Add the SSH key to the SSH agent

The SSH agent keeps your private keys in memory, so you don't have to type your passphrase every time you push.

```bash
# Start the SSH agent
eval "$(ssh-agent -s)"

# Add your private key to the agent
ssh-add ~/.ssh/id_ed25519  # or ~/.ssh/id_rsa if using RSA
```

⚠️ Verify the key is loaded:

```bash
ssh-add -l
```

### 4. Add the SSH key to GitHub

```bash
cat ~/.ssh/id_rsa.pub
```

* Copy the output and go to [GitHub SSH Keys](https://github.com/settings/keys)
* Click **New SSH Key**
* Paste the public key and save.

### 5. Test the connection

```bash
ssh -T git@github.com
```

You should see a message like:

```
Hi LoicPil! You've successfully authenticated, but GitHub does not provide shell access.
```

### 6. Automatically Load SSH Agent at Startup

To load your SSH key(s) automatically when opening a terminal, add the following to your `~/.zshrc` or `~/.bashrc`:

```bash
# Start SSH agent if not already running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

# Add your SSH key(s)
ssh-add ~/.ssh/id_ed25519 2>/dev/null  # or ~/.ssh/id_rsa
```

### 7. Automatically Load Multiple SSH Keys

If you use multiple keys (e.g., one for GitHub, one for work), update your shell configuration with:

```bash
# Start SSH agent if not already running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

# Add multiple SSH keys
KEYS=(~/.ssh/id_ed25519 ~/.ssh/id_github_rsa)

for key in "${KEYS[@]}"; do
    if [ -f "$key" ]; then
        ssh-add -q "$key" 2>/dev/null
    fi
done
```

* Replace the paths with the actual private keys you use.
* `ssh-add -q` adds the keys quietly; errors are suppressed if a key is already added.

Verify loaded keys with:

```bash
ssh-add -l
```

---

## Using Git

```bash
# Add modified files
git add .

# Commit changes
git commit -m "Update dotfiles"

# Push to GitHub
git push origin main
```

---

## Repository Structure

```
backup/        # Previous configuration backups
btop/          # btop configuration
emacs/         # Emacs configs
git/           # Git configuration
hypr/          # Hyprland configs
hypr-back/     # Hyprland backups
kitty/         # Kitty terminal configs
nvim/          # Neovim configs
oh-my-zsh/     # Oh My Zsh configuration
rofi/          # Rofi launcher configs
ssh/           # SSH configuration
swaync/        # Swaync notification configs
vim/           # Vim configs
wallust/       # Wallpaper and color scheme configs
waybar/        # Waybar configs
wlogout/       # Wlogout logout menu configs
zsh/           # Zsh configs
zsh-backup/    # Zsh backup
packages.txt   # List of installed Fedora packages
```

---

**Note:** Always keep a secure backup of your private keys and passphrases. 😉
