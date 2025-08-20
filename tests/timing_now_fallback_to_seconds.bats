#!/usr/bin/env bats

@test "_pms_now falls back to seconds when milliseconds unavailable" {
    tmp_dir=$(mktemp -d)
    PATH="$tmp_dir:$PATH"
    cat >"$tmp_dir/date" <<'SCRIPT'
#!/bin/sh
if [ "$1" = "+%s%3N" ]; then
    printf '%s\n' "1692553041N"
    exit 0
fi
exec /bin/date "$@"
SCRIPT
    chmod +x "$tmp_dir/date"
    run bash -c '. lib/core/timing.sh; _pms_now'
    [ "$status" -eq 0 ]
    case $output in
        (*[!0-9]*) false ;;
        (*000) ;;
        (*) false ;;
    esac
}
