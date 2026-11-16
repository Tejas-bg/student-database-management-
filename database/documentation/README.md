# Database Documentation

> **Stage 3 status: DESIGN COMPLETE, CORRECTIONS APPLIED FOR REVIEW.** These documents describe the proposed MySQL schema. No database has been created, connected, or executed.

This folder explains the GM University Management System database in enough detail to design it, review it, build it, and defend it in a viva.

## Documents

| File | Purpose | Status |
|---|---|---|
| `DATABASE_ARCHITECTURE.md` | Module map, design principles, authentication model, indexing, Flask readiness | Complete for review |
| `ER_DIAGRAM.md` | Mermaid ER diagram with entities, keys, cardinalities | Complete for review |
| `DATA_DICTIONARY.md` | Column-by-column reference for all 24 tables | Complete for review |
| `TABLE_DESCRIPTIONS_AND_RELATIONSHIPS.md` | Table purposes, FK relationships, cardinality, delete rules | Complete for review |
| `NORMALIZATION.md` | 1NF, 2NF, 3NF analysis, removed redundancy, documented business exceptions | Complete for review |
| `SECURITY.md` | Authentication storage, credential setup, RBAC, least privilege, sensitive data, transactions | Complete for review |
| `REQUIREMENTS_TO_TABLE_MAPPING.md` | Maps Stage 2 pages/forms/filters to tables and columns | Complete for review |
| `SQL_CONCEPT_MAPPING.md` | Maps each required DBMS concept to its artifact | Prepared |
| `DATABASE_DESIGN.md` | Earlier planning draft (historical; superseded by the documents above) | Historical |
| `TABLE_RELATIONSHIPS.md` | Earlier planning draft (historical; superseded by `TABLE_DESCRIPTIONS_AND_RELATIONSHIPS.md`) | Historical |

## Reading order

1. `DATABASE_ARCHITECTURE.md` — the big picture and module map.
2. `ER_DIAGRAM.md` — entities, keys, and cardinalities.
3. `TABLE_DESCRIPTIONS_AND_RELATIONSHIPS.md` — how tables connect.
4. `NORMALIZATION.md` — why the shape is correct.
5. `DATA_DICTIONARY.md` — the exact columns.
6. `REQUIREMENTS_TO_TABLE_MAPPING.md` — how the design supports the dashboards.
7. `SECURITY.md` — how accounts and data are protected.
8. `SQL_CONCEPT_MAPPING.md` — where each DBMS concept is demonstrated.

## Approval rule

The schema is **design complete, corrected, and statically validated**. Do not create tables or connect the application until the user approves Stage 3.

## Source of truth

- Schema: `../schema/001_schema.sql`
- Views: `../views/001_views.sql`
- Integrity triggers: `../triggers/001_integrity_triggers.sql`
- Fictional seed data: `../seeds/001_sample_data.sql`
- Demonstrations: `../demonstrations/`