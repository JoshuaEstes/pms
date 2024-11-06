---
title: Environment Variables
---

# Environment Variables

PMS will search for and load a few different .env files to help you configure how PMS works.

.env files, if they exist, are loaded in the following order:

1. `$HOME/.env`
2. `$HOME/.env.{SHELL}`
3. `$HOME/.env.local`
4. `$HOME/.env.{SHELL}.local`

{% hint style="info" %}
_**{SHELL}**_ will be **zsh**, **bash**, **fish**, etc. depending on the shell you are using.&#x20;
{% endhint %}

PMS Loads .env files in this order to allow you different configuration options. These files are where you will overwrite environment variables defined by [plugins](plugins/) to modify behavior.

<table><thead><tr><th width="223">Environment Variable</th><th>Description</th></tr></thead><tbody><tr><td><code>PMS</code></td><td>Directory where PMS is installed</td></tr><tr><td><code>PMS_LOCAL</code></td><td>Directory where local files are stored</td></tr><tr><td><code>PMS_DEBUG</code></td><td>0 = disabled, 1 = enabled. Enabling debug will produce debug messages</td></tr><tr><td><code>PMS_REPO</code></td><td></td></tr><tr><td><code>PMS_REMOTE</code></td><td></td></tr><tr><td><code>PMS_BRANCH</code></td><td></td></tr><tr><td><code>PMS_THEME</code></td><td></td></tr><tr><td><code>PMS_PLUGINS</code></td><td></td></tr></tbody></table>
