# GM University Management System — Contributing Guide (Beginner Friendly)

This guide explains how to work on the GM University Management System with Visual Studio Code and AI Agent Mode. It assumes you are new to Git, Flask, and AI coding agents.

Technical words are explained in `project-context/GLOSSARY.md`.

---

## 1. Open the project in VS Code

1. Open **Visual Studio Code**.
2. Choose **File → Open Folder**.
3. Select the `GM University Management System` folder.
4. Open the integrated terminal with **Terminal → New Terminal** (or `` Ctrl+` ``).
5. Check that the terminal path ends with `GM University Management System`.

If you open the wrong folder, the AI may not find the instructions.

---

## 2. What to read before you start

Read these in order:

1. `README.md`
2. `project-context/PROJECT_OVERVIEW.md`
3. `project-context/CURRENT_STATUS.md`
4. `TASKS.md`
5. `ROADMAP.md`

Do not ask the AI to build a feature before you know which stage you are in.

---

## 3. How to use Agent Mode

**Agent Mode** is a VS Code AI mode that can read files, suggest edits, and run commands, usually with your approval.

Basic steps:

1. Open the **Chat** view.
2. Switch the mode selector to **Agent**.
3. Tell the agent what you want.
4. Review every proposed change before accepting it.
5. Approve commands only when you understand what they do.

The agent reads `.github/copilot-instructions.md` automatically in supported versions. If it does not, paste the relevant instructions into the chat or ask it to read the file.

---

## 4. How to give a stage-specific prompt

Use the templates in `.github/prompts/`.

Example for Stage 1 (only after you approve it):

> Read `.github/copilot-instructions.md` and `.github/prompts/stage-1-ui-ux.prompt.md`. Follow the prompt exactly. Do not start Stage 2. Show me the plan before editing files.

A good prompt has five parts:

1. **Which stage** you are in.
2. **What to read** first.
3. **What to change** (folders and files).
4. **What not to change.**
5. **How to verify** the result.

Bad prompt: "Build the whole app."

Good prompt: "In Stage 1, create the design tokens in `frontend/static/css/tokens.css` only. Do not create pages. Show the file before writing it."

---

## 5. How to inspect changes

Before accepting a change:

1. Read the diff (the side-by-side view of what changed).
2. Check that the agent did not touch unrelated files.
3. Check for secrets, hardcoded passwords, or SQL string concatenation.
4. Check that the change follows the current stage.
5. Ask the agent to explain anything you do not understand.

If the change is large, ask for it in smaller steps.

---

## 6. How to run commands

Commands are typed in the VS Code terminal.

Common examples (later stages):

```powershell
# Check Python
python --version

# Create a virtual environment
python -m venv .venv

# Activate it (PowerShell)
.\.venv\Scripts\Activate.ps1

# Install dependencies
pip install -r backend\requirements.txt

# Run the Flask app
python -m flask --app backend.app run
```

Do not run a command if you do not know what it does. Ask first.

---

## 7. How to test changes

A change is not done because the agent says so. Verify it:

- **Code:** run the tests.
- **Page:** open it in a browser and check the console.
- **Database:** run the query and inspect the rows.
- **API:** call the endpoint and check the status code and response.

Record what you ran and what you saw. If something was not tested, say so.

---

## 8. How to report errors

When something breaks, give the agent:

1. **What you did** (exact steps).
2. **What you expected.**
3. **What happened.**
4. **The full error message** (copy it, do not paraphrase).
5. **The command or file** involved.
6. **What you already tried.**

Example:

> I ran `python -m flask --app backend.app run`. I expected the server to start. Instead I got `ModuleNotFoundError: No module named 'flask'`. I am in the GM University Management System folder and my virtual environment is active.

Do not say "it doesn't work". That gives the agent nothing to debug.

---

## 9. How to update project documentation

After a meaningful change:

1. Update the relevant file in `project-context/`.
2. Update `docs/` if the change affects architecture, API, database, or design.
3. Add a `CHANGELOG.md` entry.
4. Update `TASKS.md`.
5. Update `project-context/CURRENT_STATUS.md` **only after verification**.
6. Add an ADR if a decision was made.

Documentation must describe reality. Do not mark a task complete because a file exists.

---

## 10. How to avoid overwriting working code

- Ask the agent to read a file before editing it.
- Prefer small edits over full rewrites.
- Keep a Git checkpoint before risky changes.
- Review the diff.
- If the agent proposes deleting a file, ask why.
- If two instructions conflict, stop and resolve the conflict before coding.

The agent is instructed not to delete important files without permission. Hold it to that.

---

## 11. How to use Git checkpoints

Git records snapshots of your project. A **commit** is a saved snapshot. A **checkpoint** is a commit you can return to.

First-time setup:

```powershell
git init
git add .
git commit -m "docs: initialize project workspace and context"
```

Before a risky change:

```powershell
git add .
git commit -m "Checkpoint before <change>"
```

If something goes wrong, you can inspect history:

```powershell
git log --oneline
git status
git diff
```

To undo uncommitted changes to one file:

```powershell
git restore path\to\file
```

Do not run `git reset --hard` unless you understand it; it discards work.

### What not to commit

- `.env`
- `.venv/`
- `__pycache__/`
- database dumps with real data
- screenshots with personal information

These are already covered by `.gitignore`.

---

## 12. A safe working loop

1. Confirm the stage.
2. Read the relevant context files.
3. Ask for a plan.
4. Approve a small step.
5. Inspect the diff.
6. Run the verification.
7. Update the docs and task board.
8. Commit a checkpoint.
9. Repeat.
10. Stop at the stage gate and ask for approval.

---

## 13. When to stop and ask

Stop if:

- The agent wants to change the architecture.
- The agent wants to add a dependency.
- The agent wants to delete files.
- The agent cannot verify something.
- The instructions conflict.
- You do not understand a change.

Asking is cheaper than repairing.
