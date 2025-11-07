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

You can also use the refresh scripts to update specific configurations:

```bash
# Update specific dotfiles
./bootstrap_refresh.sh

# Update all dotfiles
./bootstrap_refreshALL.sh
```

---

## Connecting to GitHub with an SSH Key

### 1. Check existing SSH keys

```bash
ls -al ~/.ssh
```

If you see a file like `id_rsa.pub`, you already have an SSH key.

### 2. Generate a new SSH key

```bash
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
```

* Press **Enter** to accept the default location (`~/.ssh/id_rsa`).
* Set a strong passphrase to protect the key.

### 3. Add the SSH key to the SSH agent

The SSH agent keeps your private keys in memory, so you don’t have to type your passphrase every time you push.

```bash
# Start the SSH agent
eval "$(ssh-agent -s)"

# Add your private key to the agent
ssh-add ~/.ssh/id_rsa
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
ssh-add ~/.ssh/id_rsa
```

### 7. Automatically Load Multiple SSH Keys

If you use multiple keys (e.g., one for GitHub, one for work), update your shell configuration with:

```bash
# Start SSH agent if not already running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

# Add multiple SSH keys
KEYS=(~/.ssh/id_rsa ~/.ssh/id_ed25519 ~/.ssh/work_id_rsa)

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
kitty/         # Kitty configs
nvim/          # Neovim configs
oh-my-zsh/     # Oh My Zsh configuration
rofi/          # Rofi configs
swaync/        # Swaync configs
vim/           # Vim configs
wallust/       # Wallpapers
waybar/        # Waybar configs
wlogout/       # Wlogout configs
zsh/           # Zsh configs
zsh-backup/    # Zsh backup
zshrc.bak      # Backup of .zshrc
```

---

**Note:** Always keep a secure backup of your private keys and passphrases. 😉
