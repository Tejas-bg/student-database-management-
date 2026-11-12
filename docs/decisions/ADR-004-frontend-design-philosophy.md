# ADR-004 — Frontend Design Philosophy

- **Date:** 2026-11-12
- **Status:** Approved
- **Supersedes:** None
- **Superseded by:** None

## Context

Most student projects use a generic Bootstrap admin template. NEXUS should look intentional and professional while staying accessible and buildable by a beginner. The interface must support dense academic data without feeling cluttered.

## Options considered

| Option | Pros | Cons |
|---|---|---|
| Generic Bootstrap admin theme | Fast to build; familiar. | Looks like every other project; weak identity. |
| Pure Apple minimalism | Calm, elegant, readable. | Can feel empty for data-heavy screens; may under-signal technical depth. |
| Pure Nothing monochrome | Strong identity, technical. | Can be harsh; dot-matrix motifs can hurt readability if overused. |
| Hybrid: Apple calm + Nothing technical | Distinctive, readable, and appropriate for an academic system. | Requires discipline to keep the accent and motifs restrained. |

## Decision

Use a **hybrid design language**: Apple-inspired minimalism, whitespace, typography, and refined interactions, combined with Nothing-inspired monochrome discipline, dot-matrix accents, and technical detail.

Palette:

- Obsidian `#111111`
- Paper `#F5F5F2`
- White `#FFFFFF`
- Silver `#BDBDBD`
- Graphite `#292929`
- Signal Lime `#D7FF35` (accent only)

## Reasons

- It gives the project a distinct identity without compromising readability.
- It supports both calm reading and dense data.
- The palette is small enough to apply consistently.
- It is achievable with CSS custom properties and Bootstrap 5.

## Consequences

### Positive

- A professional, memorable interface.
- A clear design reference for Stage 1.
- Strong light and dark theme support.

### Negative

- More design work than copying a template.
- Signal Lime must be used carefully to avoid visual noise.
- Accessibility must be checked, not assumed.

### Follow-up work

- Build the design tokens in Stage 1.
- Verify contrast and keyboard access.
- Keep decorative dot-matrix motifs subtle.

## Related decisions

- ADR-001 — Technology Stack
