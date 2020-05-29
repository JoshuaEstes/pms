---
title: PMS Manager
toc: true
toc_sticky: true
---

The PMS Manager is what you will use most of the time when you want to interact
with the PMS framework. This allows you to do things such as enable/disable
[plugins](/pms/plugins.html) and switch to different [themes](/pms/themes.html).

You can run `pms help` at any time to get information on all the commands the
PMS Manager supports.

# Managing Plugins

Plugins modify shell behaviour such as loading auto-completion scripts, adding
aliases, or modifying shell options. Plugins are managed using the `pms plugin`
command.

## Listing Current Plugins

```shell
pms plugin list
```

## Enabling Plugins

```shell
pms plugin enable [PLUGIN]
```

## Disabling Plugins

```shell
pms plugin disable [PLUGIN]
```

# Managing Themes

Themes will modify how you shell looks. These are things such as colors and
usually includes a kick ass command prompt.

*Note* Some themes may enable or disable PMS plugins for functionality. An
example of this would be a theme that would require the "git-prompt" plugin so
it has access to that functionality. This is done for you so you don't need to
do this by hand
{: .notice--warning}

## Listing Themes

This will show you all the available themes you are able to switch to.

```shell
pms theme list
```

## Switching Themes

```shell
pms theme switch [THEME]
```
