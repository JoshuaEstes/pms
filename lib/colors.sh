# shellcheck shell=sh disable=SC2034
# vim: set ft=sh:
####
# Color definitions
#
# Provides ANSI escape sequences for formatting terminal output.
# Usage: wrap text with variables, e.g., "${color_red}text${color_reset}".
# Depends on "tput" and a valid terminfo database to generate codes.
####

# Determine whether the current terminal supports color output.
# Considers the NO_COLOR environment variable and requires tput to
# report at least eight supported colors.
supports_color() {
    [ -n "$NO_COLOR" ] && return 1
    command -v tput >/dev/null 2>&1 || return 1

    tput_color_count=$(tput colors 2>/dev/null)
    if [ -n "$tput_color_count" ] && [ "$tput_color_count" -ge 8 ]; then
        unset tput_color_count
        return 0
    fi

    unset tput_color_count
    return 1
}

if supports_color; then
    # Reset
    color_reset=$(tput sgr0 2>/dev/null)        # Reset all text formatting

    # Foreground colors
    color_black=$(tput setaf 0 2>/dev/null)       # Set foreground to black
    color_red=$(tput setaf 1 2>/dev/null)         # Set foreground to red
    color_green=$(tput setaf 2 2>/dev/null)       # Set foreground to green
    color_yellow=$(tput setaf 3 2>/dev/null)      # Set foreground to yellow
    color_blue=$(tput setaf 4 2>/dev/null)        # Set foreground to blue
    color_magenta=$(tput setaf 5 2>/dev/null)     # Set foreground to magenta
    color_cyan=$(tput setaf 6 2>/dev/null)        # Set foreground to cyan
    color_white=$(tput setaf 7 2>/dev/null)       # Set foreground to white
    color_bright_black=$(tput setaf 8 2>/dev/null)   # Set foreground to bright black
    color_bright_red=$(tput setaf 9 2>/dev/null)     # Set foreground to bright red
    color_bright_green=$(tput setaf 10 2>/dev/null)  # Set foreground to bright green
    color_bright_yellow=$(tput setaf 11 2>/dev/null) # Set foreground to bright yellow
    color_bright_blue=$(tput setaf 12 2>/dev/null)   # Set foreground to bright blue
    color_bright_magenta=$(tput setaf 13 2>/dev/null) # Set foreground to bright magenta
    color_bright_cyan=$(tput setaf 14 2>/dev/null)    # Set foreground to bright cyan
    color_bright_white=$(tput setaf 15 2>/dev/null)   # Set foreground to bright white

    # Background colors
    color_bg_black=$(tput setab 0 2>/dev/null)       # Set background to black
    color_bg_red=$(tput setab 1 2>/dev/null)         # Set background to red
    color_bg_green=$(tput setab 2 2>/dev/null)       # Set background to green
    color_bg_yellow=$(tput setab 3 2>/dev/null)      # Set background to yellow
    color_bg_blue=$(tput setab 4 2>/dev/null)        # Set background to blue
    color_bg_magenta=$(tput setab 5 2>/dev/null)     # Set background to magenta
    color_bg_cyan=$(tput setab 6 2>/dev/null)        # Set background to cyan
    color_bg_white=$(tput setab 7 2>/dev/null)       # Set background to white
    color_bg_bright_black=$(tput setab 8 2>/dev/null)   # Set background to bright black
    color_bg_bright_red=$(tput setab 9 2>/dev/null)     # Set background to bright red
    color_bg_bright_green=$(tput setab 10 2>/dev/null)  # Set background to bright green
    color_bg_bright_yellow=$(tput setab 11 2>/dev/null) # Set background to bright yellow
    color_bg_bright_blue=$(tput setab 12 2>/dev/null)   # Set background to bright blue
    color_bg_bright_magenta=$(tput setab 13 2>/dev/null) # Set background to bright magenta
    color_bg_bright_cyan=$(tput setab 14 2>/dev/null)    # Set background to bright cyan
    color_bg_bright_white=$(tput setab 15 2>/dev/null)   # Set background to bright white

    # Text effects
    color_bold=$(tput bold 2>/dev/null)          # Apply bold style
    color_dim=$(tput dim 2>/dev/null)            # Apply dim style
    color_underline=$(tput smul 2>/dev/null)     # Apply underline style
    color_reverse=$(tput rev 2>/dev/null)        # Swap foreground and background
else
    color_reset=''        # Reset all text formatting

    # Foreground colors
    color_black=''
    color_red=''
    color_green=''
    color_yellow=''
    color_blue=''
    color_magenta=''
    color_cyan=''
    color_white=''
    color_bright_black=''
    color_bright_red=''
    color_bright_green=''
    color_bright_yellow=''
    color_bright_blue=''
    color_bright_magenta=''
    color_bright_cyan=''
    color_bright_white=''

    # Background colors
    color_bg_black=''
    color_bg_red=''
    color_bg_green=''
    color_bg_yellow=''
    color_bg_blue=''
    color_bg_magenta=''
    color_bg_cyan=''
    color_bg_white=''
    color_bg_bright_black=''
    color_bg_bright_red=''
    color_bg_bright_green=''
    color_bg_bright_yellow=''
    color_bg_bright_blue=''
    color_bg_bright_magenta=''
    color_bg_bright_cyan=''
    color_bg_bright_white=''

    # Text effects
    color_bold=''
    color_dim=''
    color_underline=''
    color_reverse=''
fi
