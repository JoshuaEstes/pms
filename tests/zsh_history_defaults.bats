#!/usr/bin/env bats

setup() {
    pms_root="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
    export PMS="$pms_root"
}

@test "HISTSIZE defaults to 10000" {
    run zsh -c "unset HISTSIZE; source \"$PMS/plugins/zsh/env\"; printf '%s\n' \"\$HISTSIZE\""
    [ "$status" -eq 0 ]
    [ "${lines[0]}" -eq 10000 ]
}

@test "SAVEHIST defaults to 10000" {
    run zsh -c "unset SAVEHIST; source \"$PMS/plugins/zsh/env\"; printf '%s\n' \"\$SAVEHIST\""
    [ "$status" -eq 0 ]
    [ "${lines[0]}" -eq 10000 ]
}

@test "HISTFILE defaults to \$HOME/.zsh_history" {
    run zsh -c "unset HISTFILE; export HOME=\"$BATS_TEST_TMPDIR\"; source \"$PMS/plugins/zsh/env\"; printf '%s\n' \"\$HISTFILE\""
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "$BATS_TEST_TMPDIR/.zsh_history" ]
}

@test "HIST_IGNORE_ALL_DUPS defaults to 1" {
    run zsh -c "unset HIST_IGNORE_ALL_DUPS; source \"$PMS/plugins/zsh/env\"; printf '%s\n' \"\$HIST_IGNORE_ALL_DUPS\""
    [ "$status" -eq 0 ]
    [ "${lines[0]}" -eq 1 ]
}
