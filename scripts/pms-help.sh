#!/usr/bin/env bash
#set -e
#PMS=${PMS:-~/.pms}

echo
echo "Usage: pms [OPTIONS] COMMAND"
echo
echo "Options:"
echo "  -d                 Enable Debug"
echo
echo "Commands:"
echo "  about              Show PMS information"
echo "  help               Show help messages"
echo "  upgrade            Upgrade PMS to latest version"
echo "  theme              Helps to manage themes"
echo "    list             Displays available themes"
echo "    switch           Switch to a specific theme"
echo "    install          Installs a theme that is not part of the PMS core"
echo "  plugin             Helps to manage plugins"
echo "    list             Lists all available pluings"
echo "    enable           Enables a plugin"
echo "    disable          Disables a plugin"
echo "    install          Installs a plugin that is not part of the PMS core"
echo "  reload             Reloads PMS"
echo
