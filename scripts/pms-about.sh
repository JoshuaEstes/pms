#!/usr/bin/env bash
set -e
PMS=${PMS:-~/.pms}

if [ "$PMS_DEBUG" -eq "1" ]; then
  echo "DEBUG MODE HAS BEEN ENABLED"
fi

echo "PMS:       $PMS"
echo "PMS_LOCAL: $PMS_LOCAL"
echo "PMS_THEME: $PMS_THEME"

return
