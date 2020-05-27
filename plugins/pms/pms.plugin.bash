# @todo find somewhere else to shove these
# Load libs
# @todo local overwrites
for lib in $PMS/lib/*.bash; do
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] Library '$lib' Loading..."
  fi
  source $lib
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] Library '$lib' Loaded"
  fi
done

# Load plugins
# make sure bash is loaded
PMS_PLUGINS+=(bash)

# @todo make function for all this
for plugin in "${PMS_PLUGINS[@]}"; do
  if [ -f $PMS_LOCAL/plugins/$plugin/$plugin.plugin.bash ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading plugin '$plugin' via local"
    fi
    source $PMS_LOCAL/plugins/$plugin/$plugin.plugin.bash
  elif [ -f $PMS/plugins/$plugin/$plugin.plugin.bash ]; then
    if [ "$PMS_DEBUG" -eq "1" ]; then
      echo "[DEBUG] Loading plugin '$plugin'"
    fi
    source $PMS/plugins/$plugin/$plugin.plugin.bash
  else
    echo "[ERROR] Plugin '$plugin' could not be loaded"
  fi
done

# Load theme
# @todo make function for all this
if [ -f $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.bash ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] Loading theme '$PMS_THEME' via local"
  fi
  source $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.bash
elif [ -f $PMS/themes/$PMS_THEME/$PMS_THEME.theme.bash ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] Loading theme '$PMS_THEME'"
  fi
  source $PMS/themes/$PMS_THEME/$PMS_THEME.theme.bash
else
  echo "[ERROR] Theme '$PMS_THEME' could not be loaded, loading the 'default' theme"
  source $PMS/themes/default/default.theme.bash
fi
