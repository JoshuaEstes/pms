# shellcheck shell=bash
####
# File and project helpers for PMS
####

####
# Source a given file and provide feedback based on configuration.
#
# Usage:
#   _pms_source_file /path/to/file
####
_pms_source_file() {
    if [ -f "$1" ]; then
        if [ "${PMS_DEBUG:-0}" -eq 1 ]; then
            _pms_message "" "source $1"
        fi
        # shellcheck source=/dev/null
        source "$1"
    fi
}

####
# Search upwards for a '.pms' file and source it.
#
# Returns 0 if a project file is loaded, 1 otherwise.
#
# Usage:
#   _pms_project_file_load
####
_pms_project_file_load() {
    local search_dir="$PWD"
    local project_file
    while [ "$search_dir" != "/" ]; do
        project_file="$search_dir/.pms"
        if [ -f "$project_file" ]; then
            _pms_message_section "info" "project" "Loading '$project_file'"
            # shellcheck source=/dev/null
            source "$project_file"
            return 0
        fi
        search_dir=$(dirname "$search_dir")
    done
    return 1
}

