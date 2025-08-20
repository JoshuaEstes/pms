#!/usr/bin/env bats

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
    export PMS_CACHE_DIR="$BATS_TEST_TMPDIR/cache"
    mkdir -p "$PMS_CACHE_DIR"
}

@test "zsh plugin initializes completions" {
    run zsh -c "source \"$PMS/plugins/zsh/zsh.plugin.zsh\""
    [ "$status" -eq 0 ]
    [ -f "$PMS_CACHE_DIR/zcompdump" ]
}
