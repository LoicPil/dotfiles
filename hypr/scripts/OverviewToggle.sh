#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
# Overview toggle wrapper - tries Quickshell first, AGS2, then falls back to Rofi

set -euo pipefail

# 1) Try Quickshell via Hyprland global dispatch
if pgrep -x quickshell >/dev/null 2>&1; then
  if hyprctl dispatch global quickshell:overviewToggle >/dev/null 2>&1; then
    exit 0
  fi
fi

# If QS isn't running, but the CLI exists, try starting it
if command -v qs >/dev/null 2>&1; then
  qs >/dev/null 2>&1 &
  sleep 0.6
  if hyprctl dispatch global quickshell:overviewToggle >/dev/null 2>&1; then
    exit 0
  fi
fi

# 2) Try AGS2 (aylurs-gtk-shell2)
# AGS2 uses a different architecture - check if it's configured
if command -v ags >/dev/null 2>&1; then
  AGS_VERSION=$(ags --version 2>/dev/null | grep -oP '\d+\.\d+' | head -1)
  if [[ "${AGS_VERSION%%.*}" -ge 2 ]]; then
    # AGS2 detected - would need custom configuration
    # For now, skip to Rofi
    :
  else
    # AGS1 - use old method
    pkill rofi || true
    if ags -t 'overview' >/dev/null 2>&1; then
      exit 0
    fi
    ags >/dev/null 2>&1 &
    sleep 0.6
    if ags -t 'overview' >/dev/null 2>&1; then
      exit 0
    fi
  fi
fi

# 3) Fallback to Rofi window switcher
if command -v rofi >/dev/null 2>&1; then
  pkill rofi || rofi -show window
  exit 0
fi

# If nothing worked
notify-send "Overview" "No overview tool available (Quickshell, AGS, or Rofi)" -u low 2>/dev/null || true
exit 1
