#!/usr/bin/env sh
####
#
# Uninstall Script
#
# 1) Revert Files (ie ~/.bashrc) (confirm with user)
# 2) Delete PMS Config Files (confirm with user)
# 3) Delete PMS directory (confirm with user)
#

# Confirm with user they really want to uninstall PMS
read -r -p "Are you sure you want to uninstall PMS? [y/N] " confirm
if [ "$confirm" != "y" ] && [ "$config" != "Y" ]; then
  echo "Canceled"
  exit
fi

# Revert rc files (user confirmation)
if [ -f ~/.bashrc.pms.bak ] && [ -f ~/.bashrc ]; then
  read -r -p "Restore your ~/.bashrc with the backup ~/.bashrc.pms.bak? [Y/n] " confirm
  if [ "$confirm" != "n" ] && [ "$config" != "N" ]; then
    mv ~/.bashrc.pms.bak ~/.bashrc
  fi
fi

# Delete PMS Config files
rm -fv ~/.pms.theme
rm -fv ~/.pms.plugins

# Delete .env (user confirmation)
if [ -f ~/.env ]; then
  read -r -p "Would you like to delete ~/.env file? [Y/n] " confirm
  if [ "$confirm" != "n" ] && [ "$config" != "N" ]; then
    rm -fv ~/.env
  fi
fi

# Delete $PMS directory
rm -rf ~/.pms

echo "PMS has been uninstalled. You should restart your terminal"
