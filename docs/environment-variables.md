---
title: Environment Variables
classes: wide
---

# Environment Variables

PMS will search for and load a few different .env files to help you configure how PMS works.

.env files, if they exist, are loaded in the following order:

1. `$HOME/.env`
2. `$HOME/.env.{SHELL}`
3. `$HOME/.env.local`
4. `$HOME/.env.{SHELL}.local`

_**{SHELL}**_ will be **zsh**, **bash**, **fish**, etc. depending on the shell you are using. {: .notice--info}

PMS Loads .env files in this order to allow you different configuration options. These files are where you will overwrite environment variables defined by [plugins](https://github.com/JoshuaEstes/pms/blob/master/pms/plugins.html) to modify behavior.
