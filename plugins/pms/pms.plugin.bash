# @todo find somewhere else to shove these
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

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
