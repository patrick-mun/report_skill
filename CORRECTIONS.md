# Corrections to Apply — Audit of the `report-formatter` Skill

Audit conducted on 2026-06-01. List of discrepancies found between the examples (which
are the authority) and the rest of the skill, classified by severity.

## Corrections Table

| # | Severity | Area | Issue Found | Proposed Correction | Status |
|---|----------|------|-------------|-------------------|--------|
| 1 | 🔴 Critical | `templates/professional.html`, `research.html`, `scientific-dossier.html` | The 3 templates still use the old `class="page"` continuous flow model: no `.sheet`, no cover page, no table of contents, no footer. Not printable to A4. | Rebuild the 3 templates on the `.sheet` model (cover + `.sheet--toc` + `.sheet__footer`), with `report.css` and `paginate.js` inlined, following the examples. | ✅ PR #6 |
| 2 | 🔴 Critical | `templates/scientific-dossier.html` | Sidebar table of contents `toc-side` that contradicts the `.sheet--toc` model documented in `references/pagination.md`. | Remove `toc-side` and adopt the clickable, auto-numbered `.sheet--toc` sheet. | ✅ PR #6 |
| 3 | 🟠 High | `assets/report.css` + `examples/*.html` | CSS copied entirely into each example (~1600 lines ×3) and already diverging: padding `16mm` vs `15mm`, body `15px` vs `14.5px`, different accent colors. Fixing a bug = 3 manual edits. | Designate `assets/report.css` as the single source of truth and either (a) document the re-inlining procedure, or (b) add a small build script that inlines the CSS into the examples. | ✅ PR #7 |
| 4 | 🟠 High | `assets/report.css` | Orphaned class `.cover-divider` defined but never used; the examples use `.cover-accent-band`. Vestige of an incomplete rename, misleading. | Rename/align to `.cover-accent-band` and remove the dead definition. | ✅ PR #7 |
| 5 | 🟠 High | `assets/report.css` | Orphaned class `.glossary` defined but never instantiated in a template or example. | Either instantiate it in a template, or remove it from the CSS. | ✅ PR #7 |
| 6 | 🟡 Medium | `SKILL.md` | `--mode layered` mentioned (line ~47) but not formalized alongside the `--audience` values. Ambiguity between `--mode` and `--audience`. | Explicitly document `--mode layered|audience` and its interaction with `--audience`. | ✅ PR #7 |
| 7 | 🟡 Medium | `references/pagination.md` | The guide gives a sheet padding of `16mm 18mm 12mm`, but the genome examples use `15mm 17mm 11mm`. Undocumented variant. | Harmonize the padding value between the guide and the examples (single reference). | ✅ PR #7 |
| 8 | 🟢 Low | global | No templates/examples in English (acceptable: the skill is French-speaking by default). | Optional: provide an English version if reuse outside FR is needed. | ✅ PR #9 |

## Additional Issues Found in Real-World Use (Multi-Source Scientific Report, 2026-06-02)

When the skill was tested consolidating a large multi-source scientific project (methodology spec + budget dossier + scientific summary, tested with Génome Réunion as example), the following issues emerged:

| # | Severity | Area | Issue Found | Action Taken |
|---|----------|------|-------------|--------------|
| 9 | 🟠 High | `references/style-guide.md` | No guidance on **figure/table numbering consistency** — multi-source consolidation can produce gaps (Figure 1, 2, 3, 5 — missing 4), making cross-references fragile. Applies to any large report (research, methodology, review, etc.). | ✅ Added sections 12–13 to `style-guide.md`: rules for continuous numbering, detecting gaps, renumbering after edits, and verifying all cross-references. |
| 10 | 🟠 High | Pre-delivery QA | No formal checklist; difficult to catch typography errors (accents, en-dashes), orphaned section headers, or numbering gaps before PDF export — applies universally to scientific reports. | ✅ Created `references/qc-checklist.md`: 8-phase checklist (content, numbering, typography, layout, metadata, sources, print, audience). Includes bash automation tips. |
| 11 | 🟠 High | `references/pagination.md` | Overflow detection mentioned but not emphasized as *critical* — the guide says "watch the overflow flag" but doesn't stress that an overflowing page will print broken. This is universal regardless of report topic. | ✅ Enhanced `pagination.md` with detailed "why overflow detection is critical" section and explicit print checklist with overflow testing as step 2. |
| 12 | 🟡 Medium | Multi-language support | Typography issues when consolidating documents in French or other accented languages: `Équipe` → `Equipe`, `Maîtrise` → `Maîtré`, etc. (applies to any language with diacritics). | ✅ Added regex patterns and automation checks in `qc-checklist.md` to detect common accentation/typography errors before PDF export. |
| 13 | 🟡 Medium | SKILL.md | No mention of QA as a mandatory final step before delivery — applies to all report types. | ✅ Added "Quality Assurance — before delivery" section linking to the new QA checklist. |
| 14 | 🟢 Low | Consolidation workflow | Orphaned or incomplete section headers (e.g., "D.1–5 Bibliography" when sections D.1–18 exist) can remain unnoticed in multi-source consolidation. | ✅ QA checklist now includes explicit check: "Count promised sections and verify all present in document." |

## Visual Quality Audit — CSS Corrections Phase 1 (2 June 2026)

### Context
A real-world output document (`genome_reunion_synthese_scientifique.html`) was audited against the skill's CSS source (`assets/report.css`). 15 visual/structural issues were identified, spanning critical rendering bugs (affecting A4 print), accessibility gaps, and maintenance debt.

**Goal**: Improve the **output of ALL future documents** generated by the skill, not the examples.

### Corrections Applied — Phase 1 (Critical CSS bugs)

| # | Severity | Status | Fix | File(s) | Impact |
|---|---|---|---|---|---|
| **V1** | 🔴 Critical | ✅ Pre-existing | Arrow character `\203A` in `.flow-step::after` | `assets/report.css:170` | ✓ No change needed |
| **V2** | 🔴 Critical | ✅ **FIXED** | `.flow-step` min-width `120px` → `80px` | `assets/report.css:157` | Flow diagram (6 steps) now fits on 1 A4 line |
| **V3** | 🔴 Critical | ✅ **FIXED** | Add `.hbar .fill.g` + `.hbar .fill.o` color classes | `assets/report.css:166-167` | Budget bars now display in correct colors (green/orange) instead of all blue |
| **V4** | 🔴 Critical | ✅ **FIXED** | Add `.refs-list` and `.refs-list li` CSS rules | `assets/report.css:142-147` | Bibliography lists now properly styled (0.82em, muted color) |
| **V5** | 🟠 High | ✅ **FIXED** | Add `<pre>` and `<code>` CSS rules with `overflow-x: auto` | `assets/report.css:52-70` | Code blocks no longer overflow horizontally on A4 |
| **V6** | 🟠 High | ✅ **FIXED** | Add `overflow: hidden; word-break: break-word; hyphens: auto` to `.flow-step` | `assets/report.css:157` | Text in flow boxes no longer overflows visually |
| **V7** | 🟠 High | ✅ **FIXED** | `.hbar .row` grid `180px` → `225px` + font-size `0.88em` → `0.82em` | `assets/report.css:163` | Budget bar labels now fit up to 35 chars without truncation |
| **V8** | 🟠 High | ✅ **FIXED** | `.gantt .row` and `.gantt .scale` grid `170px` → `195px` | `assets/report.css:170, 176` | Gantt labels no longer wrap to second line |
| **V9** | 🟠 High | ✅ **FIXED** | Add `word-break: break-word; overflow-wrap: break-word` to `th, td` | `assets/report.css:88` | Wide tables (5–7 columns) now fit on A4 without overflow |

### CSS Variables Added to :root

To support generic color variants (not dependent on project overrides):

```css
--accent2: #2e5c94;         /* darker blue for variants */
--accent3: #e85d38;         /* warm orange for bars */
--green: #10b981;           /* emerald green for status indicators */
--purple: #8b5cf6;          /* violet for categories */
```

These can be overridden by projects (e.g., Génome Réunion palette).

### Files Requiring Synchronization

After CSS source fixes, the following files **must be re-synchronized** using `build-inline-css.sh`:

**Examples** (6 files):
- `examples/exemple-pro.html`
- `examples/exemple-genome-reunion-scientifique.html`
- `examples/exemple-genome-reunion-financier.html`
- `examples/example-professional.html`
- `examples/example-genome-meeting-scientific.html`
- `examples/example-genome-meeting-funder.html`

**Templates** (6 files):
- `templates/professionnel.html`
- `templates/recherche.html`
- `templates/dossier-scientifique.html`
- `templates/professional.html`
- `templates/research.html`
- `templates/scientific-dossier.html`

**Command to sync**:
```bash
bash build-inline-css.sh
```

### Planned Corrections — Phase 2 (Non-critical, HTML examples only)

| # | Severity | Type | Correction | Impact |
|---|---|---|---|---|
| **V10** | 🟡 Low | HTML | Remove duplicate `width`/`height` attributes from logo `<svg>` | No CSS conflict with rule `.cover-logo svg { height: 58px; width: auto }` |
| **V11** | 🟡 Low | HTML | Add `role="img"` and `aria-label` to 4 SVG elements | Accessibility: screen readers will announce figure titles |
| **V12** | 🟡 Low | HTML | Replace `.pillar-grid` inline styles with CSS class | Maintainability: easier to update colors across the skill |
| **V13** | 🟡 Low | HTML | Replace 20 hardcoded hex colors with CSS variables (partial) | Palette consistency — SVG colors remain hardcoded (unavoidable) |
| **V14** | 🟡 Low | HTML | Wrap all `<pre>` content with `<code>` tags semantically | Compliance: proper semantic HTML5 for preformatted code |
| **V15** | 🟢 Minimal | Note | Inconsistent class naming (`.lbl` in stat-cards vs `.label` in callouts) | Document for future unification — no functional issue |

---

## Phase 2 — HTML & CSS Utility Classes (2 June 2026)

### Context
Audit of the skill's templates/examples for Phase 2 corrections. Goal: add CSS utility classes to support future document generation without inline styles.

### Status: Step 1 of 2 (Skill Improvements) ✅

#### Audit Findings
- ✅ **V10**: No duplicate width/height on SVG logos
- ✅ **V11**: All existing SVG examples have `role="img"` + `aria-label` 
- ✅ **V12**: No grids with inline display:grid found in templates
- ⚠️ **V13**: 16–44 hardcoded hex colors per file (inline styles) — refactoring deferred
- ✅ **V14**: No `<pre>` blocks in skill examples (only in complex generated documents)

#### Changes Applied — Phase 2a (Skill Infrastructure)

**New CSS Utility Classes Added** to `assets/report.css`:

```css
/* Pillar/conclusion grid — supports V12 correction */
.pillar-grid { 
  display: grid; 
  grid-template-columns: repeat(3, 1fr); 
  gap: 9px; 
  margin-top: 0.4em; 
  font-size: 0.86em; 
}
.pillar-grid .item { 
  background: #fff; 
  border: 1px solid #a7f3d0; 
  border-radius: 4px; 
  padding: 7px 9px; 
}

/* Color classes for composition bars — supports V13 correction */
.compo-afr { background: var(--green); }       /* African/Malagasy */
.compo-ind { background: var(--accent3); }     /* South Asian */
.compo-eur { background: var(--accent); }      /* European */
.compo-zar { background: #D97706; }            /* Zarabe/Gujarati */
.compo-chin { background: var(--purple); }    /* Chinese/Asian */

/* Legend swatch colors */
.legend-afr { background: var(--green); }
.legend-ind { background: var(--accent3); }
.legend-eur { background: var(--accent); }
.legend-zar { background: #D97706; }
.legend-chin { background: var(--purple); }
```

**Files Synchronized**: 6 examples + 6 templates via `build-inline-css.sh` ✅

#### Next Step: Phase 2b (Document Example Testing)
Apply V10-V14 corrections to the real-world example document (`genome_reunion_synthese_scientifique_2.html`) to demonstrate practical implementation and verify CSS classes work as expected.

---

## Healthy Points (no action required)

- Skill architecture complies with Claude Code conventions (SKILL.md / references / assets / templates / examples).
- `paginate.js` and `report.css` perfectly coherent: all classes referenced by the JS exist in the CSS.
- The 3 examples are clean and self-contained (inlined CSS + JS, cover + TOC + footers).
- Complete references with no fundamental contradictions; MIT `LICENSE` present; consistent English throughout.
- The skill's core strength is demonstrated in multi-source consolidation: consistent styling, source attribution, proper A4 pagination, and support for any scientific/research document (not limited to genetics projects).
