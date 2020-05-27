# pms plugin list
# @todo Show which ones are installed
# @todo show installed ones first
echo
echo "Core Plugins:"
for plugin in $PMS/plugins/*; do
  plugin=${plugin%*/}
  echo "  ${plugin##*/}"
done
echo
echo "Local Plugins:"
for plugin in $PMS_LOCAL/plugins/*; do
  plugin=${plugin%*/}
  echo "  ${plugin##*/}"
done
echo
