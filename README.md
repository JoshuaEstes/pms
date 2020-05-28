PMS
===
PMS allows you to manage your shell in a way to that helps decrease setup time
and increases your productivity. It has support for themes (change the way your
shell looks), plugins (adds functionality to your shell), and dotfile
management.

One of the best parts is, the PMS framework allows you to use the same
framework in different shells. Use zsh on your personal laptop, and use bash on
remote servers. Wanna try fish? Go ahead, try out different shells and see the
power of PMS ;)

![CI](https://github.com/JoshuaEstes/pms/workflows/CI/badge.svg?branch=master)

# Features
* [Themes](https://joshuaestes.github.io/pms/themes.html) - Change the way your environment looks
* [Plugins](https://joshuaestes.github.io/pms/plugins.html) - Change the way your environment functions
* Dotfiles - Change the way programs work in your environment
* Multiple Shell Support
  * Bash
  * Zsh
  * And others!
* PMS Manager - Easy to use tool to help you manage PMS
  * Easy upgrades for PMS
  * Preview and switch themes
  * Easy to enabled and disable various plugins
* Focus on using environment variables to modify functionality of PMS
* Easy Uninstall process that leaves your system in the original state before installing PMS
* Documentation for both Users and Developers
  * [User Guides](https://joshuaestes.github.io/pms/)
  * [Developer Guides](https://github.com/JoshuaEstes/pms/wiki)
* [View All Features](https://joshuaestes.github.io/pms/features.html)

# Getting Started
## Requirements
* MacOS or Linux (could work on windows, but I don't use windows)
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

# Documentation
* [User Guides](https://joshuaestes.github.io/pms/) - Guides on using PMS
* [Developer Guides](https://github.com/JoshuaEstes/pms/wiki) - Feel like contributing?


# Uninstall
By default, PMS in installed in `~/.pms` directory. You will just need to run
the "uninstall" script and this will revert you system back to how it was before
you installed PMS.

```
cd $PMS && ./scripts/uninstall.sh
```

# License
See [LICENSE.md](https://github.com/JoshuaEstes/pms/blob/master/LICENSE.md)
