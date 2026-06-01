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

## Healthy Points (no action required)

- Skill architecture complies with Claude Code conventions (SKILL.md / references / assets / templates / examples).
- `paginate.js` and `report.css` perfectly coherent: all classes referenced by the JS exist in the CSS.
- The 3 examples are clean and self-contained (inlined CSS + JS, cover + TOC + footers).
- Complete references with no fundamental contradictions; MIT `LICENSE` present; consistent English throughout.
