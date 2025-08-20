#!/usr/bin/env bats

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
    export PMS_LOCAL="$BATS_TEST_TMPDIR/local"
    mkdir -p "$PMS_LOCAL/plugins"
    export PMS_SHELL="bash"
    export PMS_DEBUG=0
    color_blue=""
    color_red=""
    color_green=""
    color_yellow=""
    color_reset=""
    source "$PMS/lib/core.sh"
    source "$PMS/lib/cli.sh"
}

@test "plugin install uses code from index" {
    plugin_repo="$BATS_TEST_TMPDIR/sample-plugin"
    mkdir "$plugin_repo"
    git init "$plugin_repo" >/dev/null
    touch "$plugin_repo/sample.plugin.sh"
    git -C "$plugin_repo" add sample.plugin.sh >/dev/null
    git -C "$plugin_repo" commit -m 'init' >/dev/null

    echo "sample|Sample Plugin|Test plugin|$plugin_repo" > "$BATS_TEST_TMPDIR/index.txt"
    export PMS_PLUGIN_INDEX="$BATS_TEST_TMPDIR/index.txt"

    run __pms_command_plugin_install sample
    [ "$status" -eq 0 ]
    [ -d "$PMS_LOCAL/plugins/sample" ]
}

