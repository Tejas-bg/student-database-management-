# Architecture Decision Records (ADRs)

An **ADR** is a short document that records an important decision, the options considered, and the consequences. It prevents future agents from silently changing direction.

## Index

| ADR | Title | Status |
|---|---|---|
| `ADR-001` | Technology Stack | Approved (baseline) |
| `ADR-002` | Three-Tier Architecture | Approved |
| `ADR-003` | MySQL Database Selection | Approved |
| `ADR-004` | Frontend Design Philosophy | Approved |
| `ADR-005` | Database Access Strategy | Proposed — awaiting approval |
| `ADR-TEMPLATE` | Template for new decisions | Template |

## Status values

| Status | Meaning |
|---|---|
| Proposed | Suggested, not yet approved. |
| Approved | Accepted and in effect. |
| Superseded | Replaced by a newer ADR. |
| Deprecated | Still recorded, but no longer recommended. |
| Rejected | Considered and not adopted. |

## Rules

- One decision per ADR.
- Record only decisions that were actually made.
- Do not rewrite an approved ADR to change history. Add a new ADR that supersedes it.
- Every ADR includes: title, date, status, context, options, decision, reasons, consequences.
- Link related ADRs.
