# ~/.bashrc
####
# This file may get updated when running an install or pms update, please use
# the config files and PMS_LOCAL directory to modify PMS

# Defaults
PMS=~/.pms
PMS_LOCAL=$PMS/local
PMS_DEBUG=1
PMS_REPO=JoshuaEstes/pms
PMS_REMOTE=https://github.com/${PMS_REPO}.git
PMS_BRANCH=master
PMS_THEME=default
PMS_PLUGINS=(getting-started)

[[ -f ~/.env ]] && source ~/.env
[[ -f ~/.env.bash ]] && source ~/.env.bash
[[ -f ~/.env.local ]] && source ~/.env.local
[[ -f ~/.env.bash.local ]] && source ~/.env.bash.local

source $PMS/pms.sh bash $PMS_DEBUG
