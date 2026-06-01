# Maintenance Guide

## CSS Synchronization (Point #3: High Severity)

**Problem:** The CSS is duplicated across every example/template (inline in `<style>` tags) and has already diverged (padding, font sizes, colors differ).

**Source of Truth:** `assets/report.css` is the canonical CSS source.

### When to Re-sync CSS

Re-sync whenever you:
- Fix a bug in `assets/report.css`
- Update colors, fonts, or spacing
- Add new visual components (`.stat-grid`, `.flow`, etc.)

### How to Re-sync

#### Manual (small changes)
1. Edit `assets/report.css` as needed.
2. For each file that needs updating:
   - Open `assets/report.css`, select all CSS (excluding `@import` if any)
   - Minify: remove newlines, collapse spaces, keep semantic formatting
   - Copy the minified CSS
   - In the target `.html` file, replace the entire contents of the `<style>` tag (keeping the outer `<style>` tags and closing `</style>`)

#### Automated (coming soon)
The `build-inline-css.sh` script (in progress) will automate this. For now, manual is reliable.

### Known Divergences (Before Sync)

| File | Sheet Padding | Body Font |
|------|---|---|
| `report.css` | `16mm 18mm 12mm` | `15px` |
| `example-professional.html` | `16mm 18mm 12mm` ✓ | `15px` ✓ |
| `example-genome-meeting-scientific.html` | `15mm 17mm 11mm` | `14.5px` |
| `example-genome-meeting-funder.html` | `15mm 17mm 11mm` | `15px` |
| `templates/professional.html` | `16mm 18mm 12mm` ✓ | `15px` ✓ |
| `templates/research.html` | `16mm 18mm 12mm` ✓ | `15px` ✓ |
| `templates/scientific-dossier.html` | `16mm 18mm 12mm` ✓ | `15px` ✓ |

**After this fix:** All examples and templates will use `16mm 18mm 12mm` and `15px` (matching `report.css`).

## Other High-Severity Issues

- ✅ **#4 (.cover-divider)**: Renamed to `.cover-accent-band` in `report.css`; no longer orphaned.
- ✅ **#5 (.glossary)**: Removed from `report.css` (never used).
- ✅ **#6 (--mode)**: Documented `--mode layered|audience` in `SKILL.md` with clear mutual exclusion rules.
