#!/usr/bin/env bats

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
    export PMS_CACHE_DIR="$BATS_TEST_TMPDIR/cache"
    mkdir -p "$PMS_CACHE_DIR"
    export PMS_SHELL="zsh"
}

@test "_pms_plugin_load adds completion directory to fpath" {
    run zsh -c "source \"$PMS/lib/core.sh\"; _pms_plugin_load test-completion >/dev/null; print -l -- \$fpath"
    [ "$status" -eq 0 ]
    expected="$PMS/plugins/test-completion/completions"
    [[ "$output" == *"$expected"* ]]
}
