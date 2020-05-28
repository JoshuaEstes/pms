---
layout: default
title: PMS "__PLUGIN__" Plugin
pms_plugin: __PLUGIN__
---
{% include plugin_header.md %}

# PMS "{{ page.pms_plugin }}" Plugin
Description of plugin and what it does.

# Requirements
<!-- Can Remove Section if no requirements -->
<!--
    Requirements are other plugins, system binaries, etc.
-->
* example >= 1.2.3
* [pms plugin cd](/pms/plugins/cd.html)

# Environment Variables
<!-- Can remove section if no requirements -->
<!-- set in plugin "env" file -->
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
      <td>PMS_EXAMPLE</td>
      <td>1</td>
      <td>This will do nothing</td>
    </tr>
    <tr>
      <td>EXAMPLE</td>
      <td></td>
      <td></td>
    </tr>
  </tbody>
</table>

# Aliases
<!-- Can remove section if no aliases -->
<table>
  <thead>
    <tr>
      <th>Alias</th>
      <th>Command</th>
      <th>Notes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>example</td>
      <td>example -als</td>
      <td></td>
    </tr>
  </tbody>
</table>

# Functions
<!-- Can remove section if no aliases -->
<!--
    If your plugin provides "private" use functions that are used in other
    plugins, they can be excluded here. HOWEVER they need to be documented in
    the developer docs
-->
<table>
  <thead>
    <tr>
      <th>Function</th>
      <th>Notes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>_example_function</td>
      <td>This is not a real function and will not work</td>
    </tr>
    <tr>
      <td>example</td>
      <td>This is not a real function and will not work either</td>
    </tr>
  </tbody>
</table>

# Commands
<!-- Can remove section if no commands -->
<table>
  <thead>
    <tr>
      <th>Command</th>
      <th>Notes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>excmd</td>
      <td>This is not a real command and will not work</td>
    </tr>
  </tbody>
</table>

# Suggested Plugins
<!-- Can remove section -->
<!--
    If this plugin pairs well with another plugin, let users know
-->
* [example](/pms/plugins/example.html)

# Conflicts with Plugins
<!-- Can remove section -->
* [example](/pms/plugins/example.html)

# Known Issues
<!-- Can remove section -->
* Unable to work correctly under DOS
* Alias a will not be available under DOS

# See Also
* [Plugin Source Code](https://github.com/JoshuaEstes/pms/tree/master/plugins/{{ page.pms_plugin }})
* [Link 1](/pms)
* [Link 2](/pms)
