# AGENTS

 - Follow shell style used in this project: four-space indentation and POSIX-compatible syntax when possible. Prefer single-bracket `[ ]` tests over `[[ ]]`.
 - Use descriptive variable names; avoid single-letter names except for indexes.
 - Run `shellcheck` on all modified shell scripts; prefer `shellcheck -x -s bash`.
 - If tests exist, run them and ensure each test method covers one execution path.
 - Keep files you touch tidy by fixing typos or minor issues you encounter.
 - When sourcing multiple files, load them individually in a deterministic order.
 - Route debug logs to stderr unless they are part of a function's contract. Keep stdout clean for data pipelines and tests.
 - Timing helpers: do not emit fallback notices; only record timings. Any optional timing debug must go to stderr.
 - Handle arrays and strings robustly: when iterating `PMS_PLUGINS` (and similar), normalize to an array so both `PMS_PLUGINS=(...)` and `PMS_PLUGINS="a b"` work identically.
 - Prefer explicit iteration over `find | sort` with `while read -r` when sourcing lists of files to avoid word-splitting issues.
