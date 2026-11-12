---
name: debugging
description: Use when diagnosing a GM University Management System error, unexpected behaviour, failed test, broken query, connection problem, layout bug, or performance issue. Use it to find the real cause before changing code.
---

# GM University Management System Skill — Debugging

## Purpose

Find the real cause of a problem before changing code. Debugging is investigation, not guessing.

## When to use

- The app crashes or returns the wrong response.
- A page renders incorrectly.
- A query returns unexpected rows.
- A test fails.
- The database connection fails.
- Performance is poor.
- A feature works locally but not elsewhere.

## Required project context

1. `project-context/CURRENT_STATUS.md` — what is supposed to work.
2. `project-context/SYSTEM_ARCHITECTURE.md` — the expected flow.
3. The relevant module specification.
4. Recent entries in `CHANGELOG.md`.

## Workflow

1. **Reproduce the problem.** Write the exact steps, input, and environment.
2. **Read the actual error.** Do not guess from the symptom.
3. **Locate the layer.** Presentation, application, data, or environment.
4. **Form one hypothesis.** State what you think is wrong and why.
5. **Test the hypothesis.** Add a log, inspect a value, run a small query.
6. **Narrow the cause.** Change one thing at a time.
7. **Fix the cause, not the symptom.**
8. **Add a regression test.**
9. **Verify the fix.** Re-run the reproduction and the full suite.
10. **Record the cause and fix** in the changelog or a debugging note.

## Rules and restrictions

- Do not change code before understanding the cause.
- Do not disable a check to make an error disappear.
- Do not hide an exception.
- Do not guess at a database state; query it.
- Do not make several unrelated changes at once.
- Do not delete logs or evidence.
- Do not claim a fix without reproducing the original problem and re-testing.

## Quality checklist

- [ ] The problem is reproduced with exact steps.
- [ ] The error message was read in full.
- [ ] The failing layer was identified.
- [ ] The cause is explained in one sentence.
- [ ] The fix addresses the cause.
- [ ] A regression test exists.
- [ ] The original reproduction now passes.
- [ ] The full suite still passes.
- [ ] The cause and fix are recorded.

## Expected deliverables

- A clear explanation of the cause.
- A minimal fix.
- A regression test.
- A changelog entry.
- A note of any remaining uncertainty.

## Common mistakes to avoid

- Changing random lines until the error disappears.
- Catching and ignoring an exception.
- Assuming the database is empty without checking.
- Fixing the symptom and leaving the cause.
- Making multiple changes at once.
- Forgetting the regression test.
- Claiming it works without re-running the reproduction.
