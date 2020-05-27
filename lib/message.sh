####
# lib/message.sh
#
# @depends
#   lib/color.sh
#
# @depends
#   _color_setup()
#
# Message Helper
# Allows the use of various messages
#
####

_message_info() {
  printf "\r${BLUE}$1${RESET}\n"
}

_message_success() {
  printf "\r${GREEN}$1${RESET}\n"
}

_message_warn() {
  printf "\r${YELLOW}$1${RESET}\n"
}

_message_fail() {
  printf "\r${RED}$1${RESET}\n"
}

_message_section_info() {
  printf "\r[${BLUE}$1${RESET}] $2\n"
}

_message_section_success() {
  printf "\r[${GREEN}$1${RESET}] $2\n"
}

_message_section_warn() {
  printf "\r[${YELLOW}$1${RESET}] $2\n"
}

_message_section_fail() {
  printf "\r[${RED}$1${RESET}] $2\n"
}
