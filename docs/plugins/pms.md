---
layout: default
title: PMS "pms" Plugin
---
{% include plugin_header.md %}

# pms
The "pms" plugin will always load. It provides the PMS Manager along with a few extra goodies to help
manage PMS.

This plugin cannot be disabled.

# Enviroment Variables
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Default</th>
      <th>Notes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>PMS</td>
      <td>~/.pms</td>
      <td>Path where PMS is installed</td>
    </tr>
    <tr>
      <td>PMS_LOCAL</td>
      <td>~/.pms/local</td>
      <td>Path where local overrides are kept</td>
    </tr>
    <tr>
      <td>PMS_DEBUG</td>
      <td>0</td>
      <td>Debug mode. 0 = disabled, 1 = enabled</td>
    </tr>
    <tr>
      <td>PMS_REPO</td>
      <td>JoshuaEstes/pms</td>
      <td>Name of PMS repository</td>
    </tr>
    <tr>
      <td>PMS_REMOTE</td>
      <td>https://github.com/JoshuaEstes/pms.git</td>
      <td>The git remote url to use that houses PMS</td>
    </tr>
    <tr>
      <td>PMS_BRANCH</td>
      <td>master</td>
      <td>The branch for PMS to use</td>
    </tr>
    <tr>
      <td>PMS_THEME</td>
      <td>default</td>
      <td>The theme to use with PMS</td>
    </tr>
    <tr>
      <td>PMS_PLUGINS</td>
      <td>pms $PMS_SHELL</td>
      <td>A list of PMS Plugins to load</td>
    </tr>
    <tr>
      <td>PMS_SHELL</td>
      <td>sh</td>
      <td>Depending on the shell you are using (bash, zsh, etc.) this will change. It should never be set by hand.</td>
    </tr>
  </tbody>
</table>

# Functions
<table>
  <thead>
    <tr>
      <th>Function</th>
      <th>Notes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>pms</td>
      <td>PMS Manager</td>
    </tr>
  </tbody>
</table>

# See Also
* [Plugin Source Code](https://github.com/JoshuaEstes/pms/tree/master/plugins/pms)
* @todo Link to pms_manager.md
