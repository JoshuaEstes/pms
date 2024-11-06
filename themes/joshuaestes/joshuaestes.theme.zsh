# vim: set ft=zsh:
setopt prompt_subst
PS1='%f%k%F{magenta}%n%F{grey}@%F{yellow}%M%F{green}[%F{blue}$(_php_version)%F{green}][%F{cyan}${vcs_info_msg_0_}%F{green}]%f%k
%F{green}%~%f%k %F{grey}%#%f%k '
RPS1="%f%k"
RPS2="%f%k"
