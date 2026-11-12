# Triggers

> **Status: PLANNING.** No trigger has been created.

Triggers run SQL automatically when a row changes. They can enforce audit rules, but they also hide behaviour, so use them sparingly and document them.

## Possible triggers

| Trigger | Event | Purpose |
|---|---|---|
| `trg_fee_payments_after_insert` | After insert on `fee_payments` | Update the fee status or write an audit row. |
| `trg_internal_marks_before_insert` | Before insert on `internal_marks` | Reject marks above the assessment maximum. |
| `trg_attendance_before_insert` | Before insert on `attendance` | Reject duplicate attendance for the same enrolment and date. |

These are proposals. The final set is confirmed in Stage 6.

## Rules

- Name triggers `trg_<table>_<timing>_<event>`.
- Keep logic small and documented.
- Do not duplicate a rule that is already enforced by a constraint.
- Do not create recursive or surprising behaviour.
- Test the trigger with valid and invalid data.
- Record the trigger in the data dictionary.

## Decision needed

Constraints are preferred over triggers when a constraint can express the rule. Triggers are used only where a constraint cannot.
