# vim: set ft=zsh:
# shellcheck shell=bash disable=SC2034,SC2154,SC2296
####
# Colors
####

####
# Loads colors and allows users using zsh to access colors using
# $fg and $bg
# @see https://github.com/zsh-users/zsh/blob/master/Functions/Misc/colors
autoload -U colors && colors
color_reset=$reset_color

####
# Apply a color to text and reset formatting
#
# Usage: colorize <color_var> "<text>"
#
# Arguments:
#   color_var - name of the $fg or $bg color to apply
#   text      - text to colorize
####
colorize() {
    color_var=$1
    color_text=$2

    printf '%s%s%s\n' "${(P)color_var}" "$color_text" "$color_reset"

    unset color_var
    unset color_text
}
