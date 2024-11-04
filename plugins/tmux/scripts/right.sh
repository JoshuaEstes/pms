#!/usr/bin/env sh
####
#
# Used to display the right side of the tmux status line
#
echo "[$(date +"%a %b %d %I:%M%p")] [Load:$(uptime | awk -F'[a-z]:' '{ print $2 }')]"
