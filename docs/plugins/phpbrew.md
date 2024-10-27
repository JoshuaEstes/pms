---
title: PMS "phpbrew" Plugin
pms_plugin: phpbrew
toc: true
toc_sticky: true
---

# phpbrew

[PHPBrew](https://github.com/phpbrew/phpbrew) is a tool that allows you to easily manage many different php versions and environments. This plugin help configure phpbrew and provides some command line completion for phpbrew.

## Requirements

* [PHPBrew](https://github.com/phpbrew/phpbrew)

## Environment Variables

| Variable                 | Default | Description                                                                          |
| ------------------------ | ------- | ------------------------------------------------------------------------------------ |
| `PMS_PHPBREW_SELFUPDATE` | `0`     | Setting this to `1` will run the command `phpbrew self-update` after PMS is upgraded |
| `PMS_PHPBREW_UPDATE`     | `0`     | Setting this to `1` will run the command `phpbrew update` after PMS is upgraded      |

Please reference documentation on [Environment Variables](phpbrew.md#environment-variables) to learn how to use these.

## See Also

* [Plugin Source Code](https://github.com/JoshuaEstes/pms/tree/main/plugins/phpbrew)
