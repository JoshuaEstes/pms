---
layout: default
title: PMS "example" Plugin
---
{% include plugin_header.md %}

# example
The example plugin will be documented here. Top part gives a few details.

# Requirements
Requirements are listed here

# Enable
This should always be the same?
```
pms plugin enable example
```

# Options
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
      <td>This doesn't do nothing either</td>
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
      <td>example</td>
      <td>example -als</td>
      <td>This is not a real alias</td>
    </tr>
  </tbody>
</table>

# Functions
| Function            | Notes                               |
|---------------------|-------------------------------------|
| `_example_function` | This doesn't output anything        |
| `example`           | This doesn't output anything either |
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

# Auto Completion
Should this be here?

# See Also
* [Link 1](/pms)
* [Link 2](/pms)
