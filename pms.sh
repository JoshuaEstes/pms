####
# PMS
#
# One framework to manage your Themes, Plugins, and dotfiles
#
####

# Validate we can properly configure the shell
if [ -z $1 ]; then
    echo
    echo "Usage: pms.sh PMS_SHELL"
    echo
    exit 1
fi
PMS_SHELL=$1

####
# This will load up libraries from the code base. It will load sh and then load
# specific shell libraries
#
# @todo local overwrites
# @internal
####
for lib in $PMS/lib/*.{sh,$PMS_SHELL}; do
    source $lib
done
unset lib

_pms_source_file $PMS/plugins/pms/env
_pms_source_file ~/.pms.plugins
_pms_source_file ~/.pms.theme
_pms_source_file $PMS/plugins/$PMS_SHELL/env

####
# Initialize colors so we can use these late
#
# @todo add more colors and ability for fg and bg
####
_pms_initialize_colors() {
  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  BLUE=$(printf '\033[34m')
  BOLD=$(printf '\033[1m')
  RESET=$(printf '\033[m')
}
_pms_initialize_colors

####
# Various Messages and Text Helpers
#
# Example: _pms_message_* "This will be the message"
# Example: _pms_message_section_* "DEBUG" "This will be the message"
# Example: _pms_message_block_* "DEBUG" "This will be the message"
#
# @todo Make better and include documentation
#
_pms_message_info() {
    printf "\r${BLUE}$1${RESET}\n"
}
_pms_message_success() {
    printf "\r${GREEN}$1${RESET}\n"
}
_pms_message_warn() {
    printf "\r${YELLOW}$1${RESET}\n"
}
_pms_message_error() {
    printf "\r${RED}$1${RESET}\n"
}
_pms_message_section_info() {
    printf "\r[${BLUE}$1${RESET}] $2${RESET}\n"
}
_pms_message_section_success() {
    printf "\r[${GREEN}$1${RESET}] $2${RESET}\n"
}
_pms_message_section_warn() {
    printf "\r[${YELLOW}$1${RESET}] $2${RESET}\n"
}
_pms_message_section_error() {
    printf "\r[${RED}$1${RESET}] $2${RESET}\n"
}
_pms_message_block_info() {
    printf "\r\n\t${BLUE}$1${RESET}\n\n"
}
_pms_message_block_success() {
    printf "\r\n\t${GREEN}$1${RESET}\n\n"
}
_pms_message_block_warn() {
    printf "\r\n\t${YELLOW}$1${RESET}\n\n"
}
_pms_message_block_error() {
    printf "\r\n\t${RED}$1${RESET}\n\n"
}

if [ "$PMS_DEBUG" -eq "1" ]; then
    _pms_message_block_info "Current PMS Settings"
    _pms_message_info "PMS:         $PMS"
    _pms_message_info "PMS_LOCAL:   $PMS_LOCAL"
    _pms_message_info "PMS_DEBUG:   $PMS_DEBUG"
    _pms_message_info "PMS_REPO:    $PMS_REPO"
    _pms_message_info "PMS_REMOTE:  $PMS_REMOTE"
    _pms_message_info "PMS_BRANCH:  $PMS_BRANCH"
    _pms_message_info "PMS_THEME:   $PMS_THEME"
    _pms_message_info "PMS_PLUGINS: ${PMS_PLUGINS[*]}"
    _pms_message_info "PMS_SHELL:   $PMS_SHELL\n"
fi

####
# Load all enabled plugins
####
for plugin in "${PMS_PLUGINS[@]}"; do
    if [[ "$plugin" != "$PMS_SHELL" && "$plugin" != "pms" ]]; then
        _pms_plugin_load $plugin
    fi
done
unset plugin
####

####
# Load Theme
####
_pms_theme_load $PMS_THEME
####
