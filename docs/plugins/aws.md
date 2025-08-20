---
title: PMS "aws" Plugin
toc: true
pms_plugin: aws
---

# aws

## Installation

```sh
pms plugin enable aws
```

## Requirements

* awscli

## Aliases

| Alias | Command         | Notes                    |
| ----- | --------------- | ------------------------ |
| awsp  | aws_set_profile | Sets the AWS_PROFILE var |

## Environment Helpers

The `aws_set_profile` function updates the `AWS_PROFILE` environment variable.

## Prompt Indicators

Use `aws_prompt_profile` to include the active AWS profile in your prompt:

```sh
PS1='\u@\h \w $(aws_prompt_profile)\$ '
```

## See Also

* [Plugin Source Code](https://github.com/JoshuaEstes/pms/tree/main/plugins/aws)
