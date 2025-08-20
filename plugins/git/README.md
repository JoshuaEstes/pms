# Git

## Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `g`   | `git`   | Shorter alias for `git`. |
| `gd`  | `git d` | Runs `git d`. |
| `gs`  | `git s` | Runs `git s`. |
| `gr`  | `git r` | Runs `git r`. |

## Global Git Ignore

The plugin maintains a user-level global gitignore file at
`$HOME/.config/git/ignore`. The file can be changed by setting the
`GIT_GLOBAL_IGNORE_FILE` environment variable before loading the plugin.

On activation the plugin configures `core.excludesFile` to point to this
file if it is not already set.

### Updating

Use the `git_global_ignore_update` command to replace the current contents
with templates from [github/gitignore](https://github.com/github/gitignore):

```sh
git_global_ignore_update macOS Emacs
```

Multiple template names may be supplied. An alias `ggiu` is also
available.

