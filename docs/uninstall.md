---
title: Uninstall PMS
classes: wide
---

To uninstal you will need to navigate to the directory where PMS is currently
installed. Usually `$HOME/.pms`. The uninstall script is pretty verbose and will
ask before it removes or modifies files, other than PMS related.

```
sh scripts/uninstall.sh
```

Uninstalling PMS will

* Revert your rc files to the previous copies
* Remove all PMS configuration files
* Remove the PMS installation
