#!/usr/bin/env sh
set -e
####
#
# Upgrade script
#

# Defaults variables
# @todo remove
PMS=${PMS:-~/.pms}
PMS_DEBUG=${PMS_DEBUG:-1}
PMS_REPO=${PMS_REPO:-JoshuaEstes/pms}
PMS_REOMTE=${PMS_REMOTE:-https://github.com/${PMS_REPO}.git}
PMS_BRANCH=${PMS_BRANCH:-master}

main() {
  cd "$PMS"
  echo "Upgrading to latest PMS version"
  git pull origin master
  echo
}

main "$@"
