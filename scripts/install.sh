#!/usr/bin/env sh
#
# Environment Variables
#   PMS         = path to PMS repository
#   PMS_DEBUG   = 1 = enabled, 0 = disabled
#   PMS_REPO    = default: JoshuaEstes/pms
#   PMS_REMOTE  = default: https://github.com/$PMS_REPO.git
#   PMS_BRANCH  = main
#
# @todo limit install to just one shell using PMS_SHELL?
#
set -e
PMS=${PMS:-~/.pms}
PMS_DEBUG=${PMS_DEBUG:-0}
PMS_REPO=${PMS_REPO:-JoshuaEstes/pms}
PMS_REMOTE=${PMS_REMOTE:-https://github.com/${PMS_REPO}.git}
PMS_BRANCH=${PMS_BRANCH:-main}

setup_pms() {
    echo "\r\n\t${BLUE}Cloning PMS...${RESET}\n\n"

    git clone --depth=1 --branch "$PMS_BRANCH" "$PMS_REMOTE" "$PMS" || {
        echo "${RED}ERROR: git clone command failed${RESET}"
        exit 1
    }

    # Copy over config files if they do not currently exist
    echo "${BLUE}Copying PMS Environment Variables file over, this file stores various PMS settings that can be modified${RESET}"
    cp -vfi $PMS/templates/env ~/.env

    echo "${BLUE}Copying PMS Theme Config File, this file is used to store your currently selected theme${RESET}"
    cp -vfi $PMS/templates/pms.theme ~/.pms.theme

    echo "${BLUE}Copying PMS Plugins Config File, this file contains all your enabled plugins${RESET}"
    cp -vfi $PMS/templates/pms.plugins ~/.pms.plugins
}

_setup_shell_rc() {
    # @todo better support
    if [ -f ~/.$1 ] || [ -h ~/.$1 ]; then
        echo "${YELLOW}Found existing .$1 file, backing up${RESET}"
        if [ ! -f ~/.$1.pms.bak ]; then
            echo "${YELLOW}Moving ~/.$1 -> ~/.$1.pms.bak${RESET}"
            mv -vfi ~/.$1 ~/.$1.pms.bak
        fi
    fi
    echo "${BLUE}Copy $PMS/templates/$1 -> ~/.$1 ${RESET}"
    cp -vf $PMS/templates/$1 ~/.$1
}

setup_rcfiles() {
    echo "\r\n\t${BLUE}Setting up rc files...${RESET}\n\n"
    _setup_shell_rc bashrc
    _setup_shell_rc zshrc
}

setup_shell() {
    echo "\r\n\t${BLUE}Setting up shell...${RESET}\n\n"
    # @todo
}

# Main function, this will be called to install everything
main() {
  umask g-w,o-w

  if [ -t 1 ]; then
    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    BLUE=$(printf '\033[34m')
    RESET=$(printf '\033[m')
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    RESET=""
  fi

  if [ "$PMS_DEBUG" -eq "1" ]; then
    printf "${YELLOW}"
    echo "PMS:         $PMS"
    echo "PMS_DEBUG:   $PMS_DEBUG"
    echo "PMS_REPO:    $PMS_REPO"
    echo "PMS_REMOTE:  $PMS_REMOTE"
    echo "PMS_BRANCH:  $PMS_BRANCH"
    printf "${RESET}"
  fi

  if [ ! -x "$(command -v git)" ]; then
      echo "${RED}ERROR: You must have 'git' installed${RESET}"
      exit 1
  fi

  if [ ! -x "$(command -v bash)" ] && [ ! -x "$(command -v zsh)" ]; then
      echo "${RED}ERROR: It appears the you do not have one of the supported shells installed${RESET}"
      exit 1
  fi

  if [ -d "$PMS" ]; then
      echo "${YELLOW}Looks like PMS is already installed on your system. Please remove it and run this script again.${RESET}"
      exit 1
  fi

  setup_pms
  setup_rcfiles
  setup_shell

  printf "${GREEN}"
cat <<-'EOF'

Thanks for installing...

 _______   __                                __       __                   ______   __                  __  __
/       \ /  |                              /  \     /  |                 /      \ /  |                /  |/  |
$$$$$$$  |$$/  _____  ____    ______        $$  \   /$$ | __    __       /$$$$$$  |$$ |____    ______  $$ |$$ |
$$ |__$$ |/  |/     \/    \  /      \       $$$  \ /$$$ |/  |  /  |      $$ \__$$/ $$      \  /      \ $$ |$$ |
$$    $$/ $$ |$$$$$$ $$$$  |/$$$$$$  |      $$$$  /$$$$ |$$ |  $$ |      $$      \ $$$$$$$  |/$$$$$$  |$$ |$$ |
$$$$$$$/  $$ |$$ | $$ | $$ |$$ |  $$ |      $$ $$ $$/$$ |$$ |  $$ |       $$$$$$  |$$ |  $$ |$$    $$ |$$ |$$ |
$$ |      $$ |$$ | $$ | $$ |$$ |__$$ |      $$ |$$$/ $$ |$$ \__$$ |      /  \__$$ |$$ |  $$ |$$$$$$$$/ $$ |$$ |
$$ |      $$ |$$ | $$ | $$ |$$    $$/       $$ | $/  $$ |$$    $$ |      $$    $$/ $$ |  $$ |$$       |$$ |$$ |
$$/       $$/ $$/  $$/  $$/ $$$$$$$/        $$/      $$/  $$$$$$$ |       $$$$$$/  $$/   $$/  $$$$$$$/ $$/ $$/
                            $$ |                         /  \__$$ |
                            $$ |                         $$    $$/
                            $$/                           $$$$$$/


User Guides - https://joshuaestes.github.io/pms/
  Learn how to get the most of out PMS and become a master

Developer Guides - https://github.com/JoshuaEstes/pms/wiki
  Looking to contribute or just create your our themes, plugins, and dotfiles?


*** To get started using PMS you will need to open up a new terminal, or log out and log back in ***
*** Once you start a new session you can get started by running the "pms" command                ***


EOF
  printf "${RESET}"
}

main "$@"
