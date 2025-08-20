# @see http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Prompt-Expansion
# joshua@host.dev ~/path %

# shellcheck shell=bash disable=SC1090,SC2034,SC2154,SC1087
# Load color definitions for readable prompt segments.
# shellcheck source=lib/colors.zsh
source "$PMS/lib/colors.zsh"

# Initialize version control information to display Git status.
autoload -Uz vcs_info
precmd() {
    vcs_info
}

# Configure vcs_info for Git repositories.
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '%F{red}*%f'
zstyle ':vcs_info:git:*' stagedstr '%F{green}+%f'
zstyle ':vcs_info:git:*' formats '%F{yellow}[%b%u%c]%f'
zstyle ':vcs_info:git:*' actionformats '%F{yellow}[%b|%a]%f'

# Display user, host, working directory and Git status.
PROMPT="%{$fg[green]%}%n%{$reset_color%}@%{$fg[blue]%}%M %{$fg[cyan]%}%~%{$reset_color%} \${vcs_info_msg_0_} %# "
