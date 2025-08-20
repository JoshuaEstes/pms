---
title: PMS "kubernetes" Plugin
toc: true
pms_plugin: kubernetes
---

# kubernetes

## Installation

```sh
pms plugin enable kubernetes
```

## Requirements

* kubectl

## Aliases

| Alias | Command | Notes |
| ----- | ------- | ----- |
| k     | kubectl |       |

## Environment Helpers

The `kube_set_default_config` function sets `KUBECONFIG` to `~/.kube/config` if it is unset.

## Prompt Indicators

Use `kube_prompt_context` to show the current Kubernetes context in your prompt:

```sh
PS1='\u@\h \w $(kube_prompt_context)\$ '
```

## See Also

* [Plugin Source Code](https://github.com/JoshuaEstes/pms/tree/main/plugins/kubernetes)
