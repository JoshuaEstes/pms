####
#
# Upgrade script
#

# Defaults variables
# @todo remove these defaults
#PMS=${PMS:-~/.pms}
#PMS_DEBUG=${PMS_DEBUG:-1}
#PMS_REPO=${PMS_REPO:-JoshuaEstes/pms}
#PMS_REOMTE=${PMS_REMOTE:-https://github.com/${PMS_REPO}.git}
#PMS_BRANCH=${PMS_BRANCH:-master}
#PMS_SHELL=${PMS_SHELL:-bash}

_update_pms_files() {
  cp -v $PMS/templates/bashrc ~/.bashrc
}

main() {
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo
    echo "-=[ PMS Debug ]=-"
    echo "PMS:         $PMS"
    echo "PMS_DEBUG:   $PMS_DEBUG"
    echo "PMS_REPO:    $PMS_REPO"
    echo "PMS_REMOTE:  $PMS_REMOTE"
    echo "PMS_BRANCH:  $PMS_BRANCH"
    echo "PMS_THEME:   $PMS_THEME"
    echo "PMS_PLUGINS: $PMS_PLUGINS"
    echo "PMS_SHELL:   $PMS_SHELL"
    echo "-=[ PMS Debug ]=-"
    echo
  fi
  cd "$PMS"
  echo
  echo "Upgrading to latest PMS version"
  echo
  git pull origin master
  echo
  echo "Copying files"
  echo
  _update_pms_files
  echo
  echo "Upgrade complete"
  echo
  exec $PMS_SHELL
  cd -
}

main
