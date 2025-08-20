<pre>
 _______   __                                __       __                   ______   __                  __  __
/       \ /  |                              /  \     /  |                 /      \ /  |                /  |/  |
$$$$$$$  |$$/  _____  ____    ______        $$  \   /$$ | __    __       /$$$$$$  |$$ |____    ______  $$ |$$ |
$$ |__$$ |/  |/     \/    \  /      \       $$$  \ /$$$ |/  |  /  |      $$ \__$$/ $$      \  /      \ $$ |$$ |
$$    $$/ $$ |$$$$$$ $$$$  |/$$$$$$  |      $$$$  /$$$$ |$$ |  $$ |      $$      \ $$$$$$$  |/$$$$$$  |$$ |$$ |
$$$$$$$/  $$ |$$ | $$ | $$ |$$ |  $$ |      $$ $$ $$/$$ |$$ |  $$ |       $$$$$$  |$$ |  $$ |$$    $$ |$$ |$$ |
$$ |      $$ |$$ | $$ | $$ |$$ |__$$ |      $$ |$$$/ $$ |$$ \__$$ |      /  \__$$ |$$ |  $$ |$$$$$$$$/ $$ |$$ |
$$ |      $$ |$$ | $$ | $$ |$$    $$/       $$ | $/  $$ |$$    $$ |      $$    $$/ $$ |  $$ |$$       |$$ |$$ |
$$/       $$/ $$/  $$/  $$/ $$$$$$$/        $$/      $$/  $$$$$$$ |       $$$$$$/  $$/   $$/  $$$$$$$/ $$/ $$/
                            $$ |                         /  \__$$ |
                            $$ |                         $$    $$/
                            $$/                           $$$$$$/
</pre>

Pimp My Shell allows you to manage your shell in a way to that helps decrease
setup time and increases your productivity. It has support for themes (change
the way your shell looks), plugins (adds functionality to your shell), and
dotfile management.

One of the best parts is, the PMS framework allows you to use the same
framework in different shells. Use zsh on your personal laptop, and use bash on
remote servers. Wanna try fish? Go ahead, try out different shells and see the
power of PMS ;)

![CI](https://github.com/JoshuaEstes/pms/workflows/CI/badge.svg?branch=main)

---

# Features

* Themes
* Plugins
  * Plugins do more than just add a bunch of aliases that you will never use
  * Shell Options, Auto Completions, Commands, and more are just some of the
    things plugins can provide.
* Dotfiles
  * Managed through a dedicated plugin
  * Your dotfiles are backed up to your own git repository
* Multiple Shell Support (Bash, Zsh, etc.)
  * Works to load sane defaults for you (with the help of various plugins)
* PMS Manager
  * Easy upgrades for PMS
  * Preview and switch themes with ease
  * Easy to enabled and disable various plugins
* Great Documentation for both Users and Developers

# Requirements

* MacOS or Linux (could work on windows, but I don't use windows)
* Shell such as bash, zsh, etc.
* curl or wget
* git

# Installation

Installation can be done manually or by using curl or wget.

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/JoshuaEstes/pms/main/scripts/install.sh)"
```

# FAQs

## Why use PMS?

PMS allows you to work within a framework designed to be used with any shell
(zsh, bash, etc.). Because everything is "standardized" you gain the benefit of
having the ability to use PMS on your macOS laptop running zsh and also the
linux server running bash. Co-workers can use this while using different
plugins, themes, shells, etc.

PMS ships with the PMS Manager, which is a tool that will allow you to make easy
modifications to PMS such as switching themes, enabling/disabling plugins, and
helping you keep PMS updated with the latest release.

PMS also helps you manage your dotfiles.

PMS is easy to install and is as non-destructive as possible backing up existing
rc files and reverted them when uninstalled.

## What is a plugin?

A plugin changes the behaviour of the shell. This is done by setting or
unsetting shell specific features. Plugins may also include aliases for you to
use or contain functionality that will be ran when you do things within PMS like
upgrading PMS, enable/disable plugins. Plugins may also have settings that can
be modified by editing your ~/.env file.

## What is a theme?

Themes change the look of your shell by modifying your command prompt. They may
also do things like change or load colors. If a theme does make changes, it will
revert those changes when you switch to another theme.

## How are my dotfiles managed?

There is a [great article](https://www.atlassian.com/git/tutorials/dotfiles) on
using a bare git repo to store your dotfiles. This is how PMS works to manage
your dotfiles but provides some extra functionality to make it easier to manage.

By managing your files like this, it will not require any of your files to be
symlinked. Another benefit of managing your dotfiles like this is we can do some
really cool shit with git.

# Documentation

* [User Guides](https://docs.codewithjoshua.com/pms)
* [Developer Guides](https://docs.codewithjoshua.com/pms)

# Tests

PMS uses [Bats](https://bats-core.readthedocs.io/) for unit tests. After
installing Bats with your package manager (for example, `sudo apt-get install
bats` or `brew install bats-core`), run all tests with:

```
bats tests
```

