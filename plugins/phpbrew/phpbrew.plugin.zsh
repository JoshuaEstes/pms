[[ -e ~/.phpbrew/bashrc ]] && source ~/.phpbrew/bashrc

function pms_phpbrew_current_php_version() {
  if type "php" > /dev/null; then
    local version=$(php -v | grep -E "PHP [578]" | sed 's/.*PHP \([^-]*\).*/\1/' | cut -c 1-6)
    if [[ -z "$PHPBREW_PHP" ]]; then
      echo "php:$version-system"
    else
      echo "php:$version-phpbrew"
    fi
  else
     echo "php:not-installed"
  fi
}
