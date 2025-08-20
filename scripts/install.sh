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

_copy_file() (
    src_file="$1"
    dest_file="$2"
    desc="$3"

    if [ -e "$dest_file" ]; then
        overwrite=$(_pms_prompt "Overwrite existing $desc? [y/N]" "n" "[yYnN]")
        case "$overwrite" in
            y|Y) cp -vf "$src_file" "$dest_file";;
            *) printf 'Skipping %s\n' "$desc";;
        esac
    else
        cp -vf "$src_file" "$dest_file"
    fi
)

setup_pms() {
    printf "\r\n\t%sCloning PMS...%s\n\n" "$BLUE" "$RESET"

    git clone --depth=1 --branch "$PMS_BRANCH" "$PMS_REMOTE" "$PMS" || {
        echo "${RED}ERROR: git clone command failed${RESET}"
        exit 1
    }

    # shellcheck source=lib/core.sh
    . "$PMS/lib/core.sh"

    # Copy over config files if they do not currently exist
    printf "%sCopying PMS Environment Variables file over, this file stores various PMS settings that can be modified%s\n" "$BLUE" "$RESET"
    _copy_file "$PMS/templates/env" "$HOME/.env" "$HOME/.env"

    printf "%sCopying PMS Theme Config File, this file is used to store your currently selected theme%s\n" "$BLUE" "$RESET"
    _copy_file "$PMS/templates/pms.theme" "$HOME/.pms.theme" "$HOME/.pms.theme"

    printf "%sCopying PMS Plugins Config File, this file contains all your enabled plugins%s\n" "$BLUE" "$RESET"
    _copy_file "$PMS/templates/pms.plugins" "$HOME/.pms.plugins" "$HOME/.pms.plugins"
}

_setup_shell_rc() {
    # @todo better support
    if [ -f "$HOME/.$1" ] || [ -h "$HOME/.$1" ]; then
        printf "%sFound existing .$1 file, backing up%s\n" "$YELLOW" "$RESET"
        if [ ! -f "$HOME/.$1.pms.bak" ]; then
            printf "%sMoving $HOME/.$1 -> $HOME/.$1.pms.bak%s\n" "$YELLOW" "$RESET"
            mv -vfi "$HOME/.$1" "$HOME/.$1.pms.bak"
        fi
    fi
    printf "%sCopy $PMS/templates/$1 -> $HOME/.$1 %s\n" "$BLUE" "$RESET"
    cp -vf "$PMS/templates/$1" "$HOME/.$1"
}

setup_rcfiles() {
    printf "\r\n\t%sSetting up rc files...%s\n\n" "$BLUE" "$RESET"
    _setup_shell_rc bashrc
    _setup_shell_rc zshrc
}

setup_shell() {
    printf "\r\n\t%sSetting up shell...%s\n\n" "$BLUE" "$RESET"
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
    printf '%s' "$YELLOW"
    echo "PMS:         $PMS"
    echo "PMS_DEBUG:   $PMS_DEBUG"
    echo "PMS_REPO:    $PMS_REPO"
    echo "PMS_REMOTE:  $PMS_REMOTE"
    echo "PMS_BRANCH:  $PMS_BRANCH"
    printf '%s' "$RESET"
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
