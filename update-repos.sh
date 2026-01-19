#!/bin/bash
# Update Repository Lists Script
# This script saves all active DNF repositories to repos.txt

DOTFILES_DIR="$HOME/dotfiles"
REPOS_FILE="$DOTFILES_DIR/repos.txt"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Saving repository configuration...${NC}"

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
  echo -e "${RED}Error: $DOTFILES_DIR directory not found${NC}"
  exit 1
fi

# Save enabled repositories
echo "# DNF Repositories - Generated $(date)" >"$REPOS_FILE"
echo "# To restore: Copy commands below and run them" >>"$REPOS_FILE"
echo "" >>"$REPOS_FILE"

# Get all enabled repos
dnf repolist --enabled -v 2>/dev/null | grep "Repo-id" | awk '{print $3}' | while read repo; do
  # Try to identify the repo type and provide restore command
  case "$repo" in
  copr:*)
    # Extract copr owner and project
    copr_name=$(echo "$repo" | sed 's/copr:copr.fedorainfracloud.org:\([^:]*\):\([^:]*\).*/\1\/\2/')
    echo "sudo dnf copr enable $copr_name -y" >>"$REPOS_FILE"
    ;;
  rpmfusion-*)
    echo "# RPM Fusion: Install rpmfusion-free-release and rpmfusion-nonfree-release" >>"$REPOS_FILE"
    ;;
  google-chrome)
    echo "# Google Chrome: https://dl.google.com/linux/linux_signing_key.pub" >>"$REPOS_FILE"
    ;;
  code | vscode)
    echo "# VSCode: https://packages.microsoft.com/keys/microsoft.asc" >>"$REPOS_FILE"
    ;;
  opera*)
    echo "# Opera: https://rpm.opera.com/rpm/opera-stable.repo" >>"$REPOS_FILE"
    ;;
  eid.belgium.be)
    echo "# Belgian eID: https://eid.belgium.be/sites/default/files/software/eid.belgium.be.asc" >>"$REPOS_FILE"
    ;;
  *)
    echo "# $repo (manual setup may be required)" >>"$REPOS_FILE"
    ;;
  esac
done

echo -e "${GREEN}✓ Repository list saved to $REPOS_FILE${NC}"
echo -e "${BLUE}Review the file and add manual setup instructions as needed${NC}"
