#!/usr/bin/env bash

echo $PMS
echo $PMS_LOCAL
echo $PMS_THEME
echo $SHORT_SHELL

# Load plugins
for plugin in "${plugins[@]}"; do
  if [ -f $PMS_LOCAL/plugins/$plugin/$plugin.plugin.$SHORT_SHELL ]; then
    echo "Loading Custom Plugin >>> $plugin"
    source $PMS_LOCAL/plugins/$plugin/$plugin.plugin.$SHORT_SHELL
  elif [ -f $PMS/plugins/$plugin/$plugin.plugin.$SHORT_SHELL ]; then
    echo "Loading Plugin >>> $plugin"
    source $PMS/plugins/$plugin/$plugin.plugin.$SHORT_SHELL
  else
    echo "Could not load plugin >>> $plugin"
  fi
done

# Load theme
if [ -f $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.$SHORT_SHELL-theme ]; then
  source $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.$SHORT_SHELL-theme
elif [ -f $PMS/themes/$PMS_THEME/$PMS_THEME.$SHORT_SHELL-theme ]; then
  source $PMS/themes/$PMS_THEME/$PMS_THEME.$SHORT_SHELL-theme
else
  echo "Could not load theme >>> $PMS_THEME.$SHORT_SHELL-theme"
fi
