---
title: Upgrade PMS
classes: wide
---

Upgrading to the latest version of PMS is easy peezy. Just run the command:

```
pms upgrade
```

***Plugins my upgrade as well***: Please be aware that some plugins hook into
this and once PMS has been upgraded, some of your enabled plugins may make calls
to upgrade various binaries. An example of this is the
[composer](/pms/plugins/composer.html) plugin that will upgrade composer to the
latest release. Reference the plugin's documentation for instructions on how to
disable or enable these features.
{: .notice--warning}
