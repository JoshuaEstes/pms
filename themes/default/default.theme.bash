if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] default.theme.bash start"
fi

PS1='[PMS] \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "[DEBUG] default.theme.bash complete"
fi
