---
name: documentation
description: Use when writing or updating NEXUS project documentation, architecture notes, database documentation, API docs, user guides, ADRs, changelogs, or README files. Use it to keep documentation accurate and beginner-friendly.
---

# NEXUS Skill — Technical Documentation

## Purpose

Keep NEXUS understandable to the student, future AI agents, and the evaluator. Documentation must describe reality, not intentions.

## When to use

- After a meaningful code, schema, or design change.
- When adding a module.
- When creating or updating an ADR.
- When writing the project report or user guide.
- When a document contradicts the code.
- Before a stage gate or submission.

## Required project context

1. `project-context/CURRENT_STATUS.md`.
2. `project-context/PROJECT_OVERVIEW.md`.
3. `.github/instructions/documentation.instructions.md`.
4. The document being changed, read in full first.

## Workflow

1. **Read the existing document** before editing. Check for contradictions.
2. **Identify the single source of truth** for the topic. Link to it instead of copying.
3. **Write for a beginner.** Define terms, use short paragraphs, add examples.
4. **Use structure.** Headings, tables, and code blocks.
5. **Use Mermaid** for flows and diagrams.
6. **Record what is verified** and what is not.
7. **Update cross-links.**
8. **Check for contradictions** with `CURRENT_STATUS.md` and the code.
9. **Update `CHANGELOG.md`** if the change is significant.
10. **Proofread.** Check links, spelling, and command accuracy.

## Rules and restrictions

- Do not claim a feature works unless it was verified.
- Do not invent screenshots, test results, or database output.
- Do not duplicate a canonical explanation; link to it.
- Do not leave `TODO` without an owner and date.
- Do not use jargon without a definition.
- Do not change an ADR to rewrite history; add a new ADR.
- Do not document a planned feature as if it exists.

## Quality checklist

- [ ] The document describes the current reality.
- [ ] Technical terms are defined or linked to `GLOSSARY.md`.
- [ ] It is consistent with `CURRENT_STATUS.md`.
- [ ] It does not duplicate another document.
- [ ] Relative links work.
- [ ] Commands and SQL are correct.
- [ ] Diagrams are readable and labelled.
- [ ] Verified and unverified claims are separated.
- [ ] `CHANGELOG.md` is updated if needed.

## Expected deliverables

- Updated documentation.
- A changelog entry when significant.
- An ADR when a decision is made.
- A note of any open question or limitation.

## Common mistakes to avoid

- Writing a feature list that describes hopes, not reality.
- Copying the same explanation into three files.
- Leaving broken links.
- Using unexplained acronyms.
- Claiming screenshots exist when they do not.
- Rewriting an ADR instead of adding a new one.
- Forgetting to update the status file.
