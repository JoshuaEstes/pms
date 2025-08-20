# vim: set ft=sh:
# shellcheck shell=sh
####
# Plugin: aws
####

# Sets the AWS_PROFILE environment variable
aws_set_profile() {
    if [ "$#" -ne 1 ]; then
        printf '%s\n' "Usage: aws_set_profile <profile>" >&2
        return 1
    fi
    export AWS_PROFILE="$1"
}

# Alias for aws_set_profile to quickly switch profiles
alias awsp='aws_set_profile'

# Displays the current AWS profile for use in prompts
aws_prompt_profile() {
    printf '%s' "${AWS_PROFILE:-default}"
}

# Ensure a profile is always set
export AWS_PROFILE="${AWS_PROFILE:-default}"
