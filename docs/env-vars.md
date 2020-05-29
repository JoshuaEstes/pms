---
title: Environment Variables
classes: wide
---

PMS will search for and load a few different .env files to help you configure
how PMS works.

.env files are loaded in the following order:

1. `$HOME/.env`
1. `$HOME/.env.SHELL`
1. `$HOME/.env.local`
1. `$HOME/.env.SHELL`

`SHELL` will be zsh, bash, fish, etc. depending on what your are using
{: .notice--info}
