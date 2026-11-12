# GM University Management System — Security Standards

> **Status:** Approved baseline. Tables are created only in Stage 3 after schema approval.
> **Rule:** These are non-negotiable. If a requested feature conflicts with them, raise the conflict before implementing.

---

## 1. Threat model (beginner-friendly)

The GM University Management System is a college project, but it still handles personal and academic records. The realistic risks are:

- Someone reading or changing another student's marks.
- SQL injection through a form field.
- Stolen database credentials from a committed file.
- Cross-site scripting (XSS) through feedback comments.
- Cross-site request forgery (CSRF) on a form.
- Weak passwords or exposed password hashes.
- Accidental deletion of records.
- Over-privileged database users.

The controls below address these risks.

---

## 2. Secrets and configuration

- All secrets live in `.env`, which is ignored by Git.
- `.env.example` contains placeholders only.
- Never hardcode a password, host, username, API key, or token in Python, JavaScript, HTML, CSS, SQL, or Markdown.
- Never log secrets.
- Never screenshot a `.env` file.
- Rotate a secret immediately if it is exposed.
- Use different database users for schema changes, application runtime, and reporting.

### `.env` keys (planned)

```
FLASK_ENV=development
FLASK_SECRET_KEY=replace-me
DB_HOST=localhost
DB_PORT=3306
DB_NAME=gmu_management
DB_USER=gmu_app
DB_PASSWORD=replace-me
DB_ADMIN_USER=gmu_admin
DB_ADMIN_PASSWORD=replace-me
```

These are placeholders. Real values are created locally and never committed.

---

## 3. SQL injection prevention

- Use parameterized queries for every value that comes from a user, a URL, a header, or a file.
- Never build SQL with f-strings, string concatenation, or `%` formatting.
- Do not allow user input to choose a table or column name. If dynamic sorting is needed, map user choices to a fixed allow-list.
- Validate types and ranges before the query.
- Use least-privilege database users so an injection has less to reach.

Safe pattern:

```python
cursor.execute(
    "SELECT student_id, full_name FROM students WHERE department_id = %s",
    (department_id,),
)
```

Unsafe pattern (never do this):

```python
cursor.execute(f"SELECT * FROM students WHERE department_id = {department_id}")
```

---

## 4. Input validation

- Validate on the server, always.
- Validate on the client for usability, never for security.
- Check type, length, format, range, and required fields.
- Reject unexpected fields.
- Normalize whitespace and case where appropriate.
- Do not trust hidden form fields.
- Do not trust query parameters.
- Return safe error messages that do not reveal internals.

---

## 5. Output encoding and XSS

- Keep Jinja2 autoescaping enabled.
- Do not use `|safe` unless the content is trusted and documented.
- Do not assign untrusted data to `innerHTML`.
- Use `textContent` or DOM APIs for dynamic text.
- Escape user comments and feedback before display.
- Set a Content-Security-Policy when the frontend is built.

---

## 6. Authentication

- Provide **one common login** for students, faculty, and administrators.
- Never add role selection to the form. The role comes from the registered MySQL account after the password is verified.
- Never infer a role from the login ID format.
- Store passwords as strong hashes (`werkzeug.security` or an approved alternative). Never plaintext.
- Never email or display a password.
- Enforce a minimum password policy.
- Do not reveal whether a username exists on login failure.
- Rate-limit or delay repeated failed logins.
- Regenerate the session on login.
- Provide a clear logout that destroys the session.
- Do not implement "remember me" without a secure token design.
- Password reset is not implemented. Do not fake it.
- The Stage 1 login page is a preview: it must not send, check, or store credentials, and must not show a successful sign-in.

---

## 7. Sessions and cookies

- Set `SESSION_COOKIE_HTTPONLY=True`.
- Set `SESSION_COOKIE_SAMESITE="Lax"` or stricter.
- Set `SESSION_COOKIE_SECURE=True` when served over HTTPS.
- Use a strong, random `SECRET_KEY`.
- Expire idle sessions appropriately.
- Do not store sensitive data in the session cookie.

---

## 8. Authorization

- Check permissions on the server for every protected route.
- Do not rely on hiding a button in the UI.
- Use role checks in a single, consistent place.
- Verify ownership where relevant (a student may view only their own records).
- Return `403` for authenticated-but-forbidden access and `401` for unauthenticated access.
- Log authorization failures.

---

## 9. CSRF

- Enable CSRF protection for all state-changing forms.
- Include the token in the form and verify it on the server.
- Do not disable CSRF for convenience.
- Use `POST` for state changes, not `GET`.

---

## 10. Database security

- Create least-privilege users:

| User | Rights |
|---|---|
| `gmu_admin` | DDL and DML for migrations only |
| `gmu_app` | DML and `SELECT` on required tables/views |
| `gmu_report` | `SELECT` on reporting views only |

- Demonstrate `GRANT` and `REVOKE` in a script under `database/`.
- Do not let the application user drop tables.
- Back up before destructive migrations.
- Use transactions for multi-step writes.
- Enforce integrity with foreign keys and constraints, not only in application code.

---

## 11. Error handling and logging

- Do not expose stack traces, SQL, file paths, or configuration to users.
- Log technical detail server-side.
- Do not log passwords, tokens, or full personal data.
- Use a consistent error page for `400`, `401`, `403`, `404`, and `500`.
- Monitor repeated failures during development.

---

## 12. File uploads

Not in the baseline. If added later:

- Validate type and size.
- Store outside the web root or with a non-executable path.
- Generate safe file names.
- Never trust the client-provided name.
- Scan or restrict content as appropriate.

---

## 13. Data privacy

- Use fake sample data only.
- Do not commit real student names, emails, phone numbers, or marks.
- Do not include real data in screenshots.
- Remove or anonymize data before sharing the repository.
- Follow the college's data policy if real data is ever used in a controlled demo.

---

## 14. Dependency safety

- Keep dependencies minimal.
- Pin versions.
- Do not install a package from an untrusted source.
- Review a dependency before adding it.
- Update dependencies deliberately, not automatically during a demo.

---

## 15. Security checklist before submission

- [ ] No secrets in Git history.
- [ ] `.env` is ignored.
- [ ] All SQL is parameterized.
- [ ] All inputs are validated server-side.
- [ ] Autoescaping is on.
- [ ] CSRF is enabled for forms.
- [ ] Passwords are hashed.
- [ ] Session cookie flags are set.
- [ ] Role checks exist on every protected route.
- [ ] Database users follow least privilege.
- [ ] Errors do not leak internals.
- [ ] Sample data is fake.
- [ ] Dependencies are pinned and reviewed.
