---
name: security
description: Use when reviewing or implementing NEXUS authentication, authorization, input validation, SQL safety, session security, CSRF, XSS, secrets management, database privileges, or error handling. Use it before submission and before any security-sensitive change.
---

# NEXUS Skill — Application Security

## Purpose

Protect student data and demonstrate responsible database security in a college project. Security is a property of the whole system, not a feature added at the end.

## When to use

- Implementing login, logout, sessions, or roles.
- Writing any query that uses user input.
- Adding a form that changes data.
- Reviewing error handling.
- Creating database users and privileges.
- Preparing for submission or a security review.
- Investigating a suspicious bug or exposure.

## Required project context

1. `project-context/SECURITY_STANDARDS.md`.
2. `project-context/SYSTEM_ARCHITECTURE.md` (Authentication and Error flows).
3. `project-context/CODING_STANDARDS.md`.
4. `.github/instructions/backend.instructions.md`.
5. `.github/instructions/database.instructions.md`.

## Workflow

1. **Identify the asset.** What data or action are we protecting?
2. **Identify the entry point.** Form, URL, header, file, or session.
3. **Validate input.** Type, length, format, range, allow-list.
4. **Parameterize SQL.** No string interpolation.
5. **Check authentication.** Is the user logged in?
6. **Check authorization.** Is this user allowed to do this to this record?
7. **Protect state changes.** CSRF token, `POST`, confirmation for destructive actions.
8. **Escape output.** Keep autoescaping on; avoid `|safe` and `innerHTML`.
9. **Handle errors safely.** Safe message to the user, detail to the log.
10. **Check secrets.** No credentials in code or Git.
11. **Check database privileges.** Least privilege for each user.
12. **Test the control.** Try the attack and confirm it fails.
13. **Record the result.** Note what was tested and what was observed.

## Rules and restrictions

- Never trust user input.
- Never build SQL with strings.
- Never store plaintext passwords.
- Never commit secrets.
- Never expose stack traces or SQL errors.
- Never disable CSRF for convenience.
- Never grant `ALL PRIVILEGES` to the app user.
- Never use real student data.
- Never claim a security control works without testing it.

## Quality checklist

- [ ] All SQL is parameterized.
- [ ] All inputs are validated server-side.
- [ ] Passwords are hashed.
- [ ] Sessions use secure cookie flags.
- [ ] CSRF protection is enabled on state-changing forms.
- [ ] Output is escaped.
- [ ] Authorization is checked on the server for every protected route.
- [ ] Ownership is checked where relevant.
- [ ] Errors do not leak internals.
- [ ] Secrets are in `.env`, not source control.
- [ ] Database users follow least privilege.
- [ ] Sample data is fake.
- [ ] Dependencies are minimal and pinned.
- [ ] Security tests were run and recorded.

## Expected deliverables

- Secure code changes.
- A security review note in `docs/testing/`.
- Test evidence for the controls changed.
- Updated `SECURITY_STANDARDS.md` if a new rule is introduced.
- Updated `CHANGELOG.md`.

## Common mistakes to avoid

- Validating only in the browser.
- Using an f-string in a query.
- Hiding a button instead of checking the role on the server.
- Returning a stack trace to the user.
- Storing a password in a config file.
- Using `|safe` to make output look right.
- Granting broad database privileges.
- Testing only the happy path.
- Claiming security is done without evidence.
