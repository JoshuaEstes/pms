#!/usr/bin/env sh
#
# Install PMS into the target directory and configure the user's shell.
#
# Usage:
#   PMS_INSTALL_DIR=/opt/pms scripts/install.sh
#
# Environment Variables:
#   PMS_INSTALL_DIR  Path where PMS should be installed (default: ~/.pms)
#   PMS_DEBUG        Set to 1 to enable verbose debug output
#   PMS_REPO         Repository to clone (default: JoshuaEstes/pms)
#   PMS_REMOTE       Remote URL of the repository (default: https://github.com/$PMS_REPO.git)
#   PMS_BRANCH       Branch to checkout (default: main)
#   PMS_SHELL        Target shell to configure (bash, zsh, etc.)
####
# shellcheck shell=sh disable=SC3040

set -eu
# Exit on error or undefined variable
set -o pipefail
# Catch failures in pipelines
PMS_INSTALL_DIR=${PMS_INSTALL_DIR:-${PMS:-~/.pms}}
PMS_DEBUG=${PMS_DEBUG:-0}
PMS_REPO=${PMS_REPO:-JoshuaEstes/pms}
PMS_REMOTE=${PMS_REMOTE:-https://github.com/${PMS_REPO}.git}
PMS_BRANCH=${PMS_BRANCH:-main}
PMS_SHELL=${PMS_SHELL:-${SHELL##*/}}


# setup_pms clones the PMS repository and copies default configuration files.
setup_pms() {
    printf '\r\n\t%sCloning PMS...%s\n\n' "$BLUE" "$RESET"

    git clone --depth=1 --branch "$PMS_BRANCH" "$PMS_REMOTE" "$PMS_INSTALL_DIR" || {
        echo "${RED}ERROR: git clone command failed${RESET}"
        exit 1
    }

    # Copy over config files if they do not currently exist
    echo "${BLUE}Copying PMS Environment Variables file over, this file stores various PMS settings that can be modified${RESET}"
    cp -vfi "$PMS_INSTALL_DIR/templates/env" "$HOME/.env"

    echo "${BLUE}Copying PMS Theme Config File, this file is used to store your currently selected theme${RESET}"
    cp -vfi "$PMS_INSTALL_DIR/templates/pms.theme" "$HOME/.pms.theme"

    echo "${BLUE}Copying PMS Plugins Config File, this file contains all your enabled plugins${RESET}"
    cp -vfi "$PMS_INSTALL_DIR/templates/pms.plugins" "$HOME/.pms.plugins"
}


# _setup_shell_rc backs up any existing RC file and installs the PMS version.
_setup_shell_rc() {
    shell_name="$1"
    shell_rc_file="${shell_name}rc"
    if [ -f "$HOME/.${shell_rc_file}" ] || [ -h "$HOME/.${shell_rc_file}" ]; then
        echo "${YELLOW}Found existing .${shell_rc_file} file, backing up${RESET}"
        if [ ! -f "$HOME/.${shell_rc_file}.pms.bak" ]; then
            echo "${YELLOW}Moving $HOME/.${shell_rc_file} -> $HOME/.${shell_rc_file}.pms.bak${RESET}"
            mv -vfi "$HOME/.${shell_rc_file}" "$HOME/.${shell_rc_file}.pms.bak"
        fi
    fi
    echo "${BLUE}Copy $PMS_INSTALL_DIR/templates/${shell_rc_file} -> $HOME/.${shell_rc_file} ${RESET}"
    cp -vf "$PMS_INSTALL_DIR/templates/${shell_rc_file}" "$HOME/.${shell_rc_file}"
}

# setup_shell configures the user's shell and sets it as default if possible.
setup_shell() {
    printf '\r\n\t%sSetting up shell...%s\n\n' "$BLUE" "$RESET"
    case "$PMS_SHELL" in
        bash|zsh)
            _setup_shell_rc "$PMS_SHELL"
            if command -v chsh >/dev/null 2>&1; then
                current_shell_name=${SHELL##*/}
                if [ "$current_shell_name" != "$PMS_SHELL" ]; then
                    echo "${BLUE}Changing default shell to $PMS_SHELL${RESET}"
                    chsh -s "$(command -v "$PMS_SHELL")"
                fi
            fi
            ;;
        *)
            echo "${YELLOW}Skipping shell setup; unsupported shell '$PMS_SHELL'${RESET}"
            ;;
    esac
}

# main orchestrates the installation process.
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
      printf '%s' "$YELLOW"
    echo "PMS_INSTALL_DIR: $PMS_INSTALL_DIR"
    echo "PMS_DEBUG:       $PMS_DEBUG"
    echo "PMS_REPO:        $PMS_REPO"
    echo "PMS_REMOTE:      $PMS_REMOTE"
    echo "PMS_BRANCH:      $PMS_BRANCH"
    echo "PMS_SHELL:       $PMS_SHELL"
      printf '%s' "$RESET"
  fi

  if [ ! -x "$(command -v git)" ]; then
      echo "${RED}ERROR: You must have 'git' installed${RESET}"
      exit 1
  fi

  if [ ! -x "$(command -v "$PMS_SHELL")" ]; then
      echo "${RED}ERROR: It appears that $PMS_SHELL is not installed${RESET}"
      exit 1
  fi

  if [ -d "$PMS_INSTALL_DIR" ]; then
      echo "${YELLOW}Looks like PMS is already installed on your system. Please remove it and run this script again.${RESET}"
      exit 1
  fi

  setup_pms
  setup_shell

  printf '%s' "$GREEN"
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
  printf '%s' "$RESET"
}

main "$@"
