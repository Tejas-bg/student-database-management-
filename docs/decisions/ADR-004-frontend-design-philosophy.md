# ADR-004 — Frontend Design Philosophy

- **Date:** 2026-11-12
- **Status:** Approved
- **Supersedes:** None
- **Superseded by:** None

## Context

Most student projects use a generic Bootstrap admin template. The GM University Management System should look intentional and professional while staying accessible and buildable by a beginner. The interface must support dense academic data without feeling cluttered.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| Generic Bootstrap admin theme | Fast to build; familiar. | Looks like every other project; weak identity. |
| Pure Apple minimalism | Calm, elegant, readable. | Can feel empty for data-heavy screens; may under-signal technical depth. |
| Pure Nothing monochrome | Strong identity, technical. | Can be harsh; dot-matrix motifs can hurt readability if overused. |
| Hybrid: Apple calm + Nothing technical | Distinctive, readable, and appropriate for an academic system. | Requires discipline to keep the accent and motifs restrained. |

## Decision

Use a **hybrid design language**: Apple-inspired minimalism, whitespace, typography, and refined interactions, combined with Nothing-inspired monochrome discipline, dot-matrix accents, and technical detail, presented through the official GM University identity.

Palette:

- University Maroon `#5B2020`
- Deep Maroon `#421919`
- University Gold `#E3B559` (accent only, never body text on light surfaces)
- Warm Ivory `#F8F6F0`
- White `#FFFFFF`
- Graphite `#242424`
- Muted Grey `#8A8580`
- Silver `#BDBDBD` (dark-theme borders and secondary text)
- Obsidian `#111111` (dark-theme page background)

## Reasons

- It gives the project a distinct identity without compromising readability.
- It supports both calm reading and dense data.
- The palette is small enough to apply consistently.
- It is achievable with CSS custom properties and Bootstrap 5.
- The official logo supplies institutional recognition while the interface remains original.

## Consequences

### Positive

- A professional, memorable interface.
- A clear design reference for Stage 1.
- Strong light and dark theme support.

### Negative

- More design work than copying a template.
- University Gold must be used carefully to avoid visual noise, and never as body text on ivory or white.
- Accessibility must be checked, not assumed.

### Follow-up work

- Build the design tokens in Stage 1.
- Verify contrast and keyboard access.
- Keep decorative dot-matrix motifs subtle.

## Related decisions

- ADR-001 — Technology Stack
