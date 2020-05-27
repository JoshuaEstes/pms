####
# lib/color.sh
####

####
# Setup Colors for us to use in various ways
#
# Usage: _color_setup
#
# Example:
#   echo "${RED}This text will be red.${RESET}"
#
# NOTE: Make sure to reset
#
_color_setup() {
  RED=$(printf '\033[31m')
  GREEN=$(printf '\033[32m')
  YELLOW=$(printf '\033[33m')
  BLUE=$(printf '\033[34m')
  BOLD=$(printf '\033[1m')
  RESET=$(printf '\033[m')
}
