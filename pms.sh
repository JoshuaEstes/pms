####
# pms.sh
####
#set -xe
# 1) Environment Variable Defaults
PMS_SHELL=$1
PMS_DEBUG=$2
PMS_THEME=default

if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] Initializing PMS"
fi

# 2) environment file loader
# load the plugins and theme first so that they can be modified later
if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] PMS Loading Environment Files"
fi
# .pms.plugins
if [ -f ~/.pms.plugins ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] loading env file '~/.pms.plugins'"
  fi
  source ~/.pms.plugins
else
  echo "[ERROR] ~/.pms.plugins could not be found"
fi
# .pms.theme
if [ -f ~/.pms.theme ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] loading env file '~/.pms.theme'"
  fi
  source ~/.pms.theme
else
  echo "[ERROR] ~/.pms.theme could not be found"
fi
# .env
if [ -f ~/.env ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] loading env file '~/.env'"
  fi
  source ~/.env
else
  echo "[ERROR] ~/.env could not be found"
fi
# .env.$PMS_SHELL
if [ -f ~/.env.$PMS_SHELL ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] loading env file '~/.env.$PMS_SHELL'"
  fi
  source ~/.env.$PMS_SHELL
else
  echo "[ERROR] ~/.env.$PMS_SHELL could not be found"
fi
# .env.local
if [ -f ~/.env.local ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] loading env file '~/.env.local'"
  fi
  source ~/.env.local
else
  echo "[ERROR] ~/.env.local could not be found"
fi
# .env.$PMS_SHELL.local
if [ -f ~/.env.$PMS_SHELL.local ]; then
  if [ "$PMS_DEBUG" -eq "1" ]; then
    echo "[DEBUG] loading env file '~/.env.$PMS_SHELL.local'"
  fi
  source ~/.env.$PMS_SHELL.local
else
  echo "[ERROR] ~/.env.$PMS_SHELL.local could not be found"
fi

# Dump some environment variables not that settings are loaded
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
  echo "[DEBUG] PMS Load Completed"
fi
