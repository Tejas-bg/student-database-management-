---
name: database-design
description: Use when modelling NEXUS entities and relationships, drawing the ER diagram, designing tables, reviewing cardinality, normalizing to 3NF, or checking schema integrity. Do not use it for server operations or query tuning.
---

# NEXUS Skill — Database Design and Normalization

## Purpose

Design a correct, normalized relational schema for NEXUS before any table is created. This skill covers ER modelling, relationship cardinality, key selection, normalization to 3NF, and schema review.

## When to use

- Identifying entities and attributes.
- Drawing or revising the ER diagram.
- Choosing primary keys and foreign keys.
- Deciding cardinality (1:1, 1:N, M:N).
- Reviewing a table for 1NF, 2NF, and 3NF.
- Reviewing the data dictionary.
- Checking that constraints enforce the intended rules.

## Required project context

1. `project-context/PROJECT_OVERVIEW.md` — what data the system manages.
2. `project-context/MODULE_SPECIFICATIONS.md` — how data is used.
3. `database/documentation/ER_DIAGRAM.md`.
4. `database/documentation/DATABASE_DESIGN.md`.
5. `database/documentation/NORMALIZATION.md`.
6. `database/documentation/TABLE_RELATIONSHIPS.md`.

## Workflow

1. **List the entities.** Use nouns from the requirements: Student, Department, Course, Subject, Semester, Faculty, Enrolment, Attendance, Marks, Fee, Feedback.
2. **List attributes for each entity.** Separate identifying attributes from descriptive ones.
3. **Choose a primary key.** Prefer a stable surrogate key (`student_id`) plus a natural unique key where needed (admission number, email).
4. **Draw relationships.** For each pair, state the verb and the cardinality.
5. **Resolve many-to-many relationships** with a junction table (for example, `enrolments`, `faculty_subject_assignments`).
6. **Apply 1NF.** No repeating groups; one value per cell.
7. **Apply 2NF.** Every non-key attribute depends on the whole key.
8. **Apply 3NF.** No non-key attribute depends on another non-key attribute.
9. **Add constraints.** `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`, foreign keys.
10. **Choose delete behaviour.** `RESTRICT` for reference data, `CASCADE` only when it is truly safe.
11. **Write the data dictionary.** Table, column, type, nullability, key, description.
12. **Review with the user.** Mark the schema PLANNING until approved.

## Rules and restrictions

- Do not create tables during design.
- Do not denormalize without a documented performance reason and an ADR.
- Do not use a natural key as the primary key if it can change.
- Do not use `ON DELETE CASCADE` blindly.
- Do not store multiple values in one column.
- Do not store derived values unless there is a documented reason.
- Do not skip the normalization review.
- Mark the schema PLANNING until reviewed.

## Quality checklist

- [ ] Every entity has a primary key.
- [ ] Every relationship has a clear cardinality.
- [ ] Many-to-many relationships have a junction table.
- [ ] Every foreign key points to an existing primary key.
- [ ] 1NF, 2NF, and 3NF are documented.
- [ ] Constraints match the business rules.
- [ ] Delete behaviour is intentional.
- [ ] Data dictionary matches the design.
- [ ] ER diagram matches the tables.
- [ ] The schema is marked PLANNING until approved.
- [ ] The user has reviewed the schema.

## Expected deliverables

- `database/documentation/ER_DIAGRAM.md` with a Mermaid ER diagram.
- `database/documentation/DATABASE_DESIGN.md`.
- `database/documentation/TABLE_RELATIONSHIPS.md`.
- `database/documentation/NORMALIZATION.md`.
- `database/documentation/DATA_DICTIONARY.md`.
- A review note recording approval or open questions.

## Common mistakes to avoid

- Drawing tables before understanding the relationships.
- Using a composite key everywhere when a surrogate key is clearer.
- Leaving a many-to-many relationship unresolved.
- Storing a comma-separated list in one column.
- Repeating department names in every table.
- Using `CASCADE` everywhere.
- Claiming 3NF without checking dependencies.
- Treating a draft schema as approved.
