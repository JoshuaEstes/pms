# vim: set ft=zsh:

# With this option set, stopped jobs that are removed from the job table with
# the disown builtin command are automatically sent a CONT signal to make them
# running.
setopt auto_continue

# Treat single word simple commands without redirection as candidates for
# resumption of an existing job.
#setopt auto_resume

# Run all background jobs at a lower priority. This option is set by default.
#setopt bg_nice

# Send the HUP signal to running jobs when the shell exits.
setopt hup

# List jobs in the long format by default.
setopt long_list_jobS

# Allow job control. Set by default in interactive shells.
setopt monitor

# Report the status of background jobs immediately, rather than waiting until
# just before printing a prompt.
#setopt notify

# This option makes job control more compliant with the POSIX standard.
#
# When the option is not set, the MONITOR option is unset on entry to
# subshells, so that job control is no longer active. When the option is set,
# the MONITOR option and job control remain active in the subshell, but note
# that the subshell has no access to jobs in the parent shell.
#
# When the option is not set, jobs put in the background or foreground with bg
# or fg are displayed with the same information that would be reported by jobs.
# When the option is set, only the text is printed. The output from jobs itself
# is not affected by the option.
#
# When the option is not set, job information from the parent shell is saved
# for output within a subshell (for example, within a pipeline). When the
# option is set, the output of jobs is empty until a job is started within the
# subshell.
#
# In previous versions of the shell, it was necessary to enable POSIX_JOBS in
# order for the builtin command wait to return the status of background jobs
# that had already exited. This is no longer the case.
#setopt posix_jobs

# Report the status of background and suspended jobs before exiting a shell
# with job control; a second attempt to exit the shell will succeed.
# NO_CHECK_JOBS is best used only in combination with NO_HUP, else such jobs
# will be killed automatically.
#
# The check is omitted if the commands run from the previous command line
# included a ‘jobs’ command, since it is assumed the user is aware that there
# are background or suspended jobs. A ‘jobs’ command run from one of the hook
# functions defined in the section Special Functions in Functions is not
# counted for this purpose.
setopt no_check_jobs
