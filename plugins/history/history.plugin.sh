# vim: set ft=sh:
alias h='history'

# Displays the most used commands
alias hstats='history 0 | awk "{print \$2}" | sort | uniq -c | sort -n -r | head'
