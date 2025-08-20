# PHPBrew

Loads PHPBrew integration and provides optional update hooks.

## Configuration

- `PHPBREW_SET_PROMPT` – set to `1` to show PHP version in the prompt.
- `PHPBREW_RC_ENABLE` – search for `.phpbrewrc` files (default `1`).
- `PMS_PHPBREW_SELFUPDATE` – run `phpbrew self-update` during PMS upgrades.
- `PMS_PHPBREW_UPDATE` – refresh known PHP versions during PMS upgrades.

## Usage

Ensure PHPBrew is installed; the plugin sources `~/.phpbrew/bashrc` when present.
