---
title: Installation
---

# Installation

Installing can be done quick and easy by using curl. The installation process
will not overwrite any files and will backup your current rc files.

## Using curl

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/JoshuaEstes/pms/main/scripts/install.sh)"
```

## Using wget

```sh
sh -c "$(wget -O- https://raw.githubusercontent.com/JoshuaEstes/pms/main/scripts/install.sh)"
```

## "Manual" Install

```sh
curl -Lo install.sh https://raw.githubusercontent.com/JoshuaEstes/pms/main/scripts/install.sh
sh install.sh
```
