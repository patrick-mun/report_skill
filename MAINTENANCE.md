# Maintenance Guide

## CSS Synchronization

**Source of truth:** `assets/report-linear.css` — the Linear Flux Model stylesheet (CSS @page, semantic HTML).

**✅ COMPLETED** (June 2026): All templates and examples use the same inlined CSS sourced from `assets/report-linear.css`. The old divergences between `.sheet`-era files are resolved.

### When to re-sync CSS

Re-sync whenever you:
- Fix a bug in `assets/report-linear.css`
- Update colors, fonts, or spacing
- Add new visual components (`.stat-grid`, `.flow`, etc.)

### How to re-sync (automated)

```bash
cd report_skill
bash build-inline-css.sh
git add templates/ examples/
git commit -m "Sync CSS from report-linear.css"
```

`build-inline-css.sh` reads `assets/report-linear.css`, inlines it into all templates and examples (excluding `assets/legacy/` files and the demo file), and repairs HTML structure if needed.

### Legacy files

The old `.sheet` model files are archived in `assets/legacy/` and are **no longer maintained**:

| File | Status |
|------|--------|
| `assets/legacy/report.css` | Archived — old `.sheet` model |
| `assets/legacy/paginate-sheet.js` | Archived — old `.sheet` model |
| `assets/legacy/paginate-linear.js` | Archived — duplicate of `paginate.js` |

Do not use these for new documents. See `references/pagination.md` for current guidance.

## Other resolved issues

- ✅ **CSS duplication** (June 2026): All files now source `report-linear.css` via `build-inline-css.sh`
- ✅ **HTML structure** (June 2026): All templates and examples have valid `<style>`, `</head>`, `<body>` ordering
- ✅ **Cover/TOC styling** (June 2026): `report-linear.css` now includes full `.cover*` and `.toc-page` classes
- ✅ **`.cover-divider` → `.cover-accent-band`**: Renamed in CSS; all templates updated
- ✅ **`.glossary`**: Removed (never used)
- ✅ **`--mode` flag**: Documented in `SKILL.md` with mutual exclusion rules
