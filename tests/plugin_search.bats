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

@test "plugin search shows code" {
    run __pms_command_plugin_search example
    [ "$status" -eq 0 ]
    case "$output" in
        *example*) ;;
        *) false ;;
    esac
}

@test "plugin search shows description" {
    run __pms_command_plugin_search example
    [ "$status" -eq 0 ]
    case "$output" in
        *"Example Plugin"*) ;;
        *) false ;;
    esac
}

@test "plugin search shows repository" {
    run __pms_command_plugin_search example
    [ "$status" -eq 0 ]
    case "$output" in
        *"pms-example-plugin.git"*) ;;
        *) false ;;
    esac
}

