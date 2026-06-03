# report_skill

A Claude Code **skill** that consolidates the scattered pieces of a project —
slide decks, methodology documents, budget/financing dossiers, draft documents,
bibliographies — into clean, audience-tailored reports published as
**self-contained, print-to-PDF HTML** laid out on real A4 pages.

## What it does

- **Multi-source consolidation** — ingests heterogeneous pieces (slide JSON,
  methodology Markdown, budget HTML, Word/Markdown drafts), reconciles overlaps
  using a source-authority order, and never invents content (gaps are flagged
  `[To complete : …]`).
- **Audience targeting** — produces either one layered document or several
  audience-specific versions (funders, scientists/experts, clinicians,
  institutions/general public).
- **Visuals, not walls of text** — reuses graphics/logos/palettes already in the
  sources and adds sober inline-SVG/CSS visuals (stat cards, composition bars,
  bar charts, flow diagrams, gantts, timelines).
- **Print-perfect A4** — content flows naturally on screen, and CSS `@page`
  rules paginate it into A4 pages in print: major sections start on a new page,
  tables and figures are never split.
- **Cover page + clickable TOC** — a title section (subject, author, reviewer)
  and a table of contents whose entries are clickable and auto-numbered to the
  page they point to.
- **Footers + page numbers** — a footer with `Page n / total` is stamped
  automatically, bottom-right (cover and TOC excluded).

Output is a single HTML file with inlined CSS/JS, ready for
`Ctrl/Cmd + P → Save as PDF`. Reports are generated in English by default.

## Structure

```
report-formatter/
├── SKILL.md                    # trigger + procedures (simple + consolidation)
├── references/
│   ├── consolidation.md        # how to ingest & reconcile multiple sources
│   ├── audiences.md            # how to adapt a report per audience
│   ├── visuals.md              # reuse & propose charts/diagrams (no monotone text)
│   ├── pagination.md           # A4 pagination with CSS @page: cover, TOC, footers, page numbers
│   ├── style-guide.md          # editorial rules for fast, clear reading
│   ├── structure-research.md   # section plan: research / funding report
│   └── structure-professional.md # section plan: professional report
├── assets/
│   ├── report-linear.css       # single stylesheet (visuals + Linear Flux Model)
│   ├── paginate.js             # page numbering + TOC numbers
│   └── legacy/                 # archived .sheet-model assets (report.css, paginate-sheet.js)
├── templates/
│   ├── professional.html
│   ├── research.html
│   └── scientific-dossier.html
└── examples/
    ├── example-professional.html           # professional report
    ├── example-genome-meeting-scientific.html # consolidated dossier (scientific audience)
    └── example-genome-meeting-funder.html  # same project, funder audience
```

## The linear flux model

Content flows naturally in the browser, and **CSS `@page` rules handle A4
pagination automatically** (no rigid page boxes to manage):

- `@page { size: A4; margin: 20mm; }` tells the browser each page is A4-sized.
- `h2 { break-before: page; }` starts each major section on a new page.
- `table, figure, aside { break-inside: avoid; }` keeps blocks whole.
- `<section class="cover">` — title page (subject, author, reviewer, date, version).
- `<nav class="toc-page">` — clickable table of contents; `paginate.js` fills in
  each entry's page number from the section it links to.
- `<footer class="page-footer">` — `paginate.js` stamps `Page n / total`
  bottom-right (cover and TOC excluded).

Inline `assets/report-linear.css` (in `<style>`) and `assets/paginate.js` (in a
`<script>` at the end of `<body>`) so the output stays a single portable file.
See `references/pagination.md`.

## Visual components

The skill provides a library of reusable, print-safe visual components for charts,
diagrams, and data display: stat cards, bar charts, flow diagrams, Gantt timelines,
composition bars, and more. See `references/visuals.md` for component selection,
usage patterns, and responsive modifiers (e.g., `.flow--small` for dense flows,
automatic font scaling in stat cards).

## Installation

Copy the `report-formatter/` directory into your skills folder
(`~/.claude/skills/` for personal use, or `.claude/skills/` in a project).
Claude loads it automatically when a request matches its triggers.

## Usage

The skill triggers automatically when your request matches it, e.g.:

- "Format this report as a readable PDF."
- "Consolidate these slides + this budget + this Word document into a
  scientific dossier."
- "Generate a funder version and a scientific version of this project."

You can also invoke it explicitly with the `/report` command, naming the
sources, target audience, and output language:

```
/report                                   # consolidate the pieces in context
/report slides.json budget.html doc.md    # name the sources explicitly
/report --audience funder                 # one funder-targeted version
/report --audience scientific             # one scientific / expert version
/report --audience funder,scientific      # several versions at once
/report --mode layered                    # one layered document (default)
/report --language EN                     # English (default)
/report --language FR                     # French
```

### `--audience` options

| Value      | Tailored for             | Emphasis                                                           |
| ---------- | ------------------------ | ------------------------------------------------------------------ |
| `funder`   | Funders, decision-makers | Stakes, impact, budget & feasibility first; methodology vulgarized |
| `scientist` | Scientists / experts     | Full methodology, formulas, validation, annexes preserved          |
| `clinician`   | Clinicians               | Clinical implications and applicability                            |
| `institution`  | Institutions             | Institutional framing, governance, partnerships                    |
| `public`   | General public           | Vulgarized, jargon-free, narrative                                 |

Pass several values comma-separated to get one HTML file per audience. Omit
`--audience` (or use `--mode layered`) to get a single layered document:
executive summary first, then full detail, then annexes.

### `--language` options

| Value | Description |
|-------|-------------|
| `EN`  | English (default) |
| `FR`  | French |

## Printing to PDF

Open the HTML, `Ctrl/Cmd + P`, choose **A4**, set margins to **Default** (the
`@page` rule supplies the 20 mm margin) and enable **Background graphics** so
colours print. Each major section starts on its own A4 page.
