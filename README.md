PMS (Pimp My Shell)
===================

This is a framework for using different shells along with various "dotfiles".
It supports easy install/uninstall and a wide variety of plugins and themes

# Getting Started

## Requirements
  * curl or wget
  * git
  * A shell such as bash, zsh, etc.

## Installation
Installation can be done manually or by using curl or wget

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
```

## Updating PMS
### auto
```
pms upgrade
```

### Manual update
```
cd ~/.pms
git pull origin master
```

# Themes
```
# List all themes available
pms theme list

# switch to a new theme
pms theme switch default
```

# Plugins
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

# Shells
PMS supprts a number of different shells. Switching from one shell to another
is easy and allows you to compare which shell works best for you and your needs.

To see a list of shells, you can run `cat /etc/shells`

# Documentation
See the "docs/" directory

# License
See [LICENSE.md](https://github.com/JoshuaEstes/pms/blob/master/LICENSE.md)

# @todo
  * [CHANGELOG.md](https://github.com/JoshuaEstes/pms/blob/master/CHANGELOG.md)
  * [CONTRIBUTING.md](https://github.com/JoshuaEstes/pms/blob/master/CONTRIBUTING.md)
  * [CODE_OF_CONDUCT.md](https://github.com/JoshuaEstes/pms/blob/master/CODE_OF_CONDUCT.md)
  * .github/ directory
    * actions
    * pull request templates
    * issue templates
