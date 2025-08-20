# shellcheck shell=bash
# shellcheck disable=SC2154
####
# Interactive helper functions for PMS
####

####
# Ask a yes/no question and interpret the answer.
#
# Returns 0 for yes, 1 for no.
#
# Usage:
#   if _pms_question_yn; then
#       ...
#   fi
####
_pms_question_yn() {
    local user_answer
    while true; do
        read -r user_answer
        case ${user_answer:0:1} in
            n|N) return 1 ;;
            y|Y) return 0 ;;
            *) echo "Only 'y' and 'n' are supported" ;;
        esac
    done
}

####
# Display a message optionally prefixed with a type.
#
# Usage:
#   _pms_message "info" "Text"
#   _pms_message "Text"
####
_pms_message() {
    local message_type=$1
    local message_text=$2
    if [ -z "$message_text" ]; then
        message_text=$message_type
    fi
    case $message_type in
        info) printf "\r${color_blue}%s${color_reset}\n" "$message_text" ;;
        success) printf "\r${color_green}%s${color_reset}\n" "$message_text" ;;
        warn) printf "\r${color_yellow}%s${color_reset}\n" "$message_text" ;;
        error) printf "\r${color_red}%s${color_reset}\n" "$message_text" ;;
        debug) printf "\r%s\n" "$message_text" ;;
        *) printf "\r%s\n" "$message_text" ;;
    esac
}

####
# Display a sectioned message.
#
# Usage:
#   _pms_message_section "info" "section" "Message"
####
_pms_message_section() {
    local message_type=$1
    local message_section=$2
    local message_text=$3
    case $message_type in
        info) printf "\r[${color_blue}%s${color_reset}] %s${color_reset}\n" "$message_section" "$message_text" ;;
        success) printf "\r[${color_green}%s${color_reset}] %s${color_reset}\n" "$message_section" "$message_text" ;;
        warn) printf "\r[${color_yellow}%s${color_reset}] %s${color_reset}\n" "$message_section" "$message_text" ;;
        error) printf "\r[${color_red}%s${color_reset}] %s${color_reset}\n" "$message_section" "$message_text" ;;
        debug) printf "\r[%s] %s\n" "$message_section" "$message_text" ;;
        *) printf "\r[%s] %s\n" "$message_section" "$message_text" ;;
    esac
}

####
# Display a block message with an optional type.
#
# Usage:
#   _pms_message_block "info" "Message"
#   _pms_message_block "Message"
####
_pms_message_block() {
    local message_type=$1
    local message_text=$2
    if [ -z "$message_text" ]; then
        message_text=$message_type
    fi
    case $message_type in
        info) printf "\r\n\t${color_blue}%s${color_reset}\n\n" "$message_text" ;;
        success) printf "\r\n\t${color_green}%s${color_reset}\n\n" "$message_text" ;;
        warn) printf "\r\n\t${color_yellow}%s${color_reset}\n\n" "$message_text" ;;
        error) printf "\r\n\t${color_red}%s${color_reset}\n\n" "$message_text" ;;
        debug) printf "\r\n\t%s\n\n" "$message_text" ;;
        *) printf "\r\n\t%s\n\n" "$message_text" ;;
    esac
}

