#!/usr/bin/env sh
set -e # Exit immediately if SHTF
####
#
# Usage: @todo
#
# Environment Variables
#   PMS = path to pms repository
#
PMS=${PMS:-~/.pms}
REPO=https://github.com/JoshuaEstes/pms.git

# Setup PMS
#   This will basically clone the repo into a directory that we can manage up
#   update later
setup_pms() {
  echo 'Setting up PMS'
  git clone "$REPO" "$PMS"
}

# Setup dotfiles
#   Setup various dotfiles and config files that PMS will use. Some dotfiles
#   may get modified later by plugins. Any dotfile that we find, needs to be
#   backed up so that the uninstall script can put everything back the way
#   we found it
setup_dotfiles() {
  echo 'Setting up dotfiles'
}

# Setup shell
#   The user should be allowed to keep their current shell, or have the option
#   to change that shell to another.
setup_shell() {
  echo 'Setting up shell'
}

# Main function, this will be called to install everything
main() {
  setup_pms
  setup_dotfiles
  setup_shell

  # @todo make this better and more informative for users
  echo 'PMS has been installed, please view documentation'
}

main "$@"
