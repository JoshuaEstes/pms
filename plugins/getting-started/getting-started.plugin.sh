printf "${GREEN}"
cat <<-'EOF'

Getting Started with...

 _______   __                                __       __                   ______   __                  __  __
/       \ /  |                              /  \     /  |                 /      \ /  |                /  |/  |
$$$$$$$  |$$/  _____  ____    ______        $$  \   /$$ | __    __       /$$$$$$  |$$ |____    ______  $$ |$$ |
$$ |__$$ |/  |/     \/    \  /      \       $$$  \ /$$$ |/  |  /  |      $$ \__$$/ $$      \  /      \ $$ |$$ |
$$    $$/ $$ |$$$$$$ $$$$  |/$$$$$$  |      $$$$  /$$$$ |$$ |  $$ |      $$      \ $$$$$$$  |/$$$$$$  |$$ |$$ |
$$$$$$$/  $$ |$$ | $$ | $$ |$$ |  $$ |      $$ $$ $$/$$ |$$ |  $$ |       $$$$$$  |$$ |  $$ |$$    $$ |$$ |$$ |
$$ |      $$ |$$ | $$ | $$ |$$ |__$$ |      $$ |$$$/ $$ |$$ \__$$ |      /  \__$$ |$$ |  $$ |$$$$$$$$/ $$ |$$ |
$$ |      $$ |$$ | $$ | $$ |$$    $$/       $$ | $/  $$ |$$    $$ |      $$    $$/ $$ |  $$ |$$       |$$ |$$ |
$$/       $$/ $$/  $$/  $$/ $$$$$$$/        $$/      $$/  $$$$$$$ |       $$$$$$/  $$/   $$/  $$$$$$$/ $$/ $$/
                            $$ |                         /  \__$$ |
                            $$ |                         $$    $$/
                            $$/                           $$$$$$/


Getting Started with PMS is super easy with the PMS Manager! Just run "pms" to see what I mean.

Here's a few common commands with the PMS Manager to get you started

EOF
printf "${RESET}"
_pms_message_section_info "pms upgrade" "Upgrades your PMS version to the latest version"
_pms_message_section_info "pms about" "Displays information and help links related to PMS"
_pms_message_section_info "pms diagnostic" "Contains information about your system to help trouble shoot issues"
_pms_message_block_info "Theme Related Commands"
_pms_message_section_info "pms theme list" "Displays a list of available themes"
_pms_message_section_info "pms theme switch [THEME]" "Switches to a new theme"
_pms_message_block_info "Plugin Related Commands"
_pms_message_section_info "pms plugin list" "Displays a list of available plugins"
_pms_message_section_info "pms plugin enable [PLUGIN]" "Enables a plugin"
_pms_message_section_info "pms plugin disable [PLUGIN]" "Disables a plugin"
echo
echo "${YELLOW}Tired of seeing this? Run 'pms plugin disable getting-started' to disable${RESET}"
echo
