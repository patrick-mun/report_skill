# Consolidation — ingesting and reconciling multiple project sources

The main job of this skill is to take the scattered pieces of one project and build a coherent, readable report. Project material is heterogeneous: slide decks, methodology specifications, budget dossiers, draft documents, and bibliographies, each in a different format. This guide explains how to ingest each kind and how to reconcile overlaps.

## 1. Inventory before writing

List every source and what it actually contains. A typical project dossier:

| Piece | Common format | Holds |
|---|---|---|
| Slide deck | HTML + per-slide JSON notes, or PPTX export | Narrative framing, the "story", examples, headline figures |
| Methodology | Markdown (often long) | Authoritative technical specs, algorithms, parameters |
| Budget / financing | HTML dossier, spreadsheet, or Markdown | Numbers, scenarios, tables, timeline/Gantt |
| Main document | Word (.docx) or Markdown | Body text + bibliography (may be unfinished) |
| Plan / outline | Markdown headings | The target structure (treat as the contract) |

## 2. How to read each format

- **Slide JSON notes** (e.g. `data/notes/slide-XX.json`): usually a `notes` field with the speaker's narrative. Read in slide order to recover the argument arc. Slides are good for *framing and examples*, not for exact figures — verify numbers against the methodology or budget source.
- **Methodology Markdown**: the technical source of truth. Extract parameters, formulas, thresholds, validation design. Preserve exact notation.
- **Budget HTML/dossier**: extract figures, scenarios, and timelines. Reproduce numbers exactly; never round or invent. Keep scenario labels intact.
- **Word/Markdown draft**: the prose backbone and the bibliography. If unfinished, use what exists and flag the gaps.
- **Plan/outline**: if the user supplies an outline, it is the **contract** — follow its sections and subsections exactly, in order.

## 3. Source authority (resolving overlap)

The same fact often appears in several pieces. Trust the most authoritative source for that kind of fact:

1. **Technical claims / parameters / algorithms** → methodology document.
2. **Numbers / budget / timeline** → budget dossier (or spreadsheet).
3. **Narrative / motivation / examples** → slides and the main document.
4. **Structure** → the user's plan/outline.

When two sources genuinely disagree on a fact (not just phrasing), **do not silently choose** — surface the conflict to the user with both values and their sources.

## 4. Faithfulness rules

- Every figure, parameter, and technical claim must trace to a source.
- Never round, extrapolate, or "tidy up" numbers.
- If a section of the target plan has no supporting material, write `[To complete: <what is missing>]` and report it.
- Distinguish what the sources state from your own connective prose. Connective prose may summarize and link, but must not add unsourced facts.

## 5. Deliver

Produce the chosen output (layered single document or per-audience versions), then give the user:
- the path(s) to the generated file(s);
- the PDF instructions (`Ctrl/Cmd + P → Save as PDF`);
- a list of every placeholder / gap left to complete;
- any source conflicts you flagged.
