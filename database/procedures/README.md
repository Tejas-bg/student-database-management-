# Procedures

> **Status: PLANNING.** No procedure has been created.

Stored procedures group SQL logic inside MySQL. They are optional in the baseline but useful for demonstrating advanced DBMS concepts.

## Possible procedures

| Procedure | Purpose |
|---|---|
| `sp_enrol_student` | Enrol a student with validation. |
| `sp_record_payment` | Record a fee payment inside a transaction. |
| `sp_compute_semester_result` | Compute a student's semester result. |
| `sp_promote_students` | Move eligible students to the next semester. |

These are proposals, not commitments.

## Rules

- Name procedures `sp_<verb>_<entity>`.
- Validate inputs inside the procedure.
- Use transactions where multiple writes are involved.
- Document parameters and behaviour.
- Do not hide business rules that belong in the application unless there is a clear reason.
- Test with valid and invalid inputs.

## Decision needed

Whether the project uses stored procedures at all is confirmed in Stage 6. The DBMS brief requires the concepts, not necessarily every implementation technique.
