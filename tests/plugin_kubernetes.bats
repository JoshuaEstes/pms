#!/usr/bin/env bats

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
    export PMS_LOCAL="$BATS_TEST_TMPDIR/local"
    mkdir -p "$PMS_LOCAL/plugins"
    export PMS_SHELL="bash"
    export PMS_DEBUG=0
    export HOME="$BATS_TEST_TMPDIR"
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

@test "enabling kubernetes plugin adds k alias" {
    __pms_command_plugin_enable kubernetes
    alias k >/dev/null 2>&1
}

@test "kubernetes plugin sets default KUBECONFIG" {
    unset KUBECONFIG
    __pms_command_plugin_enable kubernetes
    [ "$KUBECONFIG" = "$HOME/.kube/config" ]
}

@test "disabling kubernetes plugin removes it from enabled list" {
    __pms_command_plugin_enable kubernetes
    __pms_command_plugin_disable kubernetes
    run _pms_is_plugin_enabled kubernetes
    [ "$status" -eq 1 ]
}
