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

[[ -f ~/.env ]] && source ~/.env
[[ -f ~/.env.bash ]] && source ~/.env.bash
[[ -f ~/.env.local ]] && source ~/.env.local
[[ -f ~/.env.bash.local ]] && source ~/.env.bash.local

source $PMS/pms.sh bash
