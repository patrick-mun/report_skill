# Visuals — make the report readable, not monotone

A wall of text — even well structured — slows reading. The whole point of HTML/CSS over Markdown or a flat PDF is **layout and visuals**. Every report should use visual structure to guide the eye and surface key facts. Apply this guide, but **do not overdo it**: visuals must carry meaning, never decorate.

## Two sources of visuals

1. **Reuse what already exists.** Project material usually already contains graphics — logos, charts (Chart.js, etc.), diagrams, Gantt charts, color palettes. Extract and re-integrate them:
   - **Logos / SVG** → embed inline in the header; adopt the project's color palette as the report's accent colors (visual identity continuity).
   - **Charts / diagrams** → re-create them as **inline SVG/CSS** (see below) using the same data and colors. Do not screenshot.
2. **Propose new visuals** when a table or paragraph hides a comparison, composition, sequence, or flow that a graphic would make instant.

## Prefer inline SVG / CSS over JS chart libraries

Output must stay a **single self-contained file that prints cleanly to PDF**. JS chart libraries (Chart.js, D3) need a runtime and often render blank in print. Build visuals as **inline SVG** or **pure CSS** instead — portable, crisp at any zoom, and print-safe.

### SVG inline margins

Always leave a minimum **8px margin** between the `viewBox` edge and the first visual element (title or axis):
- First `<text>` title element: `y` ≥ `18`
- First graphical element (bar, axis): `y` ≥ `30`

Example:
```svg
<svg viewBox="0 0 480 140">
  <text x="8" y="18" font-size="11" font-weight="600">Chart title</text>
  <!-- content from y=30 -->
  <line x1="50" y1="30" x2="50" y2="120" />
</svg>
```

## A small, high-value vocabulary of visuals

| Need | Visual | Build with |
|---|---|---|
| Headline figures | **Stat cards** (big number + label) | CSS grid (`.stat-grid`) |
| Composition / shares (e.g. admixture) | **Stacked 100% bar** or donut | inline SVG / CSS + legend |
| Compare quantities (e.g. budget scenarios) | **Horizontal bar chart** | inline SVG |
| Process / architecture (≤ 4 steps, short text per box) | **Flow diagram** | CSS flex (`.flow`) |
| Process / architecture (≥ 5 steps, or multi-line text per box) | **SVG inline** | inline SVG `<rect>` + `<text>` + `<path>` |
| Schedule / phases | **Gantt / timeline** | CSS grid bars positioned by % |
| History / steps in time | **Timeline** | CSS flex with markers |
| A few qualitative components | **Labeled cards** (e.g. S_div) | CSS grid |
| One key takeaway | **Callout box** | `.callout` |

## Switching rule: `.flow` CSS vs inline SVG

Use **`.flow` CSS** only when all of these are true:
- The diagram has **at most 4 steps**
- Each box contains **a single line of text** (no `<br>`, no `<small>`)
- No inline elements (`<code>`, `<strong>`) inside boxes

Use **inline SVG** as soon as any of these is true:
- 5 or more steps
- Multi-line content in at least one box
- Non-linear layout (2 intentional rows, branching, loop)
- Precise A4 sizing required (e.g. integration in a numbered figure)

To build inline SVG: `viewBox="0 0 680 90"` for 6 boxes, scale down proportionally for fewer. Boxes as `<rect>`, text as `<text>` + `<tspan>`, arrows as `<polyline>`. Wrap in `<figure role="img">` with `<figcaption>`.

## Rules

- **Meaning first.** Each visual must answer a question the reader has. No chartjunk, no 3D, no gratuitous color.
- **Sober and on-brand.** Reuse the project palette; otherwise the report's accent + a small consistent set of hues. Keep it professional.
- **Accessible.** Sufficient contrast; never rely on color alone — always label values and series directly.
- **Print-safe.** Test that visuals survive `@media print` (no clipped SVG, no JS dependency, no forced page break through a chart).
- **Faithful.** Chart only real data from the sources. If you propose a visual for data that does not exist yet, mark it `[To complete: …]`.
- **Restraint.** Two to four strong visuals per document beat a dozen weak ones.

## Reusable components

`assets/report-linear.css` ships ready-made classes: `.stat-grid`/`.stat-card`, `.flow`/`.flow-step`, `.gantt`, `.hbar`, `.legend`, `.compo-bar`, `.timeline`. Use them so visuals stay consistent across reports.

### Stat cards — content limits

`.stat-card .num` uses `font-size: clamp(1.1em, 3.5vw, 1.7em)` and scales automatically. On a 4-card grid the maximum legible value is **12 characters** (e.g. `~1 474 000 €` = 12 chars ✓).

If values are consistently long or the grid has many cards, override in the document:

```css
.stat-grid--compact .stat-card .num { font-size: 1.25em; }
.stat-grid--compact .stat-card .label { font-size: 0.78em; }
```

Alternatively, replace stat-cards with a comparative `.hbar` when values represent amounts to compare — `.hbar` is more readable for that kind of data.

## Code blocks `<pre>`

`<pre>` blocks are reserved for commands, formulas, and reproducible technical snippets. They are not "visuals" in the chart sense, but obey the same print-safe constraints.

### Acceptable line width

Threshold: **72 characters per line** (standard bash/shell convention).
Beyond this, lines overflow on A4 at `font-size: 0.8em` (the value prescribed in `assets/report-linear.css`) and get clipped in print.

### Detection rule

Before inserting a `<pre>` block, measure the longest line:
- ≤ 72 chars → insert as-is
- > 72 chars → **reformat with shell continuation `\`**

### Reformatting convention — shell continuation

Break long shell commands with `\` + 2-space indent:

```bash
# Before
plink2 --pfile data --geno 0.05 --mind 0.05 --maf 0.01 --make-pgen --out out

# After
plink2 --pfile data \
  --geno 0.05 --mind 0.05 --maf 0.01 \
  --make-pgen --out out
```

For multi-term mathematical formulas, align operators:

```
score(i) =
    w1 × component1(i)
  + w2 × component2(i)
  + w3 × component3(i)
```

Break before a `--flag` argument or an operator (`+`, `|`). Never break in the middle of a path, filename, or value.

## Usage patterns et modifieurs adaptatifs

The skill's components are built to degrade gracefully even when stretched beyond their nominal limits. But knowing when and how to use **modifiers** and **adaptive patterns** ensures better results.

### `.flow` and `.flow--small`

**Default** (`.flow`): use for **≤ 4 steps** with short text (single line per box).
- `min-width: 80px`, `font-size: 0.86em`
- On A4 at normal zoom, 4 boxes fit comfortably on one line.

**Modifier** (`.flow--small`): use for **5–6 steps** or when boxes contain `<br>` or `<small>` elements.
- `min-width: 60px`, `font-size: 0.78em`
- Example: `<div class="flow flow--small">...</div>`
- Trades density for readability: all 6 boxes fit horizontally on A4.

**When in doubt**: if you have 5+ steps, use `.flow--small` or **replace with SVG inline** (see "Règle de bascule" above).

### `.stat-card` and adaptive font sizing

`.stat-card .num` now uses `font-size: clamp(1.1em, 3.5vw, 1.7em)`:
- On wide screens / 4-card grids: displays at 1.7em (crisp, large numbers)
- On narrow cards or long values: shrinks automatically down to 1.1em
- Example: `~1 403 000 €` (12 chars) will fit without truncation, scaling down only as needed

**No modifier required** — this is automatic. But if you have many long values (budgets, metrics), consider `.hbar` instead (horizontal bar chart), which is designed for comparative numerical data.

### `<pre>` blocks and overflow handling

Print-safe rules are now automatic:
- Lines ≤ 72 chars: display as-is
- Lines > 72 chars (rare if authors follow convention): wrapped in print using `overflow-wrap: break-word` + `word-break: break-all`
- Long tokens without spaces (URLs, paths, formulas) are broken at the page margin rather than clipped

**Best practice**: still reformats long lines with `\` continuation (72-char convention) — it improves screen readability and ensures clean breaks. But if a long line slips through, the CSS will handle it gracefully in print.

### Component selection flowchart

| You want to show... | Use... | Rationale |
|---|---|---|
| One or two key figures | `.stat-card` | Big, prominent, minimal text. Font scales automatically for long values. |
| Many metrics to compare | `.hbar` | Bars show relative magnitude; labels fit longer text. |
| Process / sequence (≤ 4 steps, short text) | `.flow` CSS | Minimal, clean arrows and boxes. |
| Process / sequence (5+ steps, or multi-line text) | `.flow--small` or SVG inline | `.flow--small` stays on one line; SVG gives full control over layout. |
| Composition / shares (e.g. admixture) | `.compo-bar` + `.legend` | 100% stacked; easy to read proportions. |
| Timeline / schedule | `.gantt` or `.timeline` | Gantt for durations & overlaps; Timeline for isolated events. |
| Code / formulas / commands | `<pre>` | Respects whitespace; print-safe word-breaking. Use 72-char continuation for readability. |

