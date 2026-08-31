#if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
#       Hyprland 
#fi

# Created by `pipx` on 2026-01-17 14:51:22
export PATH="$PATH:/home/piletteloic/.local/bin"

# Source /etc/profile to ensure system paths (e.g. flatpak) are available
if [ -f /etc/profile ]; then
    source /etc/profile
fi
