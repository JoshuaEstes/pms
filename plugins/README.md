# Plugins

Core plugins live in this directory. Each plugin may contain:

- `env` files for environment setup
- `*.plugin.sh` or `*.plugin.<shell>` scripts for functionality
- An optional `completions` directory with shell completion scripts

When a plugin includes a `completions` directory, PMS automatically adds it to
the shell's lookup path. For zsh, the path is appended to `fpath` before
`compinit` runs so the provided completions are available.
