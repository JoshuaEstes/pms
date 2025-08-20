---
title: PMS Features
---

# Features

* [Themes](themes/)
* [Plugins](plugins/)
* Dotfiles Plugin for managing configuration files
* Multiple Shell Support
  * No matter the shell, you can easily swap between them and maintain similar functionality
* PMS Manager
  * Easily upgrade PMS
  * Preview and switch themes
  * Easily enable and disable plugins
  * Helps manage dotfiles
* Focus on using environment variables to modify functionality of PMS
* Easy to extend and overwrite any file, even the PMS core
* Project configuration with `.pms` files
* Easy uninstall

## Project configuration files

Projects can include a `.pms` file in their directory tree. PMS searches the
current directory and each parent directory for this file during startup. If
found, the file is sourced and can override user defaults.

The file is plain shell script and supports variables such as `PMS_PLUGINS` and
`PMS_THEME`.

```sh
PMS_THEME=solarized
PMS_PLUGINS=(git docker)
```
