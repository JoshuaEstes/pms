#!/usr/bin/env bats

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
    export PMS_LOCAL="$BATS_TEST_TMPDIR/local"
    mkdir -p "$PMS_LOCAL/plugins"
    export PMS_SHELL="bash"
    export PMS_DEBUG=0
    export HOME="$BATS_TEST_TMPDIR"
    export PMS_PLUGINS=()
    mkdir -p "$BATS_TEST_TMPDIR/bin"
    PATH="$BATS_TEST_TMPDIR/bin:$PATH"
    cat >"$BATS_TEST_TMPDIR/bin/fzf" <<'FZF'
#!/usr/bin/env bash
echo "bash"
FZF
    chmod +x "$BATS_TEST_TMPDIR/bin/fzf"
    # shellcheck disable=SC2034
    color_blue=""
    # shellcheck disable=SC2034
    color_red=""
    # shellcheck disable=SC2034
    color_green=""
    # shellcheck disable=SC2034
    color_yellow=""
    # shellcheck disable=SC2034
    color_reset=""
    # shellcheck source=../lib/core.sh disable=SC1091
    source "$PMS/lib/core.sh"
    # shellcheck source=../lib/cli.sh disable=SC1091
    source "$PMS/lib/cli.sh"
}

@test "plugin enable uses fzf when no argument" {
    __pms_command_plugin_enable
    [[ "${PMS_PLUGINS[*]}" == *"bash"* ]]
}
