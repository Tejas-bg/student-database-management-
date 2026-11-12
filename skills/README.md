# GM University Management System Skills — Human Index

This folder is the human-readable map of the GM University Management System AI skill set.

## Where the real skill files live

VS Code Agent Mode loads skills from:

```
.github/skills/<skill-name>/SKILL.md
```

That is the **canonical** location. Each folder here contains a small `SKILL.md` pointer that links to the canonical file. This avoids maintaining two copies of the same instructions that could drift apart.

## Skills

| Skill | Folder | Canonical file |
|---|---|---|
| UI/UX Design | `ui-ux-design/` | `.github/skills/ui-ux-design/SKILL.md` |
| Frontend Development | `frontend-development/` | `.github/skills/frontend-development/SKILL.md` |
| Flask Backend | `flask-backend/` | `.github/skills/flask-backend/SKILL.md` |
| MySQL Database Operations | `mysql-database/` | `.github/skills/mysql-database/SKILL.md` |
| Database Design and Normalization | `database-design/` | `.github/skills/database-design/SKILL.md` |
| SQL Development | `sql-development/` | `.github/skills/sql-development/SKILL.md` |
| Application Security | `security/` | `.github/skills/security/SKILL.md` |
| Testing and QA | `testing/` | `.github/skills/testing/SKILL.md` |
| Debugging | `debugging/` | `.github/skills/debugging/SKILL.md` |
| Technical Documentation | `documentation/` | `.github/skills/documentation/SKILL.md` |
| Deployment and Setup | `deployment/` | `.github/skills/deployment/SKILL.md` |

## Skill mapping note

The project brief asks for "MySQL Database Design" and "Database Normalization" as separate skills. In this workspace they are split as:

- **MySQL Database Operations** (`mysql-database`) — server setup, users, privileges, transactions, views, procedures, triggers.
- **Database Design and Normalization** (`database-design`) — ER modelling, keys, cardinality, 1NF/2NF/3NF, schema review.

This keeps operational work separate from design work and avoids a skill that tries to do both poorly.

## Honesty note

Creating a `SKILL.md` file does not guarantee that the installed agent loads it. Support depends on the VS Code version and the Copilot extension. If the agent cannot see a skill, it must say so and read the file explicitly.
