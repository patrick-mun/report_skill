# Phase 6 Step 3 — Simplify JavaScript: paginate.js Migration

## Summary

Replaced the complex `paginate.js` (136 lines, for `.sheet` model) with a **minimal version** (127 lines, for linear flux model).

**What was removed:**
- Overflow detection (CSS `@page` + `break-inside: avoid` now handles it)
- `.sheet` element lookup (templates now use `<section>` + `<main>`)
- Pixel-height measurement (onePageHeightPx function)
- Complex sheet-to-page mapping

**What remains:**
- Simple section counter (estimate page count for footer)
- TOC linking with smooth scroll

---

## Files

### New/Changed

| File | Purpose | Lines | Status |
|------|---------|-------|--------|
| `assets/paginate.js` | **Simplified** pagination helper | 127 | ✅ Active (new) |
| `assets/paginate-linear.js` | Reference version (same as paginate.js) | 127 | 📚 Documentation |
| `assets/paginate-sheet.js` | **Legacy** for old .sheet model | 136 | 🗂️ Archive |

### Still in Use (Unchanged)

- `templates/*.html` — All 6 templates already include minimal JS inline
  - No external `<script src="paginate.js">` call needed
  - Each template has its own `numberPages()` and `bindTocLinks()` functions

---

## Code Changes: Old vs. New

### REMOVED from paginate.js

#### 1. Overflow Detection Function (was 26 lines)
```javascript
// OLD: Measured A4 height in pixels, flagged sheets that exceeded it
function onePageHeightPx() {
  var probe = document.createElement("div");
  probe.style.cssText = "position:absolute;left:-9999px;top:0;width:1px;height:297mm;";
  document.body.appendChild(probe);
  var h = probe.getBoundingClientRect().height;
  document.body.removeChild(probe);
  return h;
}
```

**Why removed?** CSS `@page` + `break-inside: avoid` now prevent unwanted breaks. No need for JavaScript detection.

#### 2. Sheet-Based Pagination (was ~50 lines)
```javascript
// OLD: Looked for .sheet elements, detected overflow, numbered pages
var sheets = Array.prototype.slice.call(document.querySelectorAll(".sheet"));
var contentSheets = sheets.filter(...);
sheets.forEach(function(sheet) {
  var flag = sheet.querySelector(".overflow-flag");
  // ... complex overflow detection ...
  var footer = sheet.querySelector(".sheet__footer");
  var no = footer.querySelector(".pageno");
  no.textContent = "Page " + (idx + 1) + " / " + contentSheets.length;
});
```

**Why removed?** Templates no longer use `.sheet`. New model uses `<section id="s*">`.

#### 3. TOC Lookups via .sheet Parent (was ~30 lines)
```javascript
// OLD: Found target ID, then walked up to find parent .sheet
var targetSheet = target.closest
  ? target.closest(".sheet")
  : (function() {
      var el = target;
      while (el && el !== document.body) {
        if (el.classList && el.classList.contains("sheet")) return el;
        el = el.parentNode;
      }
      return null;
    })();
var contentIdx = contentSheets.indexOf(targetSheet);
```

**Why removed?** Simpler now: just count TOC entry position, estimate page = position + 2 (cover + TOC).

---

## NEW: Minimal Implementation

### Function 1: `numberPages()` (10 lines)
```javascript
function numberPages() {
  // Count <section id="s*"> in <main>
  var contentSections = document.querySelectorAll('main > section[id^="s"]');

  // Rough estimate: ~1.5 sections per page
  var estimatedPages = Math.max(1, Math.ceil(contentSections.length / 1.5));

  // Update footer
  var pagenoEl = document.querySelector('.pageno');
  if (pagenoEl) {
    pagenoEl.textContent = 'Page — / ~' + estimatedPages;
  }

  // Update TOC: simple index-based estimate
  var tocEntries = document.querySelectorAll('a.toc-entry[href^="#"]');
  tocEntries.forEach(function(link, idx) {
    var numEl = link.querySelector('.toc-page-num');
    if (numEl) {
      numEl.textContent = String(idx + 2);
    }
  });
}
```

### Function 2: `bindTocLinks()` (unchanged, 12 lines)
```javascript
function bindTocLinks() {
  document.querySelectorAll('a.toc-entry[href^="#"]').forEach(function(link) {
    link.addEventListener('click', function(e) {
      var id = this.getAttribute('href').slice(1);
      var target = document.getElementById(id);
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  });
}
```

---

## Why This Works

### Old Model (.sheet)
- **Rigid boxes**: 210×297mm `<section class="sheet">` on screen
- **JS detects overflow**: Pixel-height measurement catches over-long content
- **Print works**: JavaScript identifies which sheet = which page

### New Model (linear flux)
- **Browser handles pagination**: CSS `@page { size: A4; }` + `break-before: page`
- **No detection needed**: Content naturally breaks at page boundaries
- **Estimation is okay**: We don't need exact page counts (print preview shows real count)

---

## Testing Checklist

- [x] `paginate.js` syntax: balanced braces, valid JavaScript
- [x] Functions present: `numberPages()`, `bindTocLinks()`
- [x] Event listeners: DOMContentLoaded, load, beforeprint
- [x] Templates already have inline JS (no external script needed)
- [x] CSS handles the hard parts (pagination, breaks, orphans/widows)

---

## Backward Compatibility

### Still have `.sheet`? Use paginate-sheet.js
```html
<!-- For old .sheet-based documents -->
<script src="assets/paginate-sheet.js"></script>
```

### Using new linear model? Use paginate.js (or inline JS)
```html
<!-- For new linear flux model (recommended) -->
<script src="assets/paginate.js"></script>
<!-- OR: inline the JS directly in <script>...</script> (templates do this) -->
```

---

## Migration Path for Old Documents

If you have documents using the old `.sheet` model:

1. **Option A: Keep using old version**
   - No changes needed
   - Use `assets/paginate-sheet.js` if external link is required
   - Works fine, but no longer maintained

2. **Option B: Migrate to linear flux**
   - Convert `.sheet` boxes to `<section id="s*">` in `<main>`
   - Replace inline CSS with `assets/report-linear.css`
   - Switch to `assets/paginate.js` (or inline JS)
   - See `PHASE_6_REFACTOR_PLAN.md` for detailed steps

---

## Files Changed This Step (Step 3)

```
assets/paginate.js          ← Replaced with simplified version
assets/paginate-linear.js   ← New reference version
assets/paginate-sheet.js    ← Backup of old version
STEP3-MIGRATION.md          ← This file (documentation)
```

No template files were modified in Step 3 (they already had minimal JS inline).

---

## Next Steps

**Step 4**: Rebuild the 6 examples to use new templates (with new CSS + JS)
**Step 5**: Test & validate (print preview, PDF export)

---

## Questions?

- Why estimate pages instead of counting accurately?
  → Browser doesn't expose page count before rendering. Estimation is fast and good enough for UX. Print preview (Ctrl+P) shows the real count.

- Can I delete paginate.js entirely?
  → Yes! CSS `@page` handles pagination. TOC scroll can be handled by native HTML `<a href="#id">`. You can delete this file if you're okay with:
    - No automatic page numbering in footer
    - Manual TOC page numbers (or leave blank "—")

- Does this work with external `<script src="...">` or must JS be inline?
  → Either works! Templates inline the JS for portability (no server needed). You can also link to `assets/paginate.js` if using a web server.

