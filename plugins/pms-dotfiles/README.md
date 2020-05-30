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

Commands
There should be a few commands that we manage, but the rest should pass on
through to the git command

pms dotfiles init
* Use $PMS_DOTFILES_REPO or init a new git repo and set remote to $PMS_DOTFILES_REPO?

pms dotfiles scan
* Scans $HOME for dotfiles to manage
* for each one, prompt user to add
* if yes, commit
* end of script will push repo

pms dotfiles status
* wrapper for /usr/bin/git --git-dir=$HOME/.pms_dotfiles/ --work-tree=$HOME -C $HOME status

pms dotfiles add [FILE]...
* wrapper for /usr/bin/git --git-dir=$HOME/.pms_dotfiles/ --work-tree=$HOME -C $HOME add [FILES]...
* will commit each file with message
* push repo when done

# todo

* move all this into pms core
* pms dotfiles [COMMAND] to manage a lot of this stuff

---

Documentation
=============

The PMS Dotfiles Manager is a tool that allows you to manage your personal
dotfiles. Your files will be saved and backed up to your own repository. You can
start with a fresh repo that we will help you setup or you can use an existing
repository. This [dotfiles repo](https://github.com/JoshuaEstes/dotfiles) will
be an example of what your repository may look like.

The PMS Dotfiles Manager tries to be as automated as possible so that once it's
setup, it will become VERY easy to keep your dotfiles in sync and backed up.

# Initial Setup

## Starting with a fresh dotfiles repo

Run pms dotfiles init
Select to create a new repository
Enter repo url
enter repo branch
enter path for git-dir
git init

Run the pms dotfiles scan command

## Starting with existing dotfiles repo

run pms dotfiles init
select existing repository
enter repo url
enter branch
enter path for git-dir
clone repo
checkout

* Need the ability to fix conflicts if there are any

# Workflows

## Auto add dotfiles

Running the command pms dotfiles scan will scan for known dotfiles and prompt
you if you would like to version control these files.

## Manually add files

run the command pms dotfiles add FILE and your file will be added to version
control, a commit message will be added, and the changes will be pushed up.

## Syncing

Just run pms dotfiles push or pms dotfiles pull in order to push/pull any
changes.

# Behind the scenes details

pms dotfiles is many just a wrapper command around git. For example, when you
run `pms dotfiles pull` it will run `usr/bin/git --git-dir=$PMS_DOTFILES_GIT_DIR
--work-tree=$HOME -C $HOME pull`.  HOWEVER not all commands will simply be
passed through. Running `pms dotfiles sync` will scan $HOME and for each file it
will ask if you want to have it managed, add and commit that file, and after all
of that it will push up the changes to your repository.
