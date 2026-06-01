# Visuals — make the report readable, not monotone

A wall of text — even well structured — slows reading. The whole point of HTML/CSS over Markdown or a flat PDF is **layout and visuals**. Every report should use visual structure to guide the eye and surface key facts. Apply this guide, but **do not overdo it**: visuals must carry meaning, never decorate.

## Two sources of visuals

1. **Reuse what already exists.** Project material usually already contains graphics — logos, charts (Chart.js, etc.), diagrams, Gantt charts, color palettes. Extract and re-integrate them:
   - **Logos / SVG** → embed inline in the header; adopt the project's color palette as the report's accent colors (visual identity continuity).
   - **Charts / diagrams** → re-create them as **inline SVG/CSS** (see below) using the same data and colors. Do not screenshot.
2. **Propose new visuals** when a table or paragraph hides a comparison, composition, sequence, or flow that a graphic would make instant.

## Prefer inline SVG / CSS over JS chart libraries

Output must stay a **single self-contained file that prints cleanly to PDF**. JS chart libraries (Chart.js, D3) need a runtime and often render blank in print. Build visuals as **inline SVG** or **pure CSS** instead — portable, crisp at any zoom, and print-safe.

## A small, high-value vocabulary of visuals

| Need | Visual | Build with |
|---|---|---|
| Headline figures | **Stat cards** (big number + label) | CSS grid (`.stat-grid`) |
| Composition / shares (e.g. admixture) | **Stacked 100% bar** or donut | inline SVG / CSS + legend |
| Compare quantities (e.g. budget scenarios) | **Horizontal bar chart** | inline SVG |
| Process / architecture | **Flow diagram** (boxes + arrows) | CSS flex (`.flow`) |
| Schedule / phases | **Gantt / timeline** | CSS grid bars positioned by % |
| History / steps in time | **Timeline** | CSS flex with markers |
| A few qualitative components | **Labeled cards** (e.g. S_div) | CSS grid |
| One key takeaway | **Callout box** | `.callout` |

## Rules

- **Meaning first.** Each visual must answer a question the reader has. No chartjunk, no 3D, no gratuitous color.
- **Sober and on-brand.** Reuse the project palette; otherwise the report's accent + a small consistent set of hues. Keep it professional.
- **Accessible.** Sufficient contrast; never rely on color alone — always label values and series directly.
- **Print-safe.** Test that visuals survive `@media print` (no clipped SVG, no JS dependency, no forced page break through a chart).
- **Faithful.** Chart only real data from the sources. If you propose a visual for data that does not exist yet, mark it `[To complete: …]`.
- **Restraint.** Two to four strong visuals per document beat a dozen weak ones.

## Reusable components

`assets/report.css` ships ready-made classes: `.stat-grid`/`.stat-card`, `.flow`/`.flow-step`, `.gantt`, `.hbar`, `.legend`, `.compo-bar`, `.timeline`. Use them so visuals stay consistent across reports.
