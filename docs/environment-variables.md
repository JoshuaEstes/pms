---
title: Environment Variables
---

# Environment Variables

PMS will search for and load a few different .env files to help you
configure how PMS works.

.env files, if they exist, are loaded in the following order:

1. `$HOME/.env`
2. `$HOME/.env.{SHELL}`
3. `$HOME/.env.local`
4. `$HOME/.env.{SHELL}.local`

{% hint style="info" %}
_**{SHELL}**_ will be **zsh**, **bash**, **fish**, etc. depending on the
shell you are using.&#x20;
{% endhint %}

PMS loads .env files in this order to allow you different configuration
options. These files are where you will overwrite environment variables
defined by [plugins](plugins/) to modify behavior.

| Environment Variable | Description |
| --- | --- |
| `PMS` | Directory where PMS is installed |
| `PMS_LOCAL` | Directory where local files are stored |
| `PMS_DEBUG` | 0 = disabled, 1 = enabled. Enables debug messages when set |
| `PMS_REPO` | GitHub repo for PMS (see [install.sh](../scripts/install.sh)) |
| `PMS_REMOTE` | Full Git remote URL (see [install.sh](../scripts/install.sh)) |
| `PMS_BRANCH` | Branch to check out (see [install.sh](../scripts/install.sh)) |
| `PMS_THEME` | Active theme name (loaded in [lib/core.sh](../lib/core.sh)) |
| `PMS_PLUGINS` | Space-separated plugin list (used by [pms.sh](../pms.sh)) |

## Overriding defaults

To override any default, add the variable to one of the supported `.env`
files. For example:

```sh
# ~/.env.local
PMS_REPO=myfork/pms
PMS_REMOTE=https://git.example.com/${PMS_REPO}.git
PMS_BRANCH=development
PMS_THEME=solarized
PMS_PLUGINS=(git docker)
```

Shell-specific overrides such as `.env.zsh.local` take precedence over
the more general files.
