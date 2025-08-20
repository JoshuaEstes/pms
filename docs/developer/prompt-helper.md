---
title: Prompt Helper
---

# _pms_prompt

The `_pms_prompt` function simplifies asking users for input from shell scripts.
It supports optional default values and validation patterns.

## Usage

```sh
response=$(_pms_prompt "Continue? [y/N]" "n" "[yYnN]")
```

Parameters:

1. **Prompt** – message displayed to the user.
2. **Default** – value used when the user presses enter.
3. **Validation** – optional regular expression the response must match.

The validated response is printed to standard output for assignment.
