# Database Documentation

> **Status: PLANNING.** These are planning documents, not implementation records.

This folder explains the NEXUS database in enough detail to design it, review it, build it, and defend it in a viva.

## Documents

| File | Purpose | Status |
|---|---|---|
| `ER_DIAGRAM.md` | Entity–relationship diagram and entity summary. | Planning |
| `DATABASE_DESIGN.md` | Table design, keys, constraints, indexes, delete rules. | Planning |
| `TABLE_RELATIONSHIPS.md` | Relationship table with cardinality and delete behaviour. | Planning |
| `NORMALIZATION.md` | 1NF, 2NF, and 3NF analysis. | Planning |
| `SQL_CONCEPT_MAPPING.md` | Maps each required DBMS concept to a planned artifact. | Planning |
| `DATA_DICTIONARY.md` | Column-by-column reference for every table. | Planning |

## Reading order

1. `ER_DIAGRAM.md` — the big picture.
2. `DATABASE_DESIGN.md` — how the tables are shaped.
3. `TABLE_RELATIONSHIPS.md` — how they connect.
4. `NORMALIZATION.md` — why the shape is correct.
5. `DATA_DICTIONARY.md` — the exact columns.
6. `SQL_CONCEPT_MAPPING.md` — how the DBMS requirements are demonstrated.

## Approval rule

The schema is **PLANNING** until the user reviews it and confirms the open questions in `DATABASE_DESIGN.md` and `ER_DIAGRAM.md`. Do not create tables before that.
