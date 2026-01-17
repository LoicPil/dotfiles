# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# ===================================
# PATH Configuration
# ===================================
# Local binaries (pipx, UV, custom scripts)
export PATH="$HOME/.local/bin:$PATH"

# ===================================
# Oh My Zsh Configuration
# ===================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnosterzak"

plugins=( 
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
    sudo              # Appuie 2x sur ESC pour ajouter sudo
    command-not-found # Suggère le package à installer
    colored-man-pages # Pages man colorées
    extract           # Extrait n'importe quelle archive avec "extract <file>"
    z                 # Jump rapide vers des dossiers fréquents
    fzf               # Intégration FZF améliorée
)

source $ZSH/oh-my-zsh.sh

# ===================================
# Startup Display
# ===================================
# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
#pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch. Will be disabled if above colorscript was chosen to install
fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# ===================================
# FZF Configuration
# ===================================
# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

# ===================================
# History Configuration
# ===================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# ===================================
# Aliases - Files & Directories
# ===================================
# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# ===================================
# Aliases - Navigation
# ===================================
# Personal alias
alias cours='cd ~/Documents/University/Year3/Courses'
alias dotfiles='cd ~/dotfiles'

# ===================================
# Aliases - Git
# ===================================
alias gitst='git status'
alias gitsts='git status -s'
alias gitch='git checkout'
alias gitlog='git log --oneline --graph --decorate'
alias gitd='git diff'
alias gitpush='git push'
alias gitpull='git pull'

# ===================================
# Aliases - Development
# ===================================
# Editor
alias vim=nvim

# Python/UV
alias py='python3'
alias uvrun='uv run'
alias uvinit='uv init'

# Sqlite3
alias sqlite3='sqlite3 -cmd ".headers on" -cmd ".mode column"'

# ===================================
# Aliases - System
# ===================================
alias update='sudo dnf update && flatpak update'
alias settings='gnome-control-center'

# Dotfiles management
alias dotupdate='cd ~/dotfiles && ./update-packages.sh'

# VPN 
alias vpnup='sudo wg-quick up ~/wireguard/client-loicvpn.conf'
alias vpndown='sudo wg-quick down ~/wireguard/client-loicvpn.conf'

# ===================================
# Development Tools
# ===================================
# Rust/Cargo
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# UV Python package manager is available via ~/.local/bin (already in PATH)
