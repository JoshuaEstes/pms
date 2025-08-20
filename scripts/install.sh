#!/usr/bin/env sh
#
# Environment Variables
#   PMS         = path to PMS repository
#   PMS_DEBUG   = 1 = enabled, 0 = disabled
#   PMS_REPO    = default: JoshuaEstes/pms
#   PMS_REMOTE  = default: https://github.com/$PMS_REPO.git
#   PMS_BRANCH  = main
#   PMS_SHELL   = target shell to configure (bash, zsh, etc.)
#
set -e
PMS=${PMS:-~/.pms}
PMS_DEBUG=${PMS_DEBUG:-0}
PMS_REPO=${PMS_REPO:-JoshuaEstes/pms}
PMS_REMOTE=${PMS_REMOTE:-https://github.com/${PMS_REPO}.git}
PMS_BRANCH=${PMS_BRANCH:-main}
PMS_SHELL=${PMS_SHELL:-${SHELL##*/}}

setup_pms() {
    printf '\r\n\t%sCloning PMS...%s\n\n' "$BLUE" "$RESET"

    git clone --depth=1 --branch "$PMS_BRANCH" "$PMS_REMOTE" "$PMS" || {
        echo "${RED}ERROR: git clone command failed${RESET}"
        exit 1
    }

    # Copy over config files if they do not currently exist
    echo "${BLUE}Copying PMS Environment Variables file over, this file stores various PMS settings that can be modified${RESET}"
    cp -vfi "$PMS/templates/env" "$HOME/.env"

    echo "${BLUE}Copying PMS Theme Config File, this file is used to store your currently selected theme${RESET}"
    cp -vfi "$PMS/templates/pms.theme" "$HOME/.pms.theme"

    echo "${BLUE}Copying PMS Plugins Config File, this file contains all your enabled plugins${RESET}"
    cp -vfi "$PMS/templates/pms.plugins" "$HOME/.pms.plugins"
}

_setup_shell_rc() {
    shell_name="$1"
    rc_file="${shell_name}rc"
    if [ -f "$HOME/.${rc_file}" ] || [ -h "$HOME/.${rc_file}" ]; then
        echo "${YELLOW}Found existing .${rc_file} file, backing up${RESET}"
        if [ ! -f "$HOME/.${rc_file}.pms.bak" ]; then
            echo "${YELLOW}Moving $HOME/.${rc_file} -> $HOME/.${rc_file}.pms.bak${RESET}"
            mv -vfi "$HOME/.${rc_file}" "$HOME/.${rc_file}.pms.bak"
        fi
    fi
    echo "${BLUE}Copy $PMS/templates/${rc_file} -> $HOME/.${rc_file} ${RESET}"
    cp -vf "$PMS/templates/${rc_file}" "$HOME/.${rc_file}"
}

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
    echo "PMS_SHELL:   $PMS_SHELL"
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

  if [ -d "$PMS" ]; then
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
