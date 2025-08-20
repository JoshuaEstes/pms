---
title: PMS "dotfiles" Plugin
toc: true
pms_plugin: dotfiles
---

# dotfiles

Manage your dotfiles repository using git.

## Requirements

* git

## Usage

```sh
pms plugin enable dotfiles   # enable the plugin
pms dotfiles add ~/.vimrc    # track a file
pms dotfiles push            # push changes
pms dotfiles git status      # run arbitrary git commands
```

## See Also

* [Plugin Source Code](https://github.com/JoshuaEstes/pms/tree/main/plugins/dotfiles)
