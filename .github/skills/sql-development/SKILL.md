---
name: sql-development
description: Use when writing or reviewing GM University Management System SQL queries, joins, subqueries, aggregate functions, reporting views, or query performance. Do not use it for schema design or server administration.
---

# GM University Management System Skill — SQL Development

## Purpose

Write correct, readable, parameterized SQL that demonstrates the DBMS concepts required by the project.

## When to use

- Writing `SELECT` queries for modules and reports.
- Building joins, subqueries, and aggregates.
- Creating reporting views.
- Reviewing a query for correctness or performance.
- Writing DML for seed data or application writes.
- Demonstrating DDL, DML, DQL, DCL, and TCL for the viva.

## Required project context

1. `database/documentation/DATABASE_DESIGN.md`.
2. `database/documentation/TABLE_RELATIONSHIPS.md`.
3. `database/documentation/SQL_CONCEPT_MAPPING.md`.
4. `project-context/SECURITY_STANDARDS.md`.
5. `.github/instructions/database.instructions.md`.

## Workflow

1. **State the question.** Write the question in plain English before writing SQL.
2. **Identify the tables and keys.** Know how they join.
3. **Write the query in clauses.** `SELECT`, `FROM`, `JOIN`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, `LIMIT`.
4. **Use explicit columns.** Avoid `SELECT *` in application code.
5. **Parameterize values.** Use `%s` placeholders for user input.
6. **Check the result.** Run the query and inspect the rows.
7. **Check the edge cases.** No rows, nulls, duplicates, large values.
8. **Check performance.** Use `EXPLAIN` for slow or complex queries.
9. **Document the concept.** Add it to the SQL concept mapping.
10. **Save the query** in the correct database folder.

## Rules and restrictions

- Uppercase SQL keywords.
- One clause per line.
- Explicit column lists.
- Parameterized values; never string interpolation.
- Qualify columns in multi-table queries.
- Use `JOIN ... ON`, not implicit joins.
- Use `DECIMAL` for money.
- Use `LIMIT` for pagination.
- Do not use `SELECT *` in application queries.
- Do not use a subquery where a join is clearly better, or vice versa; choose deliberately.
- Do not claim a query works without running it.

## Quality checklist

- [ ] The query answers the stated question.
- [ ] All tables are joined on the correct keys.
- [ ] Columns are explicit and qualified where needed.
- [ ] Values are parameterized.
- [ ] Aggregates use `GROUP BY` correctly.
- [ ] `HAVING` is used for aggregate filters, not `WHERE`.
- [ ] `NULL` behaviour is considered.
- [ ] The query was run and the output checked.
- [ ] Edge cases were tested.
- [ ] The concept is recorded in `SQL_CONCEPT_MAPPING.md`.
- [ ] The query is saved in the right folder.

## Expected deliverables

- SQL files in `database/` under the correct subfolder.
- A note of the question, the query, and the observed result.
- Updates to `database/documentation/SQL_CONCEPT_MAPPING.md`.
- A short explanation suitable for the viva.

## Common mistakes to avoid

- `SELECT *` in application code.
- Joining on the wrong key and producing duplicate rows.
- Using `WHERE` instead of `HAVING` for aggregate filters.
- Ignoring `NULL` in comparisons.
- Concatenating user input into SQL.
- Writing a query that works on sample data but breaks on edge cases.
- Claiming a query is fast without checking `EXPLAIN`.
- Forgetting to record which DBMS concept the query demonstrates.
