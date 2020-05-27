#!/usr/bin/env bash
set -e # Exit immediately if SHTF
####
#
# Usage: @todo
#
# Environment Variables
#   PMS         = path to PMS repository
#   PMS_DEBUG   = 1 = enabled, 0 = disabled
#   PMS_REPO    = default: JoshuaEstes/pms
#   PMS_REMOTE  = default: https://github.com/$PMS_REPO.git
#   PMS_BRANCH  = master
#
PMS=${PMS:-~/.pms}
PMS_DEBUG=${PMS_DEBUG:-1}
PMS_REPO=${PMS_REPO:-JoshuaEstes/pms}
PMS_REMOTE=${PMS_REMOTE:-https://github.com/${PMS_REPO}.git}
PMS_BRANCH=${PMS_BRANCH:-master}

# Setup PMS
#   This will basically clone the repo into a directory that we can manage up
#   update later
setup_pms() {
  # @todo check requirements (git, etc.)
  echo "Setting up PMS..."

  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo
    echo "-=[ Debug ]=-"
    echo "PMS:         $PMS"
    echo "PMS_DEBUG:   $PMS_DEBUG"
    echo "PMS_REPO:    $PMS_REPO"
    echo "PMS_REMOTE:  $PMS_REMOTE"
    echo "PMS_BRANCH:  $PMS_BRANCH"
    echo "-=[ Debug ]=-"
    echo
  fi

  if [ -d $PMS ]; then
    echo "$PMS already exists, should we update instead of install? Or should we blow it away and re-install?"
    exit 1
  else
    git clone --branch "$PMS_BRANCH" "$PMS_REMOTE" "$PMS"
  fi

  # Copy over config files if they do not currently exist
  if [ ! -f ~/.env ]; then
    cp $PMS/templates/env ~/.env
  fi
  if [ ! -f ~/.pms.theme ]; then
    cp $PMS/templates/pms.theme ~/.pms.theme
  fi
  if [ ! -f ~/.pms.plugins ]; then
    cp $PMS/templates/pms.plugins ~/.pms.plugins
  fi

  echo
}

# bashrc
setup_bashrc() {
 # if file or link
 if [ -f ~/.bashrc ] || [ -h ~/.bashrc ]; then
   echo "Found existing .bashrc file, backing up"
   # @todo make this better
   if [ ! -f ~/.bashrc.pms.bak ]; then
     mv -f ~/.bashrc ~/.bashrc.pms.bak
   fi
 fi
 cp -f $PMS/templates/bashrc ~/.bashrc
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
      exec bash
    ;;
    "/bin/zsh" )
      exec zsh
    ;;
  esac
}

main "$@"
