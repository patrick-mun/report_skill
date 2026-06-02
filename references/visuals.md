# Visuals — make the report readable, not monotone

A wall of text — even well structured — slows reading. The whole point of HTML/CSS over Markdown or a flat PDF is **layout and visuals**. Every report should use visual structure to guide the eye and surface key facts. Apply this guide, but **do not overdo it**: visuals must carry meaning, never decorate.

## Two sources of visuals

1. **Reuse what already exists.** Project material usually already contains graphics — logos, charts (Chart.js, etc.), diagrams, Gantt charts, color palettes. Extract and re-integrate them:
   - **Logos / SVG** → embed inline in the header; adopt the project's color palette as the report's accent colors (visual identity continuity).
   - **Charts / diagrams** → re-create them as **inline SVG/CSS** (see below) using the same data and colors. Do not screenshot.
2. **Propose new visuals** when a table or paragraph hides a comparison, composition, sequence, or flow that a graphic would make instant.

## Prefer inline SVG / CSS over JS chart libraries

Output must stay a **single self-contained file that prints cleanly to PDF**. JS chart libraries (Chart.js, D3) need a runtime and often render blank in print. Build visuals as **inline SVG** or **pure CSS** instead — portable, crisp at any zoom, and print-safe.

### Marges internes des SVG inline

Toujours laisser une marge de **8px minimum** entre le bord du `viewBox` et le premier élément visuel (titre ou axe). En pratique :
- Premier `<text>` de titre : `y` ≥ `18`
- Premier élément graphique (barre, axe) : `y` ≥ `30`

Exemple :
```svg
<svg viewBox="0 0 480 140">
  <text x="8" y="18" font-size="11" font-weight="600">Titre du graphique</text>
  <!-- graphique à partir de y=30 -->
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

## Règle de bascule : `.flow` CSS vs SVG inline

Utiliser **`.flow` CSS** si et seulement si toutes ces conditions sont vraies :
- Le diagramme a **4 étapes au maximum**
- Chaque boîte contient **une seule ligne de texte** (pas de `<br>`, pas de `<small>`)
- Aucun élément inline (`<code>`, `<strong>`) dans les boîtes

Utiliser **SVG inline** dès qu'une de ces conditions est vraie :
- 5 étapes ou plus
- Contenu multi-lignes dans au moins une boîte
- Disposition non-linéaire (2 rangées intentionnelles, bifurcation, boucle)
- Nécessité de dimensionner précisément pour A4 (ex. intégration dans une figure numérotée)

Pour construire le SVG inline : `viewBox="0 0 680 90"` pour 6 boîtes, réduire proportionnellement pour moins. Boîtes en `<rect>`, texte en `<text>` + `<tspan>`, flèches en `<polyline>`. Envelopper dans `<figure role="img">` avec `<figcaption>`.

## Rules

- **Meaning first.** Each visual must answer a question the reader has. No chartjunk, no 3D, no gratuitous color.
- **Sober and on-brand.** Reuse the project palette; otherwise the report's accent + a small consistent set of hues. Keep it professional.
- **Accessible.** Sufficient contrast; never rely on color alone — always label values and series directly.
- **Print-safe.** Test that visuals survive `@media print` (no clipped SVG, no JS dependency, no forced page break through a chart).
- **Faithful.** Chart only real data from the sources. If you propose a visual for data that does not exist yet, mark it `[To complete: …]`.
- **Restraint.** Two to four strong visuals per document beat a dozen weak ones.

## Reusable components

`assets/report.css` ships ready-made classes: `.stat-grid`/`.stat-card`, `.flow`/`.flow-step`, `.gantt`, `.hbar`, `.legend`, `.compo-bar`, `.timeline`. Use them so visuals stay consistent across reports.

### Stat cards — limites de contenu

`.stat-card .num` est rendu à `font-size: 1.7em`. À cette taille, la valeur affichable sans débordement sur une grille de 4 cartes est de **12 caractères maximum** (ex. `~1 474 000 €` = 12 chars ✓).

Si la grille contient des valeurs plus longues ou si les cartes sont nombreuses, utiliser la classe modificatrice `.stat-grid--compact` et définir dans les overrides document :

```css
.stat-grid--compact .stat-card .num { font-size: 1.25em; }
.stat-grid--compact .stat-card .label { font-size: 0.78em; }
```

Alternativement, remplacer les stat-cards par une `.hbar` comparative lorsque les valeurs représentent des montants à comparer — la `.hbar` est plus lisible pour ce type de donnée.

## Blocs de code `<pre>`

Les blocs `<pre>` sont réservés aux commandes, formules et extraits techniques reproductibles. Ils ne constituent pas un « visuel » au sens des graphiques, mais ils obéissent aux mêmes contraintes print-safe.

### Seuil de largeur acceptable

Seuil : **72 caractères par ligne** (convention bash/shell standard).
Au-delà, la ligne déborde sur A4 à `font-size: 0.8em` (la valeur prescrite dans `assets/report.css`) et est coupée à l'impression.

### Règle de détection

Avant d'insérer un bloc `<pre>`, mesurer la ligne la plus longue :
- ≤ 72 chars → insérer tel quel
- > 72 chars → **reformater avec continuation shell `\`**

### Convention de reformatage — continuation shell

Couper les longues commandes shell avec `\` + indentation de 2 espaces :

```bash
# Avant
plink2 --pfile data --geno 0.05 --mind 0.05 --maf 0.01 --make-pgen --out out

# Après
plink2 --pfile data \
  --geno 0.05 --mind 0.05 --maf 0.01 \
  --make-pgen --out out
```

Pour les formules mathématiques sur plusieurs termes, aligner les opérateurs :

```
score(i) =
    w1 × composante1(i)
  + w2 × composante2(i)
  + w3 × composante3(i)
```

Règles de coupure : couper avant un argument `--flag` ou un opérateur (`+`, `|`). Ne jamais couper au milieu d'un chemin, d'un nom de fichier ou d'une valeur.

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

