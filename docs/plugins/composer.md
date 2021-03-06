---
title: PMS "composer" Plugin
toc: true
pms_plugin: composer
---

Adds a few aliases for working with composer and will keep composer up-to-date
with the latest releases.

# Environment Variables

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
      <td>PMS_COMPOSER_AUTOUPDATE</td>
      <td>0</td>
      <td>Setting this to 1 upgrade composer to the lastest when PMS is upgraded. To disable this feature, set this to 0</td>
    </tr>
  </tbody>
</table>

# Aliases

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
      <td>c</td>
      <td>composer</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>cup</td>
      <td>composer update</td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

# See Also
* [Plugin Source Code](https://github.com/JoshuaEstes/pms/tree/master/plugins/{{ page.pms_plugin }})
