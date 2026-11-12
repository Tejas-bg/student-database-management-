---
name: deployment
description: Use when preparing GM University Management System to run outside the developer's machine, writing setup scripts, configuring environment variables, packaging the submission, or preparing a demo environment. Do not use it to introduce cloud infrastructure that is out of scope.
---

# GM University Management System Skill — Deployment and Setup

## Purpose

Make GM University Management System reproducible: a clean machine can install it, configure it, run it, and demonstrate it. Deployment here means local setup and a reliable demo environment, not public cloud hosting.

## When to use

- Writing or updating setup instructions.
- Creating setup or reset scripts.
- Preparing the demo environment.
- Packaging the college submission.
- Moving to a new machine.
- Verifying that the README works from scratch.

## Required project context

1. `project-context/TECHNOLOGY_STACK.md`.
2. `project-context/SECURITY_STANDARDS.md`.
3. `project-context/DEVELOPMENT_WORKFLOW.md` (Stage 9).
4. `.env.example`.
5. `README.md`.

## Workflow

1. **List the prerequisites.** Python, MySQL, Git, VS Code.
2. **Document the exact versions.**
3. **Create the database and users.** Use least privilege.
4. **Copy `.env.example` to `.env`** and fill in local values.
5. **Install dependencies** in a virtual environment.
6. **Apply migrations and seed data.**
7. **Start the app.**
8. **Verify a known flow.**
9. **Write the README steps in order.**
10. **Test on a clean environment** or a fresh shell.
11. **Prepare a demo reset path.**
12. **Record what was verified.**

## Rules and restrictions

- Do not commit `.env`, virtual environments, or generated files.
- Do not include real data in the demo database.
- Do not use SQLite.
- Do not require cloud services for the baseline.
- Do not use a password that is also used elsewhere.
- Do not claim the setup works without running it from a clean state.
- Do not introduce Docker, CI, or cloud hosting without approval and an ADR.

## Quality checklist

- [ ] Prerequisites and versions are listed.
- [ ] Setup steps are ordered and copy-pasteable.
- [ ] `.env.example` has every required key with placeholders.
- [ ] Database creation and migration steps are included.
- [ ] Seed data steps are included.
- [ ] Start command is correct.
- [ ] A verification flow is described.
- [ ] A reset path exists for demos.
- [ ] The setup was tested from a clean state.
- [ ] No secrets or real data are included.
- [ ] The README matches the actual commands.

## Expected deliverables

- Updated `README.md`.
- Setup and reset scripts in `scripts/`.
- A demo checklist.
- A verification note recording what was tested.

## Common mistakes to avoid

- Writing setup steps that were never run.
- Forgetting to mention MySQL.
- Leaving `.env` out of `.gitignore`.
- Hardcoding a local path.
- Assuming the database already exists.
- Using a production password in a demo.
- Packaging real student data.
- Claiming a clean install works without testing it.
