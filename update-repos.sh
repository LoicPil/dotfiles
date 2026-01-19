#!/bin/bash
# Update Repository Lists Script
# This script saves ALL active DNF repositories to repos.txt

DOTFILES_DIR="$HOME/dotfiles"
REPOS_FILE="$DOTFILES_DIR/repos.txt"
REPOS_BACKUP_DIR="$DOTFILES_DIR/repo-configs"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Scanning all enabled repositories...${NC}"
echo -e "${BLUE}========================================${NC}"

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
  echo -e "${RED}Error: $DOTFILES_DIR directory not found${NC}"
  exit 1
fi

# Create backup directory for .repo files
mkdir -p "$REPOS_BACKUP_DIR"

# Create repos file with header
cat >"$REPOS_FILE" <<'EOF'
# DNF Repositories Configuration
# Generated automatically by update-repos.sh
# 
# This file contains commands to restore ALL repositories
# detected on your system at the time of generation.
#
# USAGE:
#   On a fresh system: cd ~/dotfiles && ./setup-repos.sh
#   Or copy-paste the commands below manually
#
EOF

echo "# Generated on: $(date)" >>"$REPOS_FILE"
echo "# Hostname: $(hostname)" >>"$REPOS_FILE"
echo "# Fedora version: $(rpm -E %fedora)" >>"$REPOS_FILE"
echo "" >>"$REPOS_FILE"

# Get list of all enabled repos (excluding default Fedora repos)
echo -e "${YELLOW}→ Analyzing repositories...${NC}"

# Default Fedora repos to skip
SKIP_REPOS=(
  "fedora"
  "fedora-cisco-openh264"
  "fedora-modular"
  "updates"
  "updates-modular"
  "updates-testing"
  "updates-testing-modular"
)

# Function to check if repo should be skipped
should_skip() {
  local repo="$1"
  for skip in "${SKIP_REPOS[@]}"; do
    if [[ "$repo" == "$skip" ]]; then
      return 0
    fi
  done
  return 1
}

# Arrays to store different repo types
declare -a RPM_FUSION_REPOS
declare -a COPR_REPOS
declare -a THIRD_PARTY_REPOS

# Parse all enabled repositories
while IFS= read -r line; do
  # Extract repo ID (first column)
  repo_id=$(echo "$line" | awk '{print $1}')

  # Skip empty lines and default Fedora repos
  [[ -z "$repo_id" ]] && continue
  should_skip "$repo_id" && continue

  # Categorize repositories
  if [[ "$repo_id" =~ ^rpmfusion ]]; then
    RPM_FUSION_REPOS+=("$repo_id")
  elif [[ "$repo_id" =~ ^copr: ]] || [[ "$repo_id" =~ ^coprdep: ]]; then
    COPR_REPOS+=("$repo_id")
  else
    THIRD_PARTY_REPOS+=("$repo_id")
  fi
done < <(dnf repolist --enabled 2>/dev/null | tail -n +2)

# ============================================
# RPM FUSION
# ============================================
if [ ${#RPM_FUSION_REPOS[@]} -gt 0 ]; then
  echo -e "${YELLOW}→ Found RPM Fusion repositories${NC}"
  cat >>"$REPOS_FILE" <<'EOF'
# ============================================
# RPM Fusion (Free & Nonfree)
# ============================================
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

EOF

  # Check for optional RPM Fusion repos
  for repo in "${RPM_FUSION_REPOS[@]}"; do
    if [[ "$repo" == "rpmfusion-nonfree-steam" ]]; then
      echo "sudo dnf config-manager --set-enabled rpmfusion-nonfree-steam" >>"$REPOS_FILE"
    elif [[ "$repo" == "rpmfusion-nonfree-nvidia-driver" ]]; then
      echo "sudo dnf config-manager --set-enabled rpmfusion-nonfree-nvidia-driver" >>"$REPOS_FILE"
    fi
  done
  echo "" >>"$REPOS_FILE"
fi

# ============================================
# COPR REPOSITORIES
# ============================================
if [ ${#COPR_REPOS[@]} -gt 0 ]; then
  echo -e "${YELLOW}→ Found COPR repositories${NC}"
  echo "# ============================================" >>"$REPOS_FILE"
  echo "# COPR Repositories" >>"$REPOS_FILE"
  echo "# ============================================" >>"$REPOS_FILE"

  # Extract unique COPR repos (skip coprdep which are dependencies)
  declare -A COPR_UNIQUE
  for repo in "${COPR_REPOS[@]}"; do
    if [[ "$repo" =~ ^copr:copr\.fedorainfracloud\.org:([^:]+):([^:]+) ]]; then
      owner="${BASH_REMATCH[1]}"
      project="${BASH_REMATCH[2]}"
      COPR_UNIQUE["${owner}/${project}"]=1
    fi
  done

  # Write COPR enable commands
  for copr in "${!COPR_UNIQUE[@]}"; do
    echo "sudo dnf copr enable $copr -y" >>"$REPOS_FILE"
    echo -e "  ${GREEN}✓${NC} $copr"
  done
  echo "" >>"$REPOS_FILE"
fi

# ============================================
# THIRD-PARTY REPOSITORIES
# ============================================
if [ ${#THIRD_PARTY_REPOS[@]} -gt 0 ]; then
  echo -e "${YELLOW}→ Found third-party repositories${NC}"
  echo "# ============================================" >>"$REPOS_FILE"
  echo "# Third-Party Repositories" >>"$REPOS_FILE"
  echo "# ============================================" >>"$REPOS_FILE"
  echo "" >>"$REPOS_FILE"

  for repo in "${THIRD_PARTY_REPOS[@]}"; do
    echo -e "  ${GREEN}✓${NC} $repo"

    # Try to find the .repo file
    repo_file=""

    # Common locations for repo files
    for location in /etc/yum.repos.d/*.repo; do
      if grep -q "^\[${repo}\]" "$location" 2>/dev/null; then
        repo_file="$location"
        break
      fi
    done

    if [ -n "$repo_file" ]; then
      # Backup the .repo file
      cp "$repo_file" "$REPOS_BACKUP_DIR/"

      # Detect known repos and provide setup commands
      case "$repo" in
      code | vscode)
        cat >>"$REPOS_FILE" <<'EOF'
## Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

EOF
        ;;
      google-chrome)
        cat >>"$REPOS_FILE" <<'EOF'
## Google Chrome
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome

EOF
        ;;
      opera)
        cat >>"$REPOS_FILE" <<'EOF'
## Opera Browser
sudo rpm --import https://rpm.opera.com/rpmrepo.key
sudo sh -c 'echo -e "[opera]\nname=Opera packages\nbaseurl=https://rpm.opera.com/rpm\nenabled=1\ngpgcheck=1\ngpgkey=https://rpm.opera.com/rpmrepo.key" > /etc/yum.repos.d/opera.repo'

EOF
        ;;
      beid-release | eid.belgium.be)
        cat >>"$REPOS_FILE" <<'EOF'
## Belgian eID
sudo sh -c 'echo -e "[eid.belgium.be]\nname=Belgian eID package archive\nbaseurl=https://eid.belgium.be/sites/default/files/software/$basearch\nenabled=1\ngpgcheck=1\ngpgkey=https://eid.belgium.be/sites/default/files/software/eid.belgium.be.asc" > /etc/yum.repos.d/eid.belgium.be.repo'

EOF
        ;;
      docker-ce-stable)
        cat >>"$REPOS_FILE" <<'EOF'
## Docker CE
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

EOF
        ;;
      brave-browser)
        cat >>"$REPOS_FILE" <<'EOF'
## Brave Browser
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

EOF
        ;;
      *)
        # Unknown repo - provide manual instructions
        echo "## ${repo}" >>"$REPOS_FILE"
        echo "# Manual setup required!" >>"$REPOS_FILE"
        echo "# Repository file backed up to: repo-configs/$(basename $repo_file)" >>"$REPOS_FILE"
        echo "# To restore: sudo cp ~/dotfiles/repo-configs/$(basename $repo_file) /etc/yum.repos.d/" >>"$REPOS_FILE"
        echo "" >>"$REPOS_FILE"
        ;;
      esac
    else
      # No .repo file found
      echo "## ${repo}" >>"$REPOS_FILE"
      echo "# WARNING: Could not find repository file!" >>"$REPOS_FILE"
      echo "# You may need to set this up manually." >>"$REPOS_FILE"
      echo "" >>"$REPOS_FILE"
    fi
  done
fi

# Add footer
cat >>"$REPOS_FILE" <<'EOF'

# ===================================================
# RESTORE INSTRUCTIONS
# ===================================================
# 
# Quick restore (recommended):
#   cd ~/dotfiles && ./setup-repos.sh
#
# Manual restore:
#   Copy and paste the commands above
#
# Backed up .repo files:
#   Check ~/dotfiles/repo-configs/ for manual repos
#
# ===================================================
EOF

# Summary
echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Repository scan complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "${BLUE}Summary:${NC}"
echo -e "  RPM Fusion repos: ${GREEN}${#RPM_FUSION_REPOS[@]}${NC}"
echo -e "  COPR repos: ${GREEN}${#COPR_UNIQUE[@]}${NC}"
echo -e "  Third-party repos: ${GREEN}${#THIRD_PARTY_REPOS[@]}${NC}"
echo ""
echo -e "${BLUE}Files created:${NC}"
echo -e "  ${GREEN}✓${NC} $REPOS_FILE"
[ "$(ls -A $REPOS_BACKUP_DIR 2>/dev/null)" ] && echo -e "  ${GREEN}✓${NC} $REPOS_BACKUP_DIR/ (backup .repo files)"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Review: cat $REPOS_FILE"
echo "  2. Commit: git add repos.txt repo-configs/ && git commit -m 'Update repos'"
echo "  3. Push: git push"
