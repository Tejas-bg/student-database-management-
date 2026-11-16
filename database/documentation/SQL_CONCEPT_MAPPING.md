# GM University Management System — SQL and DBMS Concept Mapping (Stage 3)

> **Status:** Artifacts prepared, corrections applied for review. **Not executed.** No database was created or connected.
> A concept is marked **Prepared** when the script exists and has been statically reviewed; it moves to **Tested** only after execution evidence is recorded.

## 1. Concept map

| # | Concept | Artifact | Status | How it is demonstrated |
|---|---|---|---|---|
| 1 | ER modelling | `database/documentation/ER_DIAGRAM.md` | Prepared | Mermaid ER diagram with cardinalities |
| 2 | Relational design | `database/documentation/DATABASE_ARCHITECTURE.md` | Prepared | 24-table architecture |
| 3 | Primary keys | `database/schema/001_schema.sql` | Prepared | Every table has a PK |
| 4 | Foreign keys | `database/schema/001_schema.sql` | Prepared | FKs with `ON DELETE`/`ON UPDATE` |
| 5 | Constraints | `database/schema/001_schema.sql` | Prepared | `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`; 29 CHECK constraints |
| 6 | Normalization (3NF) | `database/documentation/NORMALIZATION.md` | Prepared | 1NF→2NF→3NF walkthrough, removed redundancy, documented exceptions |
| 7 | DDL | `database/demonstrations/001_ddl.sql` | Prepared | `CREATE`, `ALTER`, `RENAME`, `DROP` (demo only) |
| 8 | DML | `database/demonstrations/002_dml.sql`, `database/seeds/001_sample_data.sql` | Prepared | `INSERT`, `UPDATE`, `DELETE` |
| 9 | DQL | `database/demonstrations/003_dql_joins.sql`, `004_dql_subqueries_aggregates.sql` | Prepared | `SELECT` with filters/order |
| 10 | DCL | `database/demonstrations/005_dcl.sql` | Prepared | `CREATE USER`, `GRANT`, `REVOKE` |
| 11 | TCL | `database/demonstrations/006_tcl.sql` | Prepared | `COMMIT`, `ROLLBACK`, `SAVEPOINT` |
| 12 | INNER JOIN | `003_dql_joins.sql` §1 | Prepared | Students + department + course |
| 13 | LEFT JOIN | `003_dql_joins.sql` §2, §6 | Prepared | Students without logins; subjects without enrolments |
| 14 | RIGHT JOIN | `003_dql_joins.sql` §3 | Prepared | Departments without students |
| 15 | Subqueries | `004_dql_subqueries_aggregates.sql` §1–5 | Prepared | Scalar, IN, EXISTS, NOT EXISTS, derived table |
| 16 | Aggregates | `004_dql_subqueries_aggregates.sql` §6 | Prepared | `COUNT`, `SUM`, `AVG`, `MIN`, `MAX` |
| 17 | GROUP BY / HAVING | `004_dql_subqueries_aggregates.sql` §7–9 | Prepared | Course enrolments, subject averages, department thresholds |
| 18 | Views | `database/views/001_views.sql` | Prepared | 8 reporting views |
| 19 | Transactions | `006_tcl.sql` | Prepared | Payment and marks workflows |
| 20 | COMMIT | `006_tcl.sql` §A, §C | Prepared | Successful payment/marks save |
| 21 | ROLLBACK | `006_tcl.sql` §B | Prepared | Failed payment undone |
| 22 | SAVEPOINT | `006_tcl.sql` §C | Prepared | Partial rollback in bulk marks |
| 23 | GRANT | `005_dcl.sql` | Prepared | Least-privilege accounts |
| 24 | REVOKE | `005_dcl.sql` | Prepared | Remove delete/report access |
| 25 | Window functions | `004_dql_subqueries_aggregates.sql` §10 | Prepared | `RANK() OVER (PARTITION BY ...)` |
| 26 | Triggers | `database/triggers/001_integrity_triggers.sql` | Prepared | 10 BEFORE INSERT/UPDATE triggers for cross-table integrity |
| 27 | Composite foreign key | `database/schema/001_schema.sql` | Prepared | `fk_tt_assignment` links timetable to faculty assignment |
| 28 | Functional unique index | `database/schema/001_schema.sql` | Prepared | `uk_feedback_once` uses `COALESCE` for nullable scope |

## 2. Script inventory

| File | Purpose |
|---|---|
| `database/schema/001_schema.sql` | Complete DDL: database, 24 tables, 51 FKs, 32 unique keys, 29 CHECK constraints |
| `database/views/001_views.sql` | 8 reporting views |
| `database/triggers/001_integrity_triggers.sql` | 10 cross-table integrity triggers |
| `database/seeds/001_sample_data.sql` | Fictional seed data (no usable password hashes) |
| `database/demonstrations/001_ddl.sql` | DDL examples on a disposable demo table |
| `database/demonstrations/002_dml.sql` | DML examples with guarded cleanup |
| `database/demonstrations/003_dql_joins.sql` | INNER/LEFT/RIGHT/self joins |
| `database/demonstrations/004_dql_subqueries_aggregates.sql` | Subqueries, aggregates, GROUP BY/HAVING, window function |
| `database/demonstrations/005_dcl.sql` | GRANT/REVOKE and account roles |
| `database/demonstrations/006_tcl.sql` | Transactions, COMMIT, ROLLBACK, SAVEPOINT |

## 3. Viva notes (to refine in Stage 6/10)
For each concept: define it, point to the GMU table/query, explain why it matters, and run a live example after Stage 4/6 implementation.

## 4. Verification rule
Scripts are statically reviewed only. They have **not** been executed against MySQL in Stage 3. Execution evidence belongs to Stage 6. The trigger file is also uncompiled; see `database/triggers/README.md` for the runtime test list.