# Seeds

> **Status: PLANNING.** No seed data has been created.

Seed files load fake sample data for development and demos.

## Rules

- All data must be clearly fake.
- No real student names, emails, phone numbers, or marks.
- Use consistent sample identifiers.
- Keep seeds idempotent where possible, or document that they reset data.
- Do not include passwords in plaintext. If demo users are seeded, document how the hash was generated.
- Match the approved schema exactly.

## Planned content

- Departments and courses.
- Semesters and subjects.
- Faculty.
- Students.
- Enrolments.
- Attendance.
- Internal and semester marks.
- Fee structure and payments.
- Feedback.
- Demo users for each role.

## Verification

- Load into a clean database.
- Check row counts.
- Run the main report queries against the seed data.
- Confirm no real data is present.
