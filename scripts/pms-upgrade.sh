#!/usr/bin/env sh
set -e
PMS=${PMS:-~/.pms}
REPO=https://github.com/JoshuaEstes/pms.git

cd "$PMS"
git pull origin master

return
