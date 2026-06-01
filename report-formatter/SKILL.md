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
  for funders/scientists", "mets en forme ce dossier de projet", "consolide ces
  pièces en un rapport lisible".
triggers:
  - /report
---

# Report Formatter

Turn the scattered pieces of a project into clean, professional,
**self-contained HTML documents** optimized for fast reading and ready to print
to PDF (`Ctrl/Cmd + P → Save as PDF`). Reports are written **in French** by
default; match the language of the source material if it is clearly otherwise.

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
files and the target audience:

```
/report                                  # consolidate the pieces in context
/report slides.json budget.html doc.md   # name the sources explicitly
/report --audience financeur             # one funder-targeted version
/report --audience scientifique          # one scientific/expert version
/report --audience financeur,scientifique  # several versions at once
/report --audience institution           # institutions / general public
/report --mode layered                   # one layered document (default if no audience)
```

**`--audience` values** (mutually exclusive from `--mode`):
`financeur`, `scientifique`, `clinicien`, `institution`, `public`.
When listed (singular or CSV), produce one self-contained HTML file per audience.

**`--mode` values** (mutually exclusive from `--audience`):
- `layered` (default) — one navigable document: executive summary first, then full detail, then annexes. Use when a single report must serve multiple audiences with different reading depths.

When both are omitted, the skill defaults to `--mode layered`.

See `references/audiences.md` for how each audience shapes depth, vocabulary, and emphasis.

## Core principle

**Reformat, restructure, and consolidate — do not invent content.** Reorganize,
clarify headings, tighten paragraphs, reconcile pieces, and apply consistent
styling. Every technical claim, figure, or number must trace back to a source.
If an expected section is missing or a source is silent, insert a clearly marked
placeholder such as `[À compléter : …]` rather than fabricating substance, and
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
   `references/structure-recherche.md` or `references/structure-pro.md`.
4. **Choose the output mode and audience** (layered vs. per-audience).
5. **Map content onto the structure**, drawing faithfully from the sources.
   Mark gaps with `[À compléter : …]`.
6. **Apply the editorial rules** in `references/style-guide.md` **and the visual
   rules** in `references/visuals.md` — reuse graphics, logos and palettes that
   already exist in the sources, and add 2–4 sober inline-SVG/CSS visuals
   (stat cards, composition bar, bar chart, flow diagram, gantt, timeline) where
   they make a comparison, composition, flow or schedule instant. Never leave a
   long report as an undifferentiated wall of text.
7. **Lay it out on A4 sheets** following `references/pagination.md`: split the
   content into explicit `.sheet` pages (210 × 297 mm), give each a footer, and
   inline `assets/paginate.js` for automatic page numbers (bottom-right) and
   overflow flagging. Required whenever the report is meant to be printed or
   exported to PDF — it prevents lonely tables and large empty gaps.
8. **Fill the matching template** (`templates/`), inlining `assets/report.css`
   into a `<style>` block so the output is a single portable file.
9. **Tell the user how to get a PDF** and list every placeholder/gap you left.

## Procedure — simple formatting

Identify the report type, map the text onto `references/structure-pro.md` or
`references/structure-recherche.md`, apply `references/style-guide.md`, fill the
matching template, produce a self-contained HTML file.

## Reference files

- `references/consolidation.md` — how to ingest and reconcile multiple sources.
- `references/audiences.md` — how to adapt a report per audience.
- `references/visuals.md` — how to reuse and propose visuals (charts, diagrams,
  timelines) so reports are readable, not monotone.
- `references/pagination.md` — the A4 sheet model: print-perfect pages, footers
  and page numbers (avoids lonely blocks and empty gaps).
- `references/style-guide.md` — editorial rules for fast, clear reading.
- `references/structure-recherche.md` — section plan for research/funding reports.
- `references/structure-pro.md` — section plan for professional reports.
- `assets/report.css` — the single stylesheet (screen + `@media print` A4, sheet model).
- `assets/paginate.js` — page numbering + overflow flagging for the sheet model.
- `templates/` — HTML skeletons (`professionnel.html`, `recherche.html`,
  `dossier-scientifique.html`).
- `examples/` — rendered reference outputs, including a real consolidated
  dossier (Génome Réunion).
