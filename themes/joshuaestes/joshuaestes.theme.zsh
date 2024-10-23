# joshua@joshua.local [PHP Info] [Git Information]
# ~/code/joshuaestes/pms
setopt prompt_subst
function _php_version() {
  if type "php" > /dev/null; then
    local version=$(php -v | grep -E "PHP [578]" | sed 's/.*PHP \([^-]*\).*/\1/' | cut -c 1-6)
    echo "php:$version"
  else
     echo "php:not-installed"
  fi
}
PS1='%f%k%F{magenta}%n%F{grey}@%F{yellow}%M%F{green}[%F{blue}$(_php_version)%F{green}][%F{cyan}${vcs_info_msg_0_}%F{green}]%f%k
%F{green}%~%f%k %F{grey}%#%f%k '
RPS1="%f%k"
RPS2="%f%k"
