# shellcheck shell=sh disable=SC2034
# vim: set ft=sh:
####
# Color definitions
#
# Provides ANSI escape sequences for formatting terminal output.
# Usage: wrap text with variables, e.g., "${color_red}text${color_reset}".
####

color_reset=$(printf '\033[0m')        # Reset all text formatting

# Foreground colors
color_black=$(printf '\033[30m')       # Set foreground to black
color_red=$(printf '\033[31m')         # Set foreground to red
color_green=$(printf '\033[32m')       # Set foreground to green
color_yellow=$(printf '\033[33m')      # Set foreground to yellow
color_blue=$(printf '\033[34m')        # Set foreground to blue
color_magenta=$(printf '\033[35m')     # Set foreground to magenta
color_cyan=$(printf '\033[36m')        # Set foreground to cyan
color_white=$(printf '\033[37m')       # Set foreground to white
color_bright_black=$(printf '\033[90m')   # Set foreground to bright black
color_bright_red=$(printf '\033[91m')     # Set foreground to bright red
color_bright_green=$(printf '\033[92m')   # Set foreground to bright green
color_bright_yellow=$(printf '\033[93m')  # Set foreground to bright yellow
color_bright_blue=$(printf '\033[94m')    # Set foreground to bright blue
color_bright_magenta=$(printf '\033[95m') # Set foreground to bright magenta
color_bright_cyan=$(printf '\033[96m')    # Set foreground to bright cyan
color_bright_white=$(printf '\033[97m')   # Set foreground to bright white

# Background colors
color_bg_black=$(printf '\033[40m')       # Set background to black
color_bg_red=$(printf '\033[41m')         # Set background to red
color_bg_green=$(printf '\033[42m')       # Set background to green
color_bg_yellow=$(printf '\033[43m')      # Set background to yellow
color_bg_blue=$(printf '\033[44m')        # Set background to blue
color_bg_magenta=$(printf '\033[45m')     # Set background to magenta
color_bg_cyan=$(printf '\033[46m')        # Set background to cyan
color_bg_white=$(printf '\033[47m')       # Set background to white
color_bg_bright_black=$(printf '\033[100m')   # Set background to bright black
color_bg_bright_red=$(printf '\033[101m')     # Set background to bright red
color_bg_bright_green=$(printf '\033[102m')   # Set background to bright green
color_bg_bright_yellow=$(printf '\033[103m')  # Set background to bright yellow
color_bg_bright_blue=$(printf '\033[104m')    # Set background to bright blue
color_bg_bright_magenta=$(printf '\033[105m') # Set background to bright magenta
color_bg_bright_cyan=$(printf '\033[106m')    # Set background to bright cyan
color_bg_bright_white=$(printf '\033[107m')   # Set background to bright white

# Text effects
color_bold=$(printf '\033[1m')          # Apply bold style
color_dim=$(printf '\033[2m')           # Apply dim style
color_underline=$(printf '\033[4m')     # Apply underline style
color_reverse=$(printf '\033[7m')       # Swap foreground and background
