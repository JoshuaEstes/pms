#!/usr/bin/env sh
PMS=${PMS:-~/.pms}
REPO=https://github.com/JoshuaEstes/pms.git
cd "$PMS"
git pull origin master
exit
