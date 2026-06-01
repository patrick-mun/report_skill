# report_skill

A Claude Code **skill** that consolidates the scattered pieces of a project —
slide decks, methodology documents, budget/financing dossiers, draft documents,
bibliographies — into clean, audience-tailored reports published as
**self-contained, print-to-PDF HTML**.

## What it does

- **Multi-source consolidation** — ingests heterogeneous pieces (slide JSON,
  methodology Markdown, budget HTML, Word/Markdown drafts), reconciles overlaps
  using a source-authority order, and never invents content (gaps are flagged
  `[À compléter : …]`).
- **Audience targeting** — produces either one layered document or several
  audience-specific versions (funders, scientists/experts, clinicians,
  institutions/general public).
- **Print-ready output** — a single HTML file with inlined CSS, A4 print rules,
  ready for `Ctrl/Cmd + P → Save as PDF`. Reports default to French.

## Structure

```
report-formatter/
├── SKILL.md                    # trigger + procedures (simple + consolidation)
├── references/
│   ├── consolidation.md        # how to ingest & reconcile multiple sources
│   ├── audiences.md            # how to adapt a report per audience
│   ├── style-guide.md          # editorial rules for fast, clear reading
│   ├── structure-recherche.md  # section plan: research / funding report
│   └── structure-pro.md        # section plan: professional report
├── assets/
│   └── report.css              # single stylesheet (screen + @media print A4)
├── templates/
│   ├── professionnel.html
│   ├── recherche.html
│   └── dossier-scientifique.html
└── examples/
    ├── exemple-pro.html
    └── exemple-genome-reunion-scientifique.html   # real consolidated dossier
```

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
