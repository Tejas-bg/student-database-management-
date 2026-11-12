# Prompt Files

This folder holds reusable prompt files for VS Code AI Agent Mode.

## Convention

VS Code prompt files use the extension `.prompt.md` and usually live in `.github/prompts/`. A prompt file can be invoked from the Chat view or referenced in a stage kickoff message.

Each prompt file should:

- Name the stage it belongs to.
- State the mandatory reading order.
- State the allowed files and folders.
- State what is explicitly out of scope.
- State the expected deliverables.
- State the verification steps.

## Files

| File | Purpose |
|---|---|
| `stage-template.prompt.md` | Copy this when starting a new stage. |
| `stage-1-ui-ux.prompt.md` | Reserved for the Stage 1 kickoff (do not run yet). |
| `stage-3-database-design.prompt.md` | Stage 3 MySQL database architecture and ER design scope; saved, not executed. |

## Example usage

Open the Chat view, select **Agent Mode**, and say:

> Follow `.github/prompts/stage-1-ui-ux.prompt.md` exactly. Do not start until I confirm.

Do not assume a prompt file runs automatically. You must attach or reference it.
