# vim: set ft=sh:
# shellcheck shell=bash
####
# Core aggregator for PMS
#
# Loads helper modules responsible for interactive messaging, file sourcing,
# timing utilities, and theme or plugin loading.
####

# shellcheck source=lib/core/interactive.sh
source "$PMS/lib/core/interactive.sh"
# shellcheck source=lib/core/files.sh
source "$PMS/lib/core/files.sh"
# shellcheck source=lib/core/timing.sh
source "$PMS/lib/core/timing.sh"
# shellcheck source=lib/core/loaders.sh
source "$PMS/lib/core/loaders.sh"

