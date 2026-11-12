# VS Code Agent Skills — Location and Convention

VS Code AI Agent Mode supports **Agent Skills** using the open `SKILL.md` convention.

## Canonical location

The loadable skill files live here:

```
.github/skills/<skill-name>/SKILL.md
```

Each `SKILL.md` requires YAML frontmatter with at least:

```yaml
---
name: skill-name
description: When this skill should be used.
---
```

## Relationship to the root `skills/` folder

The root `skills/` folder is the **human-readable index** requested by the project brief. Each subfolder contains a `SKILL.md` that points to the canonical skill file in `.github/skills/`. This avoids two copies of the same instructions drifting apart.

- Canonical, agent-loadable: `.github/skills/<name>/SKILL.md`
- Human index / project map: `skills/<name>/SKILL.md`

## Important honesty rule

Creating a `SKILL.md` file does **not** guarantee that the installed AI agent loads it automatically. Support depends on the VS Code version, the Copilot extension, and workspace settings. If a skill is not loaded, the agent must say so and use the closest documented alternative.

## Available skills

| Skill | Canonical file |
|---|---|
| UI/UX Design | `.github/skills/ui-ux-design/SKILL.md` |
| Frontend Development | `.github/skills/frontend-development/SKILL.md` |
| Flask Backend | `.github/skills/flask-backend/SKILL.md` |
| MySQL Database | `.github/skills/mysql-database/SKILL.md` |
| Database Design | `.github/skills/database-design/SKILL.md` |
| SQL Development | `.github/skills/sql-development/SKILL.md` |
| Security | `.github/skills/security/SKILL.md` |
| Testing | `.github/skills/testing/SKILL.md` |
| Debugging | `.github/skills/debugging/SKILL.md` |
| Documentation | `.github/skills/documentation/SKILL.md` |
| Deployment | `.github/skills/deployment/SKILL.md` |

## Manual check

Open the Chat view, switch to **Agent Mode**, and ask the agent which skills it can see. If it cannot see them, use the root `skills/` files as explicit reading material.
