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
  source $PMS_LOCAL/themes/$PMS_THEME/$PMS_THEME.theme.bash
elif [ -f $PMS/themes/$PMS_THEME/$PMS_THEME.theme.bash ]; then
  source $PMS/themes/$PMS_THEME/$PMS_THEME.theme.bash
else
  echo "[ERROR] Theme '$PMS_THEME' could not be loaded"
  # @todo if this is the case, should we just load the "default" theme
fi
