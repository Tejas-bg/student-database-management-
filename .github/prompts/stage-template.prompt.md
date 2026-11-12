# Stage Prompt Template

> Copy this file, rename it `stage-<number>-<short-name>.prompt.md`, and fill in the blanks.

## Stage

Stage `<number>` — `<stage name>`

## Goal

`<one or two sentences describing the outcome of this stage>`

## Read first

1. `.github/copilot-instructions.md`
2. `project-context/PROJECT_OVERVIEW.md`
3. `project-context/SYSTEM_ARCHITECTURE.md`
4. `project-context/CURRENT_STATUS.md`
5. `project-context/TASKS.md`
6. `<any stage-specific document>`

## Allowed scope

- `<folders and files the agent may change>`

## Out of scope

- `<folders and files the agent must not change>`
- Do not start the next stage.
- Do not change approved architecture without an ADR.

## Deliverables

- `<file or feature 1>`
- `<file or feature 2>`
- Updated `TASKS.md`
- Updated `CHANGELOG.md`
- Updated `project-context/CURRENT_STATUS.md` after verification

## Verification

- `<command or check 1>`
- `<command or check 2>`
- Report what was verified and what was not.

## Stop condition

Stop after the deliverables are verified. Wait for the user's approval before starting the next stage.
