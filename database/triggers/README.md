# Triggers

> **Status: DESIGN PREPARED — NOT EXECUTED.** The trigger script exists and has been statically reviewed. No MySQL server was available to compile or test it.

Triggers run SQL automatically when a row changes. They enforce business rules that span more than one parent table and therefore cannot be expressed as a single foreign key.

## Delivered trigger script

`database/triggers/001_integrity_triggers.sql`

| Trigger pair | Table | Rule |
|---|---|---|
| `trg_attendance_records_bi` / `_bu` | `attendance_records` | The enrolment's subject, semester, and section must match the session's teaching assignment. |
| `trg_internal_marks_bi` / `_bu` | `internal_marks` | The assessment and enrolment must share the same subject and semester; marks must not exceed `internal_assessments.max_marks`. |
| `trg_semester_marks_bi` / `_bu` | `semester_marks` | The exam and enrolment must share the same subject and semester; marks must not exceed `semester_exams.max_marks`. |
| `trg_fee_payments_bi` / `_bu` | `fee_payments` | The fee structure must belong to the student's course; successful payments must not exceed the fee amount. |
| `trg_notifications_bi` / `_bu` | `notifications` | A direct target user's role must match `target_role`; an `all` broadcast cannot target one user. |

The timetable-to-assignment rule is enforced by the composite foreign key `fk_tt_assignment` in the schema, so no trigger is needed for it.

## Run order

1. `database/schema/001_schema.sql`
2. `database/views/001_views.sql`
3. `database/triggers/001_integrity_triggers.sql`
4. `database/seeds/001_sample_data.sql`

The seed rows are written to satisfy these triggers. They must be re-checked whenever seed data changes.

## Rules

- Name triggers `trg_<table>_<timing>_<event>`.
- Keep logic small and documented.
- Do not duplicate a rule already enforced by a constraint or foreign key.
- Do not create recursive or surprising behaviour.
- Test each trigger with valid and invalid data once MySQL is available.
- Record every trigger in the data dictionary and concept map.

## Runtime testing still required

- Compile every trigger with `SHOW TRIGGERS` / `SHOW CREATE TRIGGER`.
- Insert one valid and one invalid row per rule and confirm `SQLSTATE 45000`.
- Confirm the seed script still commits with the triggers enabled.
- Confirm concurrent fee payments are handled by the application transaction (the trigger alone does not prevent a race).
