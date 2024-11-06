---
title: Upgrade PMS
---

# Upgrade PMS

Upgrading to the latest version of PMS is easy peezy. Just run the command:

```
pms upgrade
```

{% hint style="warning" %}
_**Plugins my upgrade as well**_: Please be aware that some plugins hook into this and once PMS has been upgraded, some of your enabled plugins may make calls to upgrade various binaries. An example of this is the composer plugin that will upgrade composer to the latest release. Reference the plugin's documentation for instructions on how to disable or enable these features.&#x20;
{% endhint %}

