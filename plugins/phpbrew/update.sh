# Self-update, default to master version
if [ "$PMS_PHPBREW_SELFUPDATE" -eq "1" ]; then
    phpbrew self-update
fi

# Update PHP release source file
if [ "$PMS_PHPBREW_UPDATE" -eq "1" ]; then
    phpbrew update
fi
