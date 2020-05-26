#!/usr/bin/env bash
echo "plugins/pms/pms.plugin.bash | PMS_DEBUG: $PMS_DEBUG"

# Load libs
# @todo local overwrites
for lib in $PMS/lib/*.bash; do
  source $lib
done

# Load plugins
for plugin in "${plugins[@]}"; do
  if [ -f $PMS_LOCAL/plugins/$plugin/$plugin.plugin.bash ]; then
    source $PMS_LOCAL/plugins/$plugin/$plugin.plugin.bash
  elif [ -f $PMS/plugins/$plugin/$plugin.plugin.bash ]; then
    source $PMS/plugins/$plugin/$plugin.plugin.bash
  else
    echo "[pms] Could not load plugin '$plugin'"
  fi
done

# Load theme
if [ -f $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.bash ]; then
  source $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.bash
elif [ -f $PMS/themes/$PMS_THEME/$PMS_THEME.theme.bash ]; then
  source $PMS/themes/$PMS_THEME/$PMS_THEME.theme.bash
else
  echo "[pms] Could not load theme '$PMS_THEME.theme.bash'"
fi
