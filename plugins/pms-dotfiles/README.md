PMS Dotfiles Plugin
===================

This is just me testing some different methods on doing this.

References:
* https://news.ycombinator.com/item?id=11071754
* https://www.atlassian.com/git/tutorials/dotfiles

# env vars

PMS_DOTFILES_REPO=git@github.com:JoshuaEstes/dotfiles.git

# Setup

```
# initial setup
git init --bare $HOME/.pms_dotfiles

# the -C allows us act like we ran git in that path
alias pms_dotfiles='/usr/bin/git --git-dir=$HOME/.pms_dotfiles/ --work-tree=$HOME -C $HOME'

pms_dotfiles config --local status.showUntrackedFiles no
pms_dotfiles remote add origin $PMS_DOTFILES_REPO
```

```
# on a new computer
git clone --bare $PMS_DOTFILES_REPO $HOME/.pms_dotfiles
pms_dotfiles checkout
pms_dotfiles config --local status.showUntrackedFiles no
```

# todo

* move all this into pms core
