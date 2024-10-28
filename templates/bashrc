####
# ~/.bashrc
#
# |                  | Interactive | Interactive | Script |
# |                  | login       | non-login   |        |
# | ---------------- | ----------- | ----------- | ------ |
# | /etc/profile     | A           |             |        |
# | /etc/bash.bashrc |             | A           |        |
# | ~/.bashrc        |             | B           |        |
# | ~/.bash_profile  | B1          |             |        |
# | ~/.bash_login    | B2          |             |        |
# | ~/.profile       | B3          |             |        |
# | BASH_ENV         |             |             | B      |
# | ---------------- | ----------- | ----------- | ------ |
# | ~/.bash_logout   | C           |             |        |
####

# Defaults
PMS=~/.pms
PMS_LOCAL=$PMS/local
PMS_DEBUG=1
PMS_REPO=JoshuaEstes/pms
PMS_REMOTE=https://github.com/${PMS_REPO}.git
PMS_BRANCH=main
PMS_THEME=default
PMS_PLUGINS=(getting-started)

[[ -f ~/.env ]] && source ~/.env
[[ -f ~/.env.bash ]] && source ~/.env.bash
[[ -f ~/.env.local ]] && source ~/.env.local
[[ -f ~/.env.bash.local ]] && source ~/.env.bash.local

source $PMS/pms.sh bash $PMS_DEBUG
