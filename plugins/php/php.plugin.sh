# vim: set ft=sh:
####
# PHP Plugin
####

# Add bin directory to path
export PATH="$PATH:$PMS/plugins/php/bin"

####
# This will display the PHP version
_php_version() {
  if type "php" > /dev/null; then
    local version=$(php -v | grep -E "PHP [578]" | sed 's/.*PHP \([^-]*\).*/\1/' | cut -c 1-6)
    echo "php:$version"
  else
     echo "php:not-installed"
  fi
}
