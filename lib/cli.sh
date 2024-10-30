# vim: set ft=sh:
#################################################################################################################
#  _______   __                                __       __                   ______   __                  __  __
# /       \ /  |                              /  \     /  |                 /      \ /  |                /  |/  |
# $$$$$$$  |$$/  _____  ____    ______        $$  \   /$$ | __    __       /$$$$$$  |$$ |____    ______  $$ |$$ |
# $$ |__$$ |/  |/     \/    \  /      \       $$$  \ /$$$ |/  |  /  |      $$ \__$$/ $$      \  /      \ $$ |$$ |
# $$    $$/ $$ |$$$$$$ $$$$  |/$$$$$$  |      $$$$  /$$$$ |$$ |  $$ |      $$      \ $$$$$$$  |/$$$$$$  |$$ |$$ |
# $$$$$$$/  $$ |$$ | $$ | $$ |$$ |  $$ |      $$ $$ $$/$$ |$$ |  $$ |       $$$$$$  |$$ |  $$ |$$    $$ |$$ |$$ |
# $$ |      $$ |$$ | $$ | $$ |$$ |__$$ |      $$ |$$$/ $$ |$$ \__$$ |      /  \__$$ |$$ |  $$ |$$$$$$$$/ $$ |$$ |
# $$ |      $$ |$$ | $$ | $$ |$$    $$/       $$ | $/  $$ |$$    $$ |      $$    $$/ $$ |  $$ |$$       |$$ |$$ |
# $$/       $$/ $$/  $$/  $$/ $$$$$$$/        $$/      $$/  $$$$$$$ |       $$$$$$/  $$/   $$/  $$$$$$$/ $$/ $$/
#                             $$ |                         /  \__$$ |
#                             $$ |                         $$    $$/
#                             $$/                           $$$$$$/
#
#################################################################################################################
pms() {
    [[ $# -gt 0 ]] || {
        _pms_command_help
        return 1
    }

    local command=$1
    shift

    type _pms_command_${command} &>/dev/null && {
        _pms_command_${command} "$@"
        return $?
    }

    _pms_command_help
    return 1
}

_pms_command_about() {
  echo
  echo "PMS Manager"
  echo "Making you more productive in your shell than a turtle"
  echo
  echo "Source: https://github.com/JoshuaEstes/pms"
  echo "Docs:   https://docs.codewithjoshua.com/pms"
  echo

  return 0
}

_pms_command_help() {
  echo
  echo "Usage: pms [OPTIONS] COMMAND"
  echo
  echo "Commands:"
  echo "  theme              Helps to manage themes"
  #echo "    list             Displays available themes"
  #echo "    switch           Switch to a specific theme"
  #echo "    preview          Preview theme"
  #echo "    validate         Validate theme"
  #echo "    reload           Reloads theme"
  echo "  plugin             Helps to manage plugins"
  #echo "    list             Lists all available plugins"
  #echo "    enable           Enables and install plugin"
  #echo "    disable          Disables a plugin"
  #echo "    update           Updates a plugin"
  #echo "    validate         Validate plugin"
  #echo "    reload           Reloads enabled plugins"
  echo "  dotfiles           Manage your dotfiles"
  #echo "    init             Initialize your dotfiles repository"
  #echo "    add              Add dotfiles to your repository"
  #echo "    scan             Scans your home directory for known dotfiles"
  echo "  about              Show PMS information"
  #echo "  help               Show help messages"
  echo "  upgrade            Upgrade PMS to latest version"
  echo "  diagnostic         Outputs diagnostic information"
  echo "  reload             Reloads all of PMS"
  echo

  return 0
}

_pms_command_diagnostic() {
    # @todo Alert user to any known issues with configurations
    echo
    echo "-=[ PMS ]=-"
    echo "PMS:         $PMS"
    echo "PMS_LOCAL:   $PMS_LOCAL"
    echo "PMS_DEBUG:   $PMS_DEBUG"
    echo "PMS_REPO:    $PMS_REPO"
    echo "PMS_REMOTE:  $PMS_REMOTE"
    echo "PMS_BRANCH:  $PMS_BRANCH"
    echo "PMS_THEME:   $PMS_THEME"
    echo "PMS_PLUGINS: ${PMS_PLUGINS[*]}"
    echo "PMS_SHELL:   $PMS_SHELL"
    if [ -d $PMS ]; then
      echo "Hash:        $(cd $PMS; git rev-parse --short HEAD)"
    else
      echo "Hash:        PMS not installed"
    fi
    echo "Contents of ~/.pms.theme"
    cat ~/.pms.theme
    echo
    echo "Contents of ~/.pms.plugins"
    cat ~/.pms.plugins
    echo
    echo "-=[ Shell ]=-"
    echo "SHELL: $SHELL"
    case "$PMS_SHELL" in
      bash) echo "BASHOPTS: $BASHOPTS" ;;
      zsh) echo "ZSH_PATHCLEVEL: $ZSH_PATCHLEVEL" ;;
    esac
    echo
    echo "-=[ Terminal ]=-"
    echo "TERM:                 $TERM"
    echo "TERM_PROGRAM:         $TERM_PROGRAM"
    echo "TERM_PROGRAM_VERSION: $TERM_PROGRAM_VERSION"
    echo
    echo "-=[ OS ]=-"
    echo "OSTYPE: $OSTYPE"
    echo "USER:   $USER"
    echo "umask:  $(umask)"
    case "$OSTYPE" in
      darwin*)
        echo "Product Name:     $(sw_vers -productName)"
        echo "Product Version:  $(sw_vers -productVersion)"
        echo "Build Version:    $(sw_vers -buildVersion)"
        ;;
      linux*) echo "Release: $(lsb_release -s -d)" ;;
    esac
    echo
    echo "-=[ Programs ]=-"
    echo "git: $(git --version)"
    if [ -x "$(command -v bash)" ]; then
      echo "bash: $(bash --version | grep bash)"
    else
      echo "bash: Not Installed"
    fi
    if [ -x "$(command -v zsh)" ]; then
      echo "zsh: $(zsh --version)"
    else
      echo "zsh: Not Installed"
    fi
    if [ -x "$(command -v fish)" ]; then
      echo "fish: $(fish --version)"
    else
      echo "fish: Not Installed"
    fi
    echo
    echo "-=[ Metadata ]=-"
    echo "Created At: $(date)"
    echo
}

_pms_command_upgrade() {
  local checkpoint=$PWD
  cd "$PMS"
  _pms_message_block "info" "Upgrading to latest PMS version"
  git pull origin main || {
      _pms_message "error" "Error pulling down updates..."
      cd "$checkpoint"
      return 1
  }
  _pms_message_block "info" "Copying files"
  cp -v $PMS/templates/bashrc ~/.bashrc
  cp -v $PMS/templates/zshrc ~/.zshrc
  _pms_message_block "info" "Running update scripts for enabled plugins..."

  local plugin
  for plugin in "${PMS_PLUGINS[@]}"; do
    if [ -f $PMS_LOCAL/plugins/$plugin/update.sh ]; then
        _pms_message_section "info" "$plugin (local)" "plugin updating..."
        source $PMS_LOCAL/plugins/$plugin/update.sh
    elif [ -f $PMS/plugins/$plugin/update.sh ]; then
        _pms_message_section "info" $plugin "plugin updating..."
        source $PMS/plugins/$plugin/update.sh
    fi
  done
  _pms_message_block "info" "Completed update scripts"
  _pms_message_block "success" "Upgrade complete, you may need to reload your environment"
  cd "$checkpoint"
  # @todo ask if user wants to run pms reload
}

_pms_command_reload() {
  _pms_message_block "info" "Reloading PMS..."
  # @todo which is best?
  source ~/.${PMS_SHELL}rc
  #exec $PMS_SHELL --login
  #sh $PMS/pms.sh $PMS_SHELL $PMS_DEBUG
}

_pms_command_theme() {
    [[ $# -gt 0 ]] || {
        _pms_command_theme_help
        return 1
    }

    local command=$1
    shift

    type _pms_command_theme_${command} &>/dev/null && {
        _pms_command_theme_${command} "$@"
        return $?
    }

    _pms_command_theme_help
    return 1
}

_pms_command_theme_help() {
  echo
  echo "Usage: pms [OPTIONS] theme COMMAND"
  echo
  echo "Commands:"
  echo "  list               Displays available themes"
  echo "  switch             Switch to a specific theme"
  #echo "  preview            Preview theme"
  #echo "  validate           Validate theme"
  #echo "  reload             Reloads theme"
  echo

  return 0
}

_pms_command_theme_list() {
  _pms_message_block "info" "Core Themes"
  for theme in $PMS/themes/*; do
    theme=${theme%*/}
    _pms_message "info" "${theme##*/}"
  done
  _pms_message_block "info" "Local Themes"
  for theme in $PMS_LOCAL/themes/*; do
    theme=${theme%*/}
    _pms_message "info" "${theme##*/}"
  done
  _pms_message_block "success" "Current Theme: $PMS_THEME"
}

_pms_command_theme_switch() {
    # Does theme exist?
    if [ ! -d $PMS_LOCAL/themes/$3 ] && [ ! -d $PMS/themes/$3 ]; then
        _pms_message "error" "The theme '$3' is invalid"
        return 1
    fi
    # @todo make all this better and support PMS_LOCAL
    if [ -f $PMS/themes/$PMS_THEME/uninstall.sh ]; then
        _pms_source_file $PMS/themes/$PMS_THEME/uninstall.sh
    fi
    echo "PMS_THEME=$3" > ~/.pms.theme
    PMS_THEME=$3
    # @todo make all this better and support PMS_LOCAL
    if [ -f $PMS/themes/$3/install.sh ]; then
        _pms_source_file $PMS/themes/$3/install.sh
    fi
    _pms_theme_load $3
}

_pms_command_plugin() {
    [[ $# -gt 0 ]] || {
        _pms_command_plugin_help
        return 1
    }

    local command=$1
    shift

    type _pms_command_plugin_${command} &>/dev/null && {
        _pms_command_plugin_${command} "$@"
        return $?
    }

    _pms_command_plugin_help
    return 1
}

_pms_command_plugin_help() {
  echo
  echo "Usage: pms [OPTIONS] plugin COMMAND"
  echo
  echo "Commands:"
  echo "  list               Lists all available plugins"
  echo "  enable             Enables and install plugin"
  echo "  disable            Disables a plugin"
  #echo "  update             Updates a plugin"
  #echo "  validate           Validate plugin"
  #echo "  reload             Reloads enabled plugins"
  echo

  return 0
}

_pms_command_plugin_list() {
  echo
  echo "Core Plugins:"
  for plugin in $PMS/plugins/*; do
    plugin=${plugin%*/}
    echo "  ${plugin##*/}"
  done
  echo
  echo "Local Plugins:"
  for plugin in $PMS_LOCAL/plugins/*; do
    plugin=${plugin%*/}
    echo "  ${plugin##*/}"
  done
  echo
  echo "Enabled Plugins: ${PMS_PLUGINS[*]}"
  echo
}

_pms_command_plugin_enable() {
    # @todo support for multiple plugins at a time
    # Does directory exist?
    if [ ! -d $PMS_LOCAL/plugins/$3 ] && [ ! -d $PMS/plugins/$3 ]; then
        _pms_message "error" "The plugin '$3' is invalid and cannot be enabled"
        return 1
    fi

    # Check plugin is not already enabled
    for p in "${PMS_PLUGINS[@]}"; do
        if [ "$p" = "$3" ]; then
            _pms_message "error" "The plugin '$3' is already enabled"
            return 1
        fi
    done

    # @todo if plugin cannot be loaded, do not do this
    _pms_message "info" "Adding '$3' to ~/.pms.plugins"
    PMS_PLUGINS+=($3)
    echo "PMS_PLUGINS=(${PMS_PLUGINS[*]})" > ~/.pms.plugins

    _pms_message "info" "Checking for plugin install script"
    if [ -f $PMS_LOCAL/plugins/$3/install.sh ]; then
        source $PMS_LOCAL/plugins/$3/install.sh
    elif [ -f $PMS/plugins/$3/install.sh ]; then
        source $PMS/plugins/$3/install.sh
    fi

    _pms_message "info" "Loading plugin"
    _pms_plugin_load $3
}

_pms_command_plugin_disable() {
    # @todo support for multiple plugins at a time
    local _plugin_enabled=0

    # Check to see if the plugin is already enabled and if so, notify user and
    # exit
    for p in "${PMS_PLUGINS[@]}"; do
        if [ "$p" = "${3}" ]; then
            _plugin_enabled=1
        fi
    done
    if [ "$_plugin_enabled" -eq "0" ]; then
        _pms_message_section "error" "$3" "The plugin is not enabled"
        return 1
    fi
    # ---

    # Remove from plugins
    local _plugins=()
    for i in "${PMS_PLUGINS[@]}"; do
        if [ "$i" != "$3" ]; then
            _plugins+=($i)
        fi
    done
    PMS_PLUGINS=$_plugins
    # save .pms.plugins
    echo "PMS_PLUGINS=(${_plugins[*]})" > ~/.pms.plugins
    _pms_source_file ~/.pms.plugins

    # Run uninstall script (if available)
    if [ -f $PMS_LOCAL/plugins/$3/uninstall.sh ]; then
        source $PMS_LOCAL/plugins/$3/uninstall.sh
    elif [ -f $PMS/plugins/$3/uninstall.sh ]; then
        source $PMS/plugins/$3/uninstall.sh
    fi

    _pms_message_section "success" "$3" "Plugin has been disabled, you will need to reload pms by running 'pms reload'"
    # @todo Ask user to reload environment
}

_pms_command_dotfiles() {
    [[ $# -gt 0 ]] || {
        _pms_command_dotfiles_help
        return 1
    }

    local command=$1
    shift

    type _pms_command_dotfiles_${command} &>/dev/null && {
        _pms_command_dotfiles_${command} "$@"
        return $?
    }

    _pms_command_dotfiles_help
    return 1
}

_pms_command_dotfiles_help() {
  echo
  echo "Usage: pms [OPTIONS] dotfiles COMMAND"
  echo
  echo "Commands:"
  #echo "    init             Initialize your dotfiles repository"
  echo "  add                Add dotfiles to your repository"
  #echo "    scan             Scans your home directory for known dotfiles"
  echo

  return 0
}

_pms_command_dotfiles_init() {
    echo "Initializing your dotfiles stuff"
    echo "@todo"
    # ---
    # Use existing or create new?
    # Existing
    #   git clone --bare REPO_URL $HOME/.dotfiles
    #   git checkout
    #   git config --local status.showUntrackedFiles no
    # Create New
    #   git init --bare $HOME/.dotfiles
    #   git config --local status.showUntrackedFiles no
    #   git remote add origin REPO_URL
    # ---
}

_pms_command_dotfiles_add() {
    for f in "$@"; do
        # --verbose
        # --force = Allow adding otherwise ignored files
        /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME -C $HOME add --verbose --force $f
        # @todo better commit messages
        /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME -C $HOME commit -m "$f"
    done
    # @todo support for different remote
    # @todo support for different branch
    /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME -C $HOME push origin main
}
