#!/usr/bin/env bats

# shellcheck disable=SC2016
@test "default zsh theme includes vcs_info in PROMPT" {
    run env PMS="$(cd "$BATS_TEST_DIRNAME/.." && pwd)" zsh -c '
        source "$PMS/themes/default/default.theme.zsh"
        echo "$PROMPT"
    '
    [ "$status" -eq 0 ]
    [[ "${lines[0]}" == *"vcs_info_msg_0_"* ]]
}

