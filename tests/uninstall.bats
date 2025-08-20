#!/usr/bin/env bats

@test "uninstall aborts on uppercase N" {
    HOME="$BATS_TMPDIR"
    touch "$HOME/.pms.theme"
    run bash -c "printf 'N\n' | scripts/uninstall.sh"
    [ "$status" -eq 0 ]
    [ -f "$HOME/.pms.theme" ]
    [[ "$output" == *Canceled* ]]
}

@test "uninstall removes files on uppercase Y" {
    HOME="$BATS_TMPDIR"
    mkdir "$HOME/.pms"
    touch "$HOME/.pms.theme"
    run bash -c "printf 'Y\n' | scripts/uninstall.sh"
    [ "$status" -eq 0 ]
    [ ! -f "$HOME/.pms.theme" ]
    [ ! -d "$HOME/.pms" ]
    [[ "$output" == *"PMS has been uninstalled"* ]]
}
