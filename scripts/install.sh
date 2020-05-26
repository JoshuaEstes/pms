#!/usr/bin/env bash
set -e # Exit immediately if SHTF
####
#
# Usage: @todo
#
# Environment Variables
#   PMS = path to pms repository
#
#   @todo change repo url (in case code is stored on gitlab.com)
#   @todo change branch (master, develop, etc.)
#
PMS=${PMS:-~/.pms}
REPO=https://github.com/JoshuaEstes/pms.git

# Setup PMS
#   This will basically clone the repo into a directory that we can manage up
#   update later
setup_pms() {
  # @todo check requirements (git, etc.)
  echo "Setting up PMS..."
  if [ -d $PMS ]; then
    echo "$PMS already exists, should we update instead of install? Or should we blow it away and re-install?"
  else
    git clone "$REPO" "$PMS"
  fi
  echo
}

# bashrc
setup_bashrc() {
 # if file or link
 if [ -f $HOME/.bashrc ] || [ -h $HOME/.bashrc ]; then
   echo "Found existing .bashrc file, backing up"
   # @todo make this better
   if [ ! -f $HOME/.bashrc.bak ]; then
     mv -f $HOME/.bashrc $HOME/.bashrc.bak
   fi
 fi
 cp -f $PMS/templates/bashrc $HOME/.bashrc
 echo
}

# Setup dotfiles
#   Setup various dotfiles and config files that PMS will use. Some dotfiles
#   may get modified later by plugins. Any dotfile that we find, needs to be
#   backed up so that the uninstall script can put everything back the way
#   we found it
setup_dotfiles() {
  echo "Setting up dotfiles"
  setup_bashrc
  # @todo
  #setup_zshrc
}

# Setup shell
#   The user should be allowed to keep their current shell, or have the option
#   to change that shell to another.
setup_shell() {
  echo "Setting up shell"
  # @todo
  echo
}

# Main function, this will be called to install everything
main() {
  setup_pms
  setup_dotfiles
  setup_shell

  # @todo make this better and more informative for users
  echo "PMS has been installed, please view documentation"

  # @todo ask user?
  # @todo inform user of "pms" command?
  case "$SHELL" in
    "/bin/bash" | "/usr/bin/bash" )
      source $HOME/.bashrc
    ;;
    "/bin/zsh" )
      source $HOME/.zshrc
    ;;
  esac
}

# this will be used later
main "$@"
