---
name: report-formatter
description: >-
  Format and polish reports for professional publication as a styled,
  print-to-PDF HTML document. Use when the user wants to lay out, format,
  clean up, structure, or publish a research report, professional report,
  briefing note, or memo so it is easy to read and quick to understand.
  Triggers on requests like "format this report", "make this report
  presentable", "turn this into a clean PDF-ready document", "mets en forme
  ce rapport", "formate ce compte-rendu".
---

# Report Formatter

Turn raw text into a clean, professional, **self-contained HTML document**
optimized for fast reading and ready to print to PDF (`Ctrl/Cmd + P → Save as
PDF`). Reports are written **in French** by default; match the language of the
source text if it is clearly something else.

## When to use

The user provides report content (research findings, a professional briefing,
meeting notes, an analysis) and wants it formatted for publication or sharing
in a professional context.

## Core principle

**Reformat and restructure — do not invent content.** Reorganize, clarify
headings, tighten paragraphs, and apply consistent styling. If an expected
section is missing (e.g. no executive summary, no conclusion), insert a clearly
marked placeholder such as `[À compléter : synthèse exécutive]` rather than
fabricating substance, and tell the user what is missing.

## Procedure

1. **Identify the report type.** Choose the right structure:
   - Research / academic report → `references/structure-recherche.md`
   - Professional / business report, briefing, memo → `references/structure-pro.md`
   If unsure, ask the user briefly, or default to professional.

2. **Structure the content** by mapping the source text onto the chosen
   plan-type. Reorder sections as needed. Flag missing sections with
   placeholders.

3. **Apply the editorial rules** in `references/style-guide.md` (executive
   summary first, short paragraphs, clear heading hierarchy, key-point
   callouts, captioned figures/tables, sparing emphasis).

4. **Fill the matching template** in `templates/` (`professionnel.html` or
   `recherche.html`), replacing the `<!-- … -->` placeholder comments with the
   structured content.

5. **Produce a self-contained HTML file.** Inline the contents of
   `assets/report.css` into a `<style>` block in the `<head>` so the output is
   a single portable file. Save it with a descriptive name
   (e.g. `rapport-<sujet>.html`).

6. **Tell the user how to get a PDF:** open the HTML in a browser and use
   `Ctrl/Cmd + P → Save as PDF`. The CSS already handles A4 page size, margins,
   and clean page breaks via `@media print`.

## Reference files

- `references/style-guide.md` — editorial rules for fast, clear reading.
- `references/structure-recherche.md` — section plan for research reports.
- `references/structure-pro.md` — section plan for professional reports.
- `assets/report.css` — the single stylesheet (screen + `@media print` A4).
- `templates/professionnel.html`, `templates/recherche.html` — HTML skeletons.
- `examples/` — rendered reference outputs.
