# shellcheck shell=sh disable=SC2034
# vim: set ft=sh:
####
# Color definitions
#
# Provides ANSI escape sequences for formatting terminal output.
# Usage: wrap text with variables, e.g., "${color_red}text${color_reset}".
####
color_reset=$(printf '\033[0m')

# Foreground colors
color_black=$(printf '\033[30m')
color_red=$(printf '\033[31m')
color_green=$(printf '\033[32m')
color_yellow=$(printf '\033[33m')
color_blue=$(printf '\033[34m')
color_magenta=$(printf '\033[35m')
color_cyan=$(printf '\033[36m')
color_white=$(printf '\033[37m')
color_bright_black=$(printf '\033[90m')
color_bright_red=$(printf '\033[91m')
color_bright_green=$(printf '\033[92m')
color_bright_yellow=$(printf '\033[93m')
color_bright_blue=$(printf '\033[94m')
color_bright_magenta=$(printf '\033[95m')
color_bright_cyan=$(printf '\033[96m')
color_bright_white=$(printf '\033[97m')

# TODO: add background color variables

# Text effects
color_bold=$(printf '\033[1m')
