---
title: Profiling Startup Times
---

# Profiling Startup Times

PMS measures how long each plugin takes to load. These timings are collected during startup and can be viewed with the diagnostic command.

## Viewing Timings

Run the diagnostic command after PMS has loaded:

```
pms diagnostic
```

The output includes a **Plugin Timings** section listing each plugin and the time in milliseconds required to load it.

## Interpreting Results

Plugins that take significantly longer than others may slow down your shell's startup time. Consider disabling or optimizing those plugins if performance becomes an issue.
