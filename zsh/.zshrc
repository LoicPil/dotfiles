# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnosterzak"

plugins=( 
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# check the dnf plugins commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dnf


# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# fastfetch. Will be disabled if above colorscript was chosen to install
#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
# Personal alias
alias cours='cd ~/Documents/Bac2Math/cours'
  #Git alias
alias gitst='git status'
alias gitsts='git status -s'
alias gitch='git checkout'
alias vim=nvim
alias update='sudo dnf update'
alias settings='gnome-control-center'
  # Sqlite3 alias 
alias sqlite3='sqlite3 -cmd ".headers on" -cmd ".mode column"'
#BAckup command and module 
backup() {
  if [[ "$1" == "raspberry" ]]; then
    rsync -avz --delete --progress --append-verify --delete-excluded \
      --exclude='backup-fedora-piletteloic' \
      --exclude='Elegant-grub2-themes' \
      --exclude='Fedora-Hyprland' \
      --exclude='.cache' \
      --exclude='.local/share/Trash' \
      --exclude='node_modules' \
      --exclude='.gvfs' \
      --exclude='.Trash-*' \
      --exclude='.mozilla/firefox/*/cache2/' \
      --exclude='.mozilla/firefox/*/cache2/*' \
      --exclude='.mozilla/firefox/*/storage/default/https+++*' \
      /home/piletteloic/ piletteloic@raspberrypiNas.local:/srv/dev-disk-by-uuid-b3490c84-bc7f-4788-a622-2e14d728d2be/backupLoic/ 2> ~/rsync_errors.log
  else
    echo "Usage: backup raspberry"
  fi
}



