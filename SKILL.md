---
name: report-formatter
description: >-
  Consolidate the heterogeneous pieces of a project (slides, methodology
  documents, budget/financing dossier, draft Word/Markdown, bibliography) into
  clean, audience-tailored reports published as self-contained, print-to-PDF
  HTML. Use when the user wants to assemble, consolidate, format, structure, or
  publish a project dossier, a research/funding application, a professional
  report, or a briefing so it is readable for a given audience and quick to
  understand. Triggers on requests like "make a readable dossier from these
  pieces", "consolidate the slides + budget + doc into a report", "format this
  for funders/scientists", "create a professional report from these materials".
triggers:
  - /report
---

# Report Formatter

Turn the scattered pieces of a project into clean, professional,
**self-contained HTML documents** optimized for fast reading and ready to print
to PDF (`Ctrl/Cmd + P → Save as PDF`). Reports are generated in English by
default; use the `--language` option to generate in French or other languages.

## Two jobs this skill handles

1. **Single-source formatting** — one text (a report, a memo, notes) → one
   clean formatted document. Use the procedure in *Simple formatting* below.
2. **Multi-source consolidation** — several heterogeneous pieces of one project
   (slide decks, methodology specs, budget dossiers, draft documents,
   bibliography) → one coherent report, or several audience-specific versions.
   This is the main use case. See `references/consolidation.md`.

## Invocation

The skill triggers automatically when a request matches the description above.
It can also be invoked explicitly with `/report`, optionally passing the source
files, the target audience, and the output language:

```
/report                                  # consolidate the pieces in context
/report slides.json budget.html doc.md   # name the sources explicitly
/report --audience funder                # one funder-targeted version
/report --audience scientist             # one scientific/expert version
/report --audience funder,scientist      # several versions at once
/report --audience clinician             # clinicians and medical professionals
/report --mode layered                   # one layered document (default if no audience)
/report --language EN                    # English (default)
/report --language FR                    # French
/report --language EN --audience funder  # English + funder audience
```

**`--audience` values** (mutually exclusive from `--mode`):
`funder`, `scientist`, `clinician`, `institution`, `public`.
When listed (singular or CSV), produce one self-contained HTML file per audience.

**`--mode` values** (mutually exclusive from `--audience`):
- `layered` (default) — one navigable document: executive summary first, then full detail, then annexes. Use when a single report must serve multiple audiences with different reading depths.

**`--language` values**:
- `EN` (default) — output in English
- `FR` — output in French

When both `--mode` and `--audience` are omitted, the skill defaults to `--mode layered`.

See `references/audiences.md` for how each audience shapes depth, vocabulary, and emphasis.

## Core principle

**Reformat, restructure, and consolidate — do not invent content.** Reorganize,
clarify headings, tighten paragraphs, reconcile pieces, and apply consistent
styling. Every technical claim, figure, or number must trace back to a source.
If an expected section is missing or a source is silent, insert a clearly marked
placeholder such as `[To complete: …]` rather than fabricating substance, and
tell the user what is missing.

## Output modes (multi-source)

The user chooses, or you ask:

- **Layered single document** — one navigable report: executive summary first
  (for funders / busy readers), then full scientific and budget detail, then
  annexes. Easiest to maintain.
- **Audience-specific versions** — same substance, re-framed per audience
  (funders, scientists/experts, clinicians, institutions/general public). See
  `references/audiences.md` for how to adapt depth, vocabulary, and emphasis.

## Procedure — multi-source consolidation

1. **Inventory the sources.** List every piece and what it holds (see
   `references/consolidation.md` for handling slide JSON, methodology Markdown,
   budget HTML, Word/Markdown drafts).
2. **Establish source authority.** When the same fact appears in several places,
   trust the most authoritative source (e.g. a methodology spec over a slide
   note). Flag genuine conflicts to the user — do not silently pick one.
3. **Choose the target structure.** Use a plan supplied by the user if any
   (their outline is the contract); otherwise use
   `references/structure-research.md` or `references/structure-professional.md`.
4. **Choose the output mode and audience** (layered vs. per-audience).
5. **Map content onto the structure**, drawing faithfully from the sources.
   Mark gaps with `[To complete: …]`.
6. **Apply the editorial rules** in `references/style-guide.md` **and the visual
   rules** in `references/visuals.md` — reuse graphics, logos and palettes that
   already exist in the sources, and add 2–4 sober inline-SVG/CSS visuals
   (stat cards, composition bar, bar chart, flow diagram, gantt, timeline) where
   they clarify, not decorate.
7. **Lay out on A4 sheets.** Use the `.sheet` model in `assets/report.css`:
   each page is an explicit 210×297 mm box with padding and footer. No orphaned
   tables or empty gaps. See `references/pagination.md`.
8. **Fill the template.** Start from a template in `templates/`, populate it with
   the mapped content, and inline `assets/report.css` and `assets/paginate.js`
   (in `<style>` and `<script>` tags at the end of `<body>`) so the output is a
   single portable HTML file.
9. **Generate the final HTML.** Test in browser (check overflow flags, TOC
   numbering, footer page numbers), then deliver for print-to-PDF. See
   `references/pagination.md` for the print checklist.

## Procedure — simple formatting

1. Read the user's text (report, memo, notes).
2. Restructure to match the outline in `references/style-guide.md`: executive
   summary, max 3 heading levels, short paragraphs, lists, figures with captions.
3. Apply consistent typography and spacing from `assets/report.css`.
4. Lay out on A4 sheets (one page at a time, no orphans).
5. Inline CSS and JS, deliver as single HTML file.

## References

All guidance is in the `references/` directory:

- `consolidation.md` — how to ingest & reconcile multiple sources
- `audiences.md` — how to adapt a report per audience
- `visuals.md` — reuse & propose charts/diagrams (no monotone text)
- `pagination.md` — A4 sheet model: cover, TOC, footers, page numbers
- `style-guide.md` — 11 editorial rules for fast, clear reading
- `structure-research.md` — section plan: research / funding report
- `structure-professional.md` — section plan: professional report
