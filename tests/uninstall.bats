#!/usr/bin/env bats

@test "uninstall aborts on uppercase N" {
    HOME="$BATS_TMPDIR"
    touch "$HOME/.pms.theme"
    run bash -c "printf 'N\n' | scripts/uninstall.sh"
    [ "$status" -eq 0 ]
    [ -f "$HOME/.pms.theme" ]
    case "$output" in
        *Canceled*) ;;
        *) false ;;
    esac
}

@test "uninstall removes files on uppercase Y" {
    HOME="$BATS_TMPDIR"
    mkdir "$HOME/.pms"
    touch "$HOME/.pms.theme"
    run bash -c "printf 'Y\n' | scripts/uninstall.sh"
    [ "$status" -eq 0 ]
    [ ! -f "$HOME/.pms.theme" ]
    [ ! -d "$HOME/.pms" ]
    case "$output" in
        *"PMS has been uninstalled"*) ;;
        *) false ;;
    esac
}
