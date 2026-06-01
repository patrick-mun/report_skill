# report_skill

A Claude Code **skill** that consolidates the scattered pieces of a project —
slide decks, methodology documents, budget/financing dossiers, draft documents,
bibliographies — into clean, audience-tailored reports published as
**self-contained, print-to-PDF HTML** laid out on real A4 pages.

## What it does

- **Multi-source consolidation** — ingests heterogeneous pieces (slide JSON,
  methodology Markdown, budget HTML, Word/Markdown drafts), reconciles overlaps
  using a source-authority order, and never invents content (gaps are flagged
  `[À compléter : …]`).
- **Audience targeting** — produces either one layered document or several
  audience-specific versions (funders, scientists/experts, clinicians,
  institutions/general public).
- **Visuals, not walls of text** — reuses graphics/logos/palettes already in the
  sources and adds sober inline-SVG/CSS visuals (stat cards, composition bars,
  bar charts, flow diagrams, gantts, timelines).
- **Print-perfect A4** — the document is split into explicit A4 sheets
  (210 × 297 mm): real pages on screen, one sheet per page in print, no lonely
  tables or empty gaps.
- **Cover page + clickable TOC** — title sheet (subject, author, reviewer) and a
  table of contents whose entries are clickable and auto-numbered to the page
  they point to.
- **Footers + page numbers** — every content sheet carries a footer with
  `Page n / total`, bottom-right, numbered automatically (cover and TOC excluded).

Output is a single HTML file with inlined CSS/JS, ready for
`Ctrl/Cmd + P → Save as PDF`. Reports default to French.

## Structure

```
report-formatter/
├── SKILL.md                    # trigger + procedures (simple + consolidation)
├── references/
│   ├── consolidation.md        # how to ingest & reconcile multiple sources
│   ├── audiences.md            # how to adapt a report per audience
│   ├── visuals.md              # reuse & propose charts/diagrams (no monotone text)
│   ├── pagination.md           # A4 sheet model: cover, TOC, footers, page numbers
│   ├── style-guide.md          # editorial rules for fast, clear reading
│   ├── structure-recherche.md  # section plan: research / funding report
│   └── structure-pro.md        # section plan: professional report
├── assets/
│   ├── report.css              # single stylesheet (visuals + A4 sheet model)
│   └── paginate.js             # page numbering + TOC numbers + overflow flag
├── templates/
│   ├── professionnel.html
│   ├── recherche.html
│   └── dossier-scientifique.html
└── examples/
    ├── exemple-pro.html                            # professional report
    ├── exemple-genome-reunion-scientifique.html    # consolidated dossier (scientific audience)
    └── exemple-genome-reunion-financier.html       # same project, funder audience
```

## The A4 sheet model

Each page is an explicit `.sheet` of 210 × 297 mm:

- `body.paged` enables the paged background; the grey gap between sheets marks
  the boundary to the next page.
- `.sheet--cover` — title page (subject, author, reviewer, date, version).
- `.sheet--toc` — clickable table of contents; `paginate.js` fills in each
  entry's page number from the section it links to.
- Each content `.sheet` ends with a `.sheet__footer`; `paginate.js` stamps
  `Page n / total` bottom-right and flags any sheet that overflows one A4 page.

Inline `assets/report.css` (in `<style>`) and `assets/paginate.js` (in a
`<script>` at the end of `<body>`) so the output stays a single portable file.
See `references/pagination.md`.

## Installation

Copy the `report-formatter/` directory into your skills folder
(`~/.claude/skills/` for personal use, or `.claude/skills/` in a project).
Claude loads it automatically when a request matches its triggers.

## Usage

Ask Claude to format or consolidate report material, e.g.:

- « Mets en forme ce rapport en PDF lisible. »
- « Consolide ces slides + ce budget + ce document Word en un dossier
  scientifique. »
- « Génère une version financeur et une version scientifique de ce projet. »

## Printing to PDF

Open the HTML, `Ctrl/Cmd + P`, choose **A4**, set margins to **None** (the sheet
supplies its own margins) and enable **Background graphics** so colours print.
One sheet renders as one A4 page.
