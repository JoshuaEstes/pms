# AGENTS
- Each `.bats` file in this directory must exercise a single execution path.
- Name test files descriptively for the scenario under test.
- Follow project shell style: four-space indentation, POSIX-compatible syntax, and prefer `[ ]` tests.
- Keep tests resilient to debug noise: capture and assert on stdout where appropriate, and avoid relying on stderr. Mock interactive tools (like `fzf`) where needed to prevent prompts.
