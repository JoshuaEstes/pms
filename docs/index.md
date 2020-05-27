---
layout: default
title: PMS
---

PMS is a framework for using different shells along with various "dotfiles".
It supports easy install/uninstall and a wide variety of plugins and themes.

![CI](https://github.com/JoshuaEstes/pms/workflows/CI/badge.svg?branch=master)

# Features
* Themes - Change the way your environment looks
* Plugins - Change the way your environment functions
* Dotfiles - Change the way programs work in your environment
* Multiple Shell Support
  * No matter the shell, you can easily swap between them and maintain similar functionality
* PMS Manager - Easy to use and up modify tool to help you manage PMS
  * Easy upgrade PMS
  * Preview and switch themes
  * Easy Plugin enabled and disable
* Focus on using environment varables to modify functionality of PMS
* Easy Uninstall process that leaves your system in the orginal state before installing PMS
* Easy to extend and overwrite any file, even the PMS core
* [View All PMS Features](/pms/features.html)

# Getting Started
## Requirements
* curl or wget
* git
* A shell such as bash, zsh, etc.

## Installation
Installation can be done manually or by using curl or wget.

### Using curl
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/JoshuaEstes/pms/master/scripts/install.sh)"
```

### Using wget
```
sh -c "$(wget -O- https://raw.githubusercontent.com/JoshuaEstes/pms/master/scripts/install.sh)"
```

### Manual install
```
curl -Lo install.sh https://raw.githubusercontent.com/JoshuaEstes/pms/master/scripts/install.sh
sh install.sh
```

### Manual install (git)
```
git clone https://github.com/JoshuaEstes/pms.git ~/.pms
# Backup your dotfiles
# mv ~/.zshrc ~/.zshrc.bak
# mv ~/.bashrc ~/.bashrc.bak
# ...
# Copy over the new files
# cp ~/.pms/templates/zshrc ~/.zshrc
# cp ~/.pms/templates/bashrc ~/.bashrc
# ...
```

## Updating PMS using the PMS Manager
### auto
```
pms upgrade
```

### Manual update
```
cd $PMS
git pull origin master
# Copy over new template files
# cp ~/.pms/templates/bashrc ~/.bashrc
# ...
```

# Themes
Themes allow you to change the look and feel of your environment.

```
# List all themes available
pms theme list

# switch to a new theme
pms theme switch default
```

You can manually modify the theme by editing `~/.pms.theme`

# Plugins
Plugins change the functionality of your environment.

```
# List all available plugins
pms plugin list

# Display enabled plugins
pms plugin list enabled

# Enabled a plugin
pms plugin enable example

# Disable a plugin
pms plugin disable example
```

You can manually modify the enabled plugins by editing `~/.pms.plugins`

[View All Plugins](/pms/plugins.html)

# Dotfiles
Dotfiles will change the look and feel of various programs. For example the
"vim" dotfiles will modify how vim works in your environment.

# Shells
PMS supprts a number of different shells. Switching from one shell to another
is easy and allows you to compare which shell works best for you and your needs.

To see a list of shells on your system, you can run `cat /etc/shells`

If PMS does not support your shell, please open an issue.

# Documentation
See the "docs/" directory

# Uninstall
By default, PMS in installed in `~/.pms` directory. You will just need to run
the "uninstall" script and this will revert you system back to how it was before
you installed PMS.

```
cd $PMS && ./scripts/uninstall.sh
```

# License
See [LICENSE.md](https://github.com/JoshuaEstes/pms/blob/master/LICENSE.md)

# @todo
* [CHANGELOG.md](https://github.com/JoshuaEstes/pms/blob/master/CHANGELOG.md)
  * Need to keep track of versions if this happens
* [CONTRIBUTING.md](https://github.com/JoshuaEstes/pms/blob/master/CONTRIBUTING.md)
* [CODE_OF_CONDUCT.md](https://github.com/JoshuaEstes/pms/blob/master/CODE_OF_CONDUCT.md)
* Github Specific Stuff
  * Pull Request Templates
  * Issue Templates
* Break up docs/index.md into multiple files and link to them
