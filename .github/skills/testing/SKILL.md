---
name: testing
description: Use when planning, writing, running, or reporting NEXUS tests for routes, services, repositories, SQL, security controls, or end-to-end flows. Use it before marking any task complete.
---

# NEXUS Skill — Testing and Quality Assurance

## Purpose

Provide real evidence that NEXUS works. Tests protect working features from future changes and give the college submission credible verification.

## When to use

- Before marking a task complete.
- After adding a route, service, repository, or query.
- After a schema migration.
- Before a stage gate.
- Before submission.
- When fixing a bug (write a regression test).

## Required project context

1. `project-context/CURRENT_STATUS.md`.
2. `project-context/DEVELOPMENT_WORKFLOW.md` (stage testing requirements).
3. `project-context/SECURITY_STANDARDS.md`.
4. `docs/testing/` for existing evidence.
5. `tests/README.md` when it exists.

## Workflow

1. **Define the behaviour.** State what should happen in plain English.
2. **Choose the level.** Unit, integration, or end-to-end.
3. **Prepare data.** Use fake data and clean up afterwards.
4. **Write the test.** Arrange, act, assert.
5. **Run it.** Confirm it passes for the right reason.
6. **Break it on purpose.** Confirm the test fails when the behaviour is wrong.
7. **Test the edges.** Empty input, invalid input, unauthorized access, database failure.
8. **Run the full suite.** Check for regressions.
9. **Record the result.** Command, date, pass/fail counts, and any skipped tests.
10. **Update the task board and status file.**

## Rules and restrictions

- Tests must run against MySQL, not SQLite.
- Do not invent test results.
- Do not skip a failing test without documenting why.
- Do not test only the happy path.
- Do not depend on local machine state.
- Do not commit real data.
- Do not mark a requirement **Tested** without evidence.

## Quality checklist

- [ ] The test names the behaviour.
- [ ] It covers success and failure.
- [ ] It covers authorization where relevant.
- [ ] It uses fake data.
- [ ] It cleans up.
- [ ] It runs against MySQL.
- [ ] It passes locally.
- [ ] It fails when the behaviour is deliberately broken.
- [ ] The full suite passes.
- [ ] Results are recorded accurately.
- [ ] Known failures are documented.

## Expected deliverables

- Test files under `tests/`.
- A test report in `docs/testing/`.
- Updated `TASKS.md` and `CURRENT_STATUS.md`.
- A note of any untested area.

## Common mistakes to avoid

- Testing implementation details instead of behaviour.
- Using SQLite because it is easier.
- Writing tests that always pass.
- Ignoring a flaky test.
- Claiming a suite passed without running it.
- Leaving test data behind.
- Skipping security and permission tests.
- Reporting a pass count that was not observed.
