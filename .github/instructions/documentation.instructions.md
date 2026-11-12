---
applyTo: "**/*.md"
---

# GM University Management System Documentation Instructions

These rules apply to every Markdown file in the project.

## Non-negotiable rules

- Write in clear, beginner-friendly English. Define technical terms the first time they appear.
- Keep one source of truth per topic. Link to the canonical file instead of copying paragraphs.
- Do not claim something is implemented or tested unless it has been verified.
- Use relative links inside the repository.
- Use tables for structured facts, code blocks for commands and SQL.
- Keep file names in `SCREAMING_SNAKE_CASE.md` inside `project-context/` and `docs/`.
- Every ADR must include: title, date, status, context, options, decision, reasons, consequences.
- When a document changes meaningfully, update `CHANGELOG.md`.
- Do not leave placeholder text like `TODO` or `TBD` without an explicit owner and date.

## Diagram rules

- Use Mermaid for architecture and flow diagrams.
- Keep diagrams readable; split a large diagram into smaller ones.
- Label every arrow in a flow diagram.

## Verification

- Check that every relative link resolves.
- Check that the document does not contradict `CURRENT_STATUS.md`.
- Check that the document does not duplicate an existing canonical explanation.
