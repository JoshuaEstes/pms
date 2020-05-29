---
title: Environment Variables
classes: wide
---

PMS will search for and load a few different .env files to help you configure
how PMS works.

.env files, if they exist, are loaded in the following order:

1. `$HOME/.env`
1. `$HOME/.env.{SHELL}`
1. `$HOME/.env.local`
1. `$HOME/.env.{SHELL}.local`

***{SHELL}*** will be **zsh**, **bash**, **fish**, etc. depending on the shell
you are using.
{: .notice--info}

PMS Loads .env files in this order to allow you different configuration options.
These files are where you will overwrite environment variables defined by [plugins](pms/plugins.html)
to modify behavior.
