---
title: PMS Plugins
classes: wide
---

# Plugins

Plugins will contain things such as Commands, Functions, Aliases, Auto Completion Scripts, and more.
Plugins are focused on enhancing your experience in the shell.

## Searching for Plugins

Use the plugin index to find new plugins:

```sh
pms plugin search <term>
```

Omit `<term>` to list all indexed plugins.

## Installing Plugins

Install a plugin directly from a Git repository:

```sh
pms plugin install https://example.com/your/plugin.git
```

The repository is cloned into your local PMS plugins directory and enabled automatically.

## Updating Plugins

Update a plugin to its latest commit:

```sh
pms plugin update <plugin>
```

Replace `<plugin>` with the name of the plugin's directory.
