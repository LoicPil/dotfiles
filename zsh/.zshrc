# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below this.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Export language settings
# These environment variables are used to set the language and locale for your shell.
# LANG: Defines the language settings for messages, UI text, etc.
# LC_ALL: Overrides all other locale settings to ensure uniform behavior across the system.
export LANG=en_GB.UTF-8    # Language set to English (United Kingdom)
export LC_ALL=en_GB.UTF-8  # Enforce the use of UK English locale for all processes

# Powerlevel10k configuration: Load Powerlevel10k theme without using ZSH_THEME
source ~/dotfiles/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme

# Disable Powerlevel10k's instant prompt warning
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

## Options section
setopt CORRECT                                                  # Auto correct mistakes
setopt EXTENDED_GLOB                                            # Extended globbing. Allows using regular expressions with *
setopt NO_CASE_GLOB                                             # Case insensitive globbing
setopt RC_EXPAND_PARAM                                          # Array expansion with parameters
setopt NO_CHECK_JOBS                                            # Don't warn about running processes when exiting
setopt NUMERIC_GLOB_SORT                                        # Sort filenames numerically when it makes sense
setopt NO_BEEP                                                  # No beep
setopt APPEND_HISTORY                                           # Immediately append history instead of overwriting
setopt HIST_IGNORE_ALL_DUPS                                     # If a new command is a duplicate, remove the older one
setopt AUTO_CD                                                  # If only directory path is entered, cd there.

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500
export EDITOR=/bin/usr/emacs   # Default text editor (emacs)
#export VISUAL=/usr/bin/gvim

# Word characters: Do not consider certain characters as part of the word
WORDCHARS=${WORDCHARS//\/[&.;]} 

zstyle ':completion:*' rehash true  

# Theming section  
autoload -U compinit colors zcalc
compinit -d
colors

# Enable prompt substitution
setopt prompt_subst

# Alias section
alias vim=nvim
alias dotfiles='git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME'
alias tree='tree -L 2'
alias py='python3'
alias cours='cd ~/Documents/Bac2Math/cours'

# Maia prompt
PROMPT="%B%{$fg[cyan]%}%(4~|%-1~/.../%2~|%~)%u%b >%{$fg[cyan]%}>%B%(?.%{$fg[cyan]%}.%{$fg[red]%})>%{$reset_color%}%b " 

# Git prompt (show status of git repository)
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"                              # plus/minus     - clean repo
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"             # A"NUM"         - ahead by "NUM" commits
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"           # B"NUM"         - behind by "NUM" commits
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"     # lightning bolt - merge conflict
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"       # red circle     - untracked files
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"     # yellow circle  - tracked files modified
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"        # green circle   - staged changes present = ready for "git push"

# Function to toggle blur effect on GNOME Terminal
toggle_blur() {
    # Récupérer la valeur actuelle des pipelines
    current_pipelines=$(gsettings get org.gnome.shell.extensions.blur-my-shell pipelines)

    # Désactivation du flou
    if [[ "$current_pipelines" == *"radius"* && "$current_pipelines" == *"30"* ]]; then
        echo "Désactivation du flou"
        # Formatage correct pour désactiver le flou
        gsettings set org.gnome.shell.extensions.blur-my-shell pipelines "[{'name': 'Default', 'effects': [{'type': 'native_static_gaussian_blur', 'id': 'effect_000000000000', 'params': {'radius': 0, 'brightness': 0.6}}]}]"
    else
        echo "Activation du flou"
        # Formatage correct pour activer le flou avec rayon 30
        gsettings set org.gnome.shell.extensions.blur-my-shell pipelines "[{'name': 'Default', 'effects': [{'type': 'native_static_gaussian_blur', 'id': 'effect_000000000000', 'params': {'radius': 30, 'brightness': 0.6}}]}]"
    fi
}






# Alias to toggle blur
alias blur="toggle_blur"

# Print a greeting message when shell is started
echo $USER@$HOST  $(uname -srm) $(source /etc/os-release && echo "$BUILD_ID")

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load custom environment variables
. "$HOME/.local/bin/env"

