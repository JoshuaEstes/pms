---
title: PMS "composer" Plugin
toc: true
pms_plugin: composer
---

# composer

Adds a few aliases for working with composer and will keep composer up-to-date with the latest releases.

## Environment Variables

| Variable                  | Default | Notes                                                                                                          |
| ------------------------- | ------- | -------------------------------------------------------------------------------------------------------------- |
| PMS\_COMPOSER\_AUTOUPDATE | 0       | Setting this to 1 upgrade composer to the lastest when PMS is upgraded. To disable this feature, set this to 0 |

## Aliases

| Alias | Command         | Notes |
| ----- | --------------- | ----- |
| c     | composer        |       |
| cup   | composer update |       |

## See Also

* [Plugin Source Code](https://github.com/JoshuaEstes/pms/tree/main/plugins/composer)
