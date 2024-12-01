# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Charger Powerlevel10k sans utiliser ZSH_THEME
source ~/dotfiles/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme


## Options section
setopt CORRECT                                                  # Auto correct mistakes
setopt EXTENDED_GLOB                                            # Extended globbing. Allows using regular expressions with *
setopt NO_CASE_GLOB                                             # Case insensitive globbing
setopt RC_EXPAND_PARAM                                          # Array expension with parameters
setopt NO_CHECK_JOBS                                            # Don't warn about running processes when exiting
setopt NUMERIC_GLOB_SORT                                        # Sort filenames numerically when it makes sense
setopt NO_BEEP                                                  # No beep
setopt APPEND_HISTORY                                           # Immediately append history instead of overwriting
setopt HIST_IGNORE_ALL_DUPS                                     # If a new command is a duplicate, remove the older one
setopt AUTO_CD                                                  # if only directory path is entered, cd there.

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500
export EDITOR=/usr/bin/vim
#export VISUAL=/usr/bin/gvim
WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word
zstyle ':completion:*' rehash true  

# Theming section  
autoload -U compinit colors zcalc
compinit -d
colors

# enable substitution for prompt
setopt prompt_subst

#Alias section
alias vim=nvim
alias dotfiles='git --git-dir=$HOME/.config/dotfiles --work-tree=$HOME'
alias tree='tree -L 2'
# Prompt (on left side) similar to default bash prompt, or redhat zsh prompt with colors
 #PROMPT="%(!.%{$fg[red]%}[%n@%m %1~]%{$reset_color%}# .%{$fg[green]%}[%n@%m %1~]%{$reset_color%}$ "
# Maia prompt
PROMPT="%B%{$fg[cyan]%}%(4~|%-1~/.../%2~|%~)%u%b >%{$fg[cyan]%}>%B%(?.%{$fg[cyan]%}.%{$fg[red]%})>%{$reset_color%}%b " # Print some system information when the shell is first started
# Print a greeting message when shell is started
echo $USER@$HOST  $(uname -srm) $(source /etc/os-release && echo "$BUILD_ID")
## Prompt on right side:
#  - shows status of git when in git repository (code adapted from https://techanic.net/2012/12/30/my_git_prompt_for_zsh.html)
#  - shows exit status of previous command (if previous command finished with an error)
#  - is invisible, if neither is the case

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"                              # plus/minus     - clean repo
GIT_PROMPT_PREFIX="%{$fg[green]%}[%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"             # A"NUM"         - ahead by "NUM" commits
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"           # B"NUM"         - behind by "NUM" commits
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"     # lightning bolt - merge conflict
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}●%{$reset_color%}"       # red circle     - untracked files
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}●%{$reset_color%}"     # yellow circle  - tracked files modified
GIT_PROMPT_STAGED="%{$fg_bold[green]%}●%{$reset_color%}"        # green circle   - staged changes present = ready for "git push"

# Fonction pour activer/désactiver le flou
toggle_blur() {
    # Vérifier si le terminal parent est GNOME Terminal
    local parent_terminal=$(ps --no-header -p $PPID -o comm)

    if [[ $parent_terminal == "gnome-terminal-server"|| $parent_terminal=="zsh" ]]; then
        echo "Terminal parent détecté : $parent_terminal"

        # On suppose ici que le flou peut être activé ou désactivé via un outil comme gsettings
        # Vérifier l'état actuel du flou
        current_blur=$(gsettings get org.gnome.desktop.background blur-enabled)

        if [[ "$current_blur" == "true" ]]; then
            # Si le flou est déjà activé, le désactiver
            echo "Désactivation du flou"
            gsettings set org.gnome.desktop.background blur-enabled false
        else
            # Si le flou est désactivé, l'activer
            echo "Activation du flou"
            gsettings set org.gnome.desktop.background blur-enabled true
        fi
    else
        echo "Le terminal parent n'est pas GNOME Terminal, terminal détecté : $parent_terminal"
    fi
}


# Alias pour une commande qui active/désactive le flou
alias blur="toggle_blur"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
