---
title: Pimp My Shell
---

# Pimp My Shell

PMS is a framework for using different shells along with various "dotfiles". It
supports easy install/uninstall and a wide variety of plugins and themes.

## [Features](features.md)

* [Themes](themes/) - Change the way your environment looks
* [Plugins](plugins/) - Change the way your environment functions
* Dotfiles - Manage configuration files through a plugin-backed git repository
* Multiple Shell Support
  * No matter the shell, you can easily swap between them and maintain similar functionality
* [PMS Manager](pms-manager.md) - Easy to use and up modify tool to help you manage PMS
  * Easy [upgrade](upgrade.md) PMS
  * Preview and switch themes
  * Easy Plugin enabled and disable
* Focus on using [environment variables](environment-variables.md) to modify functionality of PMS
* Easy [Uninstall](installation/uninstall.md) process that leaves your system in the ordinal state before installing PMS
* Easy to extend and overwrite any file, even the PMS core
* [View All Features](features.md)

## Getting Started

### Requirements

* MacOS or Linux (could work on windows, but I don't use windows so get fucked)
* curl or wget
* git
* A shell such as bash, zsh, etc.

[Detailed Requirements](requirements.md)

### Installation

Installation can be done manually or by using curl or wget.

[Detailed Installation Guide](installation/)

### Updating PMS using the PMS Manager

#### auto

```
pms upgrade
```

#### Manual update

```
cd $PMS
git pull origin main
# Copy over new template files
# cp ~/.pms/templates/bashrc ~/.bashrc
# ...
```

## Shells

PMS supprts a number of different shells. Switching from one shell to another is easy and allows you to compare which shell works best for you and your needs.

To see a list of shells on your system, you can run `cat /etc/shells`

If PMS does not support your shell, please open an issue.

## Uninstall

By default, PMS in installed in `~/.pms` directory. You will just need to run the "uninstall" script and this will revert you system back to how it was before you installed PMS.

```
cd $PMS && ./scripts/uninstall.sh
```
[Detailed Uninstall Guide](installation/uninstall.md)

## License

See LICENSE.md
