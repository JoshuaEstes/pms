####
# pms.sh
####
#set -xe

# 1) Environment Variable Defaults
PMS_SHELL=$1
PMS_DEBUG=$2
PMS_THEME=default

# 2) environment file loader
# load the plugins and theme first so that they can be modified later
if [ -f ~/.pms.plugins ]; then
  source ~/.pms.plugins
fi
if [ -f ~/.pms.theme ]; then
  source ~/.pms.theme
fi
if [ -f ~/.env ]; then
  source ~/.env
fi
if [ -f ~/.env.$1 ]; then
  source ~/.env.$1
fi
if [ -f ~/.env.local ]; then
  source ~/.env.local
fi
if [ -f ~/.env.$1.local ]; then
  source ~/.env.$1.local
fi

if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "-=[ PMS ]=-"
  echo "PMS:         $PMS"
  echo "PMS_LOCAL:   $PMS_LOCAL"
  echo "PMS_DEBUG:   $PMS_DEBUG"
  echo "PMS_REPO:    $PMS_REPO"
  echo "PMS_REMOTE:  $PMS_REMOTE"
  echo "PMS_BRANCH:  $PMS_BRANCH"
  echo "PMS_THEME:   $PMS_THEME"
  echo "PMS_PLUGINS: $PMS_PLUGINS"
  echo "PMS_SHELL:   $PMS_SHELL"
  echo
  echo "-=[ Args ]=-"
  echo "1: $1" # PMS_SHELL
  echo "2: $2" # PMS_DEBUG
  echo
fi

if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] PMS Loading Starting"
fi

# 3) Load libraries (sh and PMS_SHELL)
# @todo local overwrites
for lib in $PMS/lib/*.{sh,$PMS_SHELL}; do
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] Loading Library '$(basename $lib)'"
  fi
  source $lib
done

# 4) Load plugins
# make sure the pms and "PMS_SHELL" plugins are loaded up
_pms_load_plugin pms
_pms_load_plugin $PMS_SHELL
for plugin in "${PMS_PLUGINS[@]}"; do
  _pms_load_plugin $plugin
done

# 5) load theme
_pms_load_theme $PMS_THEME

if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] PMS Loading Complete"
fi
