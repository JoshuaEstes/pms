---
title: PMS "history" Plugin
toc: true
toc_sticky: true
---

# history

Provides persistent command history for zsh sessions.

## Environment Variables

| Variable   | Default                   | Description                     |
| ---------- | ------------------------- | ------------------------------- |
| `HISTFILE` | `$PMS/cache/zsh_history`   | Location of the history file    |
| `HISTSIZE` | `50000`                   | Commands kept in memory         |
| `SAVEHIST` | `10000`                   | Commands saved to disk          |

## See Also

* [Plugin Source Code](https://github.com/JoshuaEstes/pms/tree/main/plugins/history)
