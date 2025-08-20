# shellcheck shell=bash
####
# Timing helpers for PMS
####

# Arrays to hold timing data for plugins
PMS_PLUGIN_TIME_NAMES=()
PMS_PLUGIN_TIME_VALUES=()

####
# Return the current time in milliseconds.
#
# Usage:
#   _pms_now
####
_pms_now() {
    local current_time
    if current_time=$(date +%s%3N 2>/dev/null); then
        printf '%s\n' "$current_time"
    else
        printf '%s000\n' "$(date +%s)"
    fi
}

####
# Measure the execution time of a command and store the result.
#
# Usage:
#   _pms_time label command [args...]
####
_pms_time() {
    local timing_label=$1
    shift
    local start_time
    local end_time
    local elapsed_time
    local exit_code
    start_time=$(_pms_now)
    "$@"
    exit_code=$?
    end_time=$(_pms_now)
    elapsed_time=$(( end_time - start_time ))
    PMS_PLUGIN_TIME_NAMES+=("$timing_label")
    PMS_PLUGIN_TIME_VALUES+=("$elapsed_time")
    return $exit_code
}

