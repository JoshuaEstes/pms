---
title: PMS Manager
---

# PMS Manager

The PMS Manager is what you will use most of the time when you want to interact with the PMS framework. This allows you to do things such as enable/disable [plugins](https://github.com/JoshuaEstes/pms/blob/main/pms/plugins.html) and switch to different [themes](https://github.com/JoshuaEstes/pms/blob/main/pms/themes.html).

You can run `pms help` at any time to get information on all the commands the PMS Manager supports.

## Getting Help

Use `pms help` to list available commands. For detailed help on a specific command or subcommand, run:

```shell
pms help plugin
pms help plugin enable
pms help theme switch
```

## Managing Plugins

Plugins modify shell behaviour such as loading auto-completion scripts, adding aliases, or modifying shell options. Plugins are managed using the `pms plugin` command.

### Listing Current Plugins

```shell
pms plugin list
```

### Enabling Plugins

```shell
pms plugin enable [PLUGIN]
```

### Disabling Plugins

```shell
pms plugin disable [PLUGIN]
```

## Managing Themes

Themes modify how your shell looks. These are things such as colors and usually include a kick ass command prompt.

_**Note**_ Some themes may enable or disable PMS plugins for functionality. An example of this would be a theme that would require the "git-prompt" plugin so it has access to that functionality. This is done for you so you don't need to do this by hand {: .notice--warning}

### Listing Themes

This will show you all the available themes you are able to switch to.

```shell
pms theme list
```

### Switching Themes

```shell
pms theme switch [THEME]
```

## Managing your Dotfiles

Dotfile management is provided by the `dotfiles` plugin, which is enabled by default. Dotfiles are a very important part of being a developer and most like to make sure those files are backed up. The PMS Manager supports managing your dotfiles using git.

The repository that will be managed will look something like [this](https://github.com/JoshuaEstes/dotfiles)

### Requirements

* git repository

### Initializing dotfile management

To get started, just run `pms dotfiles init` and follow the instructions

### Initializing by hand

To start fresh with a new git repo, follow these steps:

```
git init --bare $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME -C $HOME config --local status.showUntrackedFiles no
git --git-dir=$HOME/.dotfiles --work-tree=$HOME -C $HOME remote add origin REPO_URL
```

_**NOTE**_: You will need to make sure you have a git repository already created that would allow you to push to.

If you already have an existing dotfiles repository, follow these steps:

```
git clone --bare REPO_URL $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles --work-tree=$HOME -C $HOME checkout
git --git-dir=$HOME/.dotfiles --work-tree=$HOME -C $HOME config --local status.showUntrackedFiles no
```

_**NOTE**_: You may run into issues when you run "git checkout". You will need to resolve those before you can make sure that everything is set up correctly.

### Adding files

Adding files is quick, just run `pms dotfiles add FILE` and PMS will add the file to your dotfiles repository, make a commit, and push up your changes.

### Pulling down changes

Run `pms dotfiles pull` if you have made any changes in your repository that you want to pull down to your machine.
