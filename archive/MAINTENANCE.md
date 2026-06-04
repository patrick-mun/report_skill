# Maintenance Guide

## Asset Synchronization

`build-inline-css.sh` makes every template/example a single self-contained file.
It inlines **three** canonical sources (single source of truth each):

| Source | Role |
|--------|------|
| `assets/report-linear.css` | Linear Flux Model stylesheet (CSS @page, `@page` footer margin-boxes, visuals) |
| `assets/paginate.js` | Sets `window.PagedConfig` (auto-paginate) + fills accurate TOC page numbers |
| `assets/vendor/paged.polyfill.min.js` | Paged.js engine — per-page footers + page numbers in print |

**✅ COMPLETED** (June 2026): All templates/examples are synced and paginate with
Paged.js (per-page footer + `Page n / total`, cover/TOC excluded).

### When to re-sync

Re-sync whenever you:
- Fix a bug or change colors/fonts/spacing in `assets/report-linear.css`
- Change the config/TOC behavior in `assets/paginate.js`
- Update the vendored Paged.js engine (see below)

### How to re-sync (automated)

```bash
cd report_skill
bash build-inline-css.sh
git add templates/ examples/
git commit -m "Re-sync templates/examples (CSS + Paged.js)"
```

The script inlines the CSS + config + polyfill, normalizes the footer (removes any
legacy `pageno` span and the old end-of-body script), and repairs HTML structure.
It excludes `assets/legacy/` files and the demo file. A finished report is ~528 KB
(~105 KB gzipped) — the inlined Paged.js engine is the bulk, the cost of a true
single-file with reliable print pagination.

### Updating Paged.js

The engine is vendored at `assets/vendor/paged.polyfill.min.js` (Paged.js v0.4.3).
To update: take `dist/paged.polyfill.min.js` from the npm `pagedjs` package, replace
the vendored file, run `bash build-inline-css.sh`, and re-verify a PDF (footers +
page numbers on content pages, cover/TOC excluded).

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
