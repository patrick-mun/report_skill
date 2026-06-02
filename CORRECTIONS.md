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

## Healthy Points (no action required)

- Skill architecture complies with Claude Code conventions (SKILL.md / references / assets / templates / examples).
- `paginate.js` and `report.css` perfectly coherent: all classes referenced by the JS exist in the CSS.
- The 3 examples are clean and self-contained (inlined CSS + JS, cover + TOC + footers).
- Complete references with no fundamental contradictions; MIT `LICENSE` present; consistent English throughout.
- The skill's core strength is demonstrated in multi-source consolidation: consistent styling, source attribution, proper A4 pagination, and support for any scientific/research document (not limited to genetics projects).
