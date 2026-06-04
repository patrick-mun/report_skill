# Phase 6 Refactoring Plan — Migrate from `.sheet` Model to Linear Flux + `@page`

**Scope**: Complete architectural redesign of the skill's pagination system.  
**Estimated effort**: 2–3 weeks (full-time equivalent).  
**Status**: Planning stage. Execute only if Phase 5 + 5b are insufficient.

---

## Executive Summary: The Problem We're Solving

**Current model (`.sheet`)**:
- Authors write explicit `<section class="sheet">` blocks (210×297mm boxes)
- Each block must fit on one A4 page manually
- If content overflows, author must split the block
- CSS + JS (paginate.js) simulates pagination on top of the browser's real pagination
- Result: fragile, complex, hard to edit

**New model (linear flux + `@page`)**:
- Authors write normal HTML flow (div, section, article, no page blocks)
- CSS `@page { size: A4; margin: 20mm }` tells browser the page format
- CSS `break-before: page`, `break-after: page`, `break-inside: avoid` control where pages break
- Browser handles real pagination (no JS needed)
- Result: simple, maintainable, editable like Word

**Trade-off**:
| Aspect | `.sheet` (current) | Linear + `@page` (new) |
|---|---|---|
| WYSIWYG on-screen | Good (you see pages) | Fair (you scroll, but print preview is accurate) |
| Editability | Manual (rigid) | Easy (natural flow like Word) |
| CSS complexity | High (350 lines) | Low (~50 lines) |
| JavaScript | 120 lines (fragile) | 0 (or minimal for TOC linking) |
| Maintenance | Hard (hacks everywhere) | Easy (standard CSS) |
| Pagination reliability | Unreliable (min-height trap) | Reliable (browser-native) |
| Automatic adjustment | No (manual splits) | Yes (add content = more pages) |

---

## Step-by-Step Refactoring Plan

### **Step 1: Design the New CSS Foundation** (~1 day)
**Goal**: Create the new `assets/report-linear.css` with no `.sheet` or pagination boxes.

#### 1a. Define the page model
```css
@page {
  size: A4;
  margin: 20mm;
}

@media print {
  body { font-size: 11pt; }
  /* page breaks */
  h1, h2 { break-after: avoid; }
  table, figure, .callout { break-inside: avoid; }
  p { orphans: 3; widows: 3; }
}

@media screen {
  /* reading mode: fluid width, good line length */
  body { max-width: 800px; margin: 0 auto; }
}
```

#### 1b. Strip out `.sheet`-specific CSS
- Remove: `.sheet`, `.sheet__body`, `.sheet__footer`, `.sheet--cover`, `.sheet--toc`, `min-height: 297mm`, all the `.sheet` positioning rules
- Keep: typography, colors, component styles (stat-card, callout, hbar, gantt, etc.)
- Simplify: remove `page-break-after: always; margin: 0 auto 12mm;` (browser handles this)

#### 1c. Refactor footer styling
**Old**:
```html
<section class="sheet">
  <div class="sheet__body">content</div>
  <footer class="sheet__footer">
    <span>Title</span>
    <span class="pageno">Page 1 / 16</span>
  </footer>
</section>
```

**New** (option A: `@page` margin boxes):
```css
@page {
  size: A4;
  margin: 20mm;
  @bottom-left { content: "Document Title"; }
  @bottom-right { content: "Page " counter(page) " / " counter(pages); }
}
```
⚠️ **Problem**: Most browsers don't support `@page` margin boxes when printing to PDF via `Ctrl+P` (works in dedicated print tools like Prince XML). 

**New** (option B: sticky footer in flow):
```html
<main>
  <h1>Title</h1>
  <p>Content...</p>
  <footer>
    <span>Document Title</span>
    <span id="page-counter" class="pageno">Page X / Y</span>
  </footer>
</main>
```
With JS (minimal, just for page counting):
```js
// Simplified paginate.js: just number the pages
// (browser handles the actual breaks)
```

**Recommendation**: Use option B (sticky footer) for reliability. Much simpler JS.

#### 1d. Create a new `report-linear.css`
- ~200 lines (vs. current 456)
- No `.sheet` classes
- `@page` rule + `@media print` break rules
- All component styles (stat-card, callout, hbar, etc.) unchanged
- New utility: `.no-break` for sections that must stay together

**Deliverable**: `assets/report-linear.css` (new file)

---

### **Step 2: Build New HTML Templates** (~3 days)
**Goal**: Rewrite the 6 templates using linear flow instead of `.sheet` blocks.

#### 2a. Cover page
**Old**:
```html
<section class="sheet sheet--cover">
  <div class="sheet__body">
    <div class="cover-logo">...</div>
    <div class="cover-center">
      <h1>Title</h1>
    </div>
    <div class="cover-meta">...</div>
  </div>
</section>
```

**New**:
```html
<section class="cover">
  <div class="cover-logo">...</div>
  <div class="cover-center">
    <h1>Title</h1>
  </div>
  <div class="cover-meta">...</div>
</section>
<footer class="page-footer">...</footer>
```
(The cover will naturally fit on one page; `break-after: page` after the footer ensures the next section starts fresh.)

#### 2b. Table of contents
**Old**:
```html
<section class="sheet sheet--toc">
  <div class="sheet__body">
    <h2>Table des matières</h2>
    <nav class="toc-doc">...</nav>
  </div>
</section>
```

**New**:
```html
<nav class="toc-page">
  <h2>Table des matières</h2>
  <ol>
    <li><a href="#s1">1. Title <span class="toc-page-num"></span></a></li>
    ...
  </ol>
</nav>
<footer class="page-footer">...</footer>
```

#### 2c. Content sections
**Old**:
```html
<section class="sheet">
  <div class="sheet__body">
    <section id="s1"><h2>Section 1</h2>...</section>
    <section id="s2"><h2>Section 2</h2>...</section>
  </div>
  <footer class="sheet__footer">...</footer>
</section>
```

**New**:
```html
<section id="s1">
  <h2>Section 1</h2>
  <!-- content automatically breaks to next page if too long -->
</section>

<section id="s2">
  <h2>Section 2</h2>
</section>

<footer class="page-footer">...</footer>
```

CSS handles the breaks:
```css
h2 { break-before: page; }  /* Each section starts fresh */
```

#### 2d. Templates to rebuild (6 files)
1. `templates/dossier-scientifique.html` (French, scientific)
2. `templates/scientific-dossier.html` (English, scientific)
3. `templates/recherche.html` (French, research)
4. `templates/research.html` (English, research)
5. `templates/professionnel.html` (French, professional)
6. `templates/professional.html` (English, professional)

**For each**:
- Remove all `.sheet`, `.sheet__body`, `.sheet__footer` classes
- Use semantic HTML: `<section>`, `<article>`, `<header>`, `<footer>`
- Add `break-before: page` to top-level section headers (`h2`)
- Add `break-inside: avoid` to tables, figures, callouts
- Keep the content structure (cover + TOC + sections + appendices) unchanged
- Inline the new `report-linear.css` (no change to build process)

**Deliverable**: 6 updated templates

---

### **Step 3: Simplify/Remove paginate.js** (~1 day)
**Goal**: Replace the complex overflow detection with minimal JS (or none).

#### Option A: No JavaScript (purest)
- Delete `paginate.js` entirely
- Use CSS `break-inside: avoid` to keep tables/figures whole
- Browser handles pagination automatically
- **Trade-off**: No visual overflow warning on-screen. But print preview is accurate.

#### Option B: Minimal JavaScript (recommended)
Keep a **simplified paginate.js** (20 lines) that:
1. Numbers the pages in the footer (just DOM injection, no overflow detection)
2. Links TOC entries to page numbers (optional, if TOC is included)

```js
/* Simplified paginate.js — only page numbering, no overflow detection */
(function() {
  var pageNum = 1;
  document.querySelectorAll('section[id^="s"]').forEach(function(section) {
    if (!section.classList.contains('cover', 'toc-page')) {
      var footer = section.querySelector('footer .pageno');
      if (footer) footer.textContent = 'Page ' + pageNum + ' / ???';
      pageNum++;
    }
  });
})();
```

Or even simpler: **no JS at all**. Use CSS counters:
```css
@page {
  @bottom-right {
    content: 'Page ' counter(page) ' / ' counter(pages);
  }
}
```
(Works in dedicated print tools, may not work in browser print dialog.)

**Recommendation**: Option B (minimal JS) for safety. Or Option A if you're okay with manual page numbering in the footer.

**Deliverable**: Either delete `paginate.js` or replace with 20-line version. Delete `assets/paginate.js`.

---

### **Step 4: Update Examples** (~2 days)
**Goal**: Rebuild the 6 examples to match the new template structure.

- `examples/exemple-pro.html`
- `examples/exemple-genome-reunion-scientifique.html`
- `examples/exemple-genome-reunion-financier.html`
- `examples/example-professional.html`
- `examples/example-genome-meeting-scientific.html`
- `examples/example-genome-meeting-funder.html`

**For each**:
- Rewrite using the new linear structure (no `.sheet` blocks)
- Inline `report-linear.css`
- Remove or replace paginate.js call
- Test: print to PDF and verify layout

**Deliverable**: 6 updated examples

---

### **Step 5: Update Documentation** (~1 day)
**Files to update**:

| File | Change |
|---|---|
| `references/pagination.md` | Complete rewrite. Old: explicit sheet management. New: CSS `@page`, `break-*` rules, when to use `break-inside: avoid`. |
| `SKILL.md` | Remove sheet-specific instructions. Add: "Use semantic HTML, CSS handles breaks." |
| `references/style-guide.md` | Update to reflect linear model (no "fit content on sheet" advice). Add: "Design for flow, not pages." |
| `MAINTENANCE.md` | Document the new architecture. Explain why we switched. |
| `README.md` | Briefly mention: linear flow + CSS `@page`, no JS, standard web approach. |

**Deliverable**: Updated reference docs

---

### **Step 6: Test & Validate** (~2–3 days)
**Testing checklist**:

- [ ] **Screen display**: Open each template/example in Chrome, Firefox, Safari. Verify readable layout (800px max-width, good line length).
- [ ] **Print preview** (`Ctrl+P`): Check that page breaks fall where expected (after section headers, not mid-table).
- [ ] **PDF export**: Use browser's "Save as PDF". Verify:
  - All pages present (count matches expected)
  - No orphaned headers (single line at bottom of page)
  - No split tables or figures
  - Footers present and numbered correctly
  - Colors print correctly (Phase 5 should be done by then)
- [ ] **Real-world test**: Regenerate `genome_reunion_synthese_scientifique.html` using the new templates. Should produce ~18 pages (vs. 37 before). Verify content, formatting, color.
- [ ] **Browser compatibility**: Test in Chrome, Firefox, Safari (print output may differ slightly but should be acceptable).

**Deliverable**: Test report documenting pass/fail for each item.

---

### **Step 7: Build & Sync Automation** (~1 day)
**Goal**: Ensure the new CSS is kept in sync across all templates and examples (like the current `build-inline-css.sh`).

**Option A: Keep `build-inline-css.sh`** (no change)
- Rename CSS source: `assets/report.css` → `assets/report-linear.css`
- Update script to reference the new file
- Run: `bash build-inline-css.sh` to sync all 12 files

**Option B: No inline CSS** (future-proof)
- Link to `assets/report-linear.css` externally in all templates
- Removes the need for sync script
- But requires web server (doesn't work as local `.html` file)

**Recommendation**: Keep Option A for now (backward compatible with local-file usage).

**Deliverable**: Updated `build-inline-css.sh` (if needed)

---

## Migration Checklist

```
Phase 6: Linear Flux Migration
├─ Step 1: Design new CSS (~1 day)
│  ├─ Create report-linear.css
│  ├─ Define @page rule
│  ├─ Define break rules
│  └─ Remove .sheet classes
├─ Step 2: Rebuild templates (~3 days)
│  ├─ 6 templates rewritten
│  ├─ No .sheet, no pagination boxes
│  └─ Semantic HTML
├─ Step 3: Simplify paginate.js (~1 day)
│  ├─ Option A: delete
│  └─ Option B: 20-line minimal version
├─ Step 4: Rebuild examples (~2 days)
│  ├─ 6 examples rewritten
│  └─ All inline report-linear.css
├─ Step 5: Update docs (~1 day)
│  ├─ pagination.md rewrite
│  ├─ SKILL.md, MAINTENANCE.md
│  └─ style-guide.md
├─ Step 6: Test & validate (~2-3 days)
│  ├─ Screen display
│  ├─ Print preview
│  ├─ PDF export
│  ├─ Real-world test
│  └─ Browser compatibility
└─ Step 7: Automation (~1 day)
   ├─ build-inline-css.sh update
   └─ Verification

Total: ~11-14 days (2-3 weeks, depending on testing depth)
```

---

## Risks & Mitigation

| Risk | Impact | Mitigation |
|---|---|---|
| **Existing documents break** | Users can't print their `.sheet`-based docs | Keep old `assets/report.css` available. Provide migration guide. |
| **Print output differs per browser** | Firefox PDF != Chrome PDF | Test on 3+ browsers. Document expected differences. |
| **Page numbers unreliable** | Footer page count is wrong | Use CSS counters (if supported) or minimal JS. Test extensively. |
| **Margin boxes don't work in browser print** | `@page { @bottom-right {...} }` ignored | Fall back to sticky footer in HTML. More reliable. |
| **Content not breaking correctly** | Tables still split mid-row, figures orphaned | Use `break-inside: avoid` on all atomic blocks. Test with real content. |
| **Effort underestimated** | Takes 4 weeks instead of 2-3 | Buffer 50% time. Have a clear stop-point for MVP. |

---

## Success Criteria

After Phase 6 is complete, the skill should:

- ✅ Generate documents in linear HTML flow (no `.sheet` blocks)
- ✅ Automatically paginate on A4 boundaries using CSS
- ✅ Print to PDF with correct page breaks, no orphans, no split tables
- ✅ Be editable like Word (authors add content, pages adjust)
- ✅ Have < 100 lines of JavaScript (or none)
- ✅ Have < 100 lines of pagination-specific CSS (vs. 350 now)
- ✅ Maintain all visual components (callouts, charts, stat-cards, etc.) without regression
- ✅ Pass real-world test: Génome Réunion ~18 pages (down from 37)
- ✅ Work in Chrome, Firefox, Safari (print output)

---

## Decision Points Before Starting

1. **Sticky footer vs. CSS counters**: Which approach for page numbering?
   - Sticky footer (HTML) = reliable, works everywhere
   - CSS counters = elegant, but may not work in all browsers/print tools

2. **Minimal JS or none**: Keep paginate.js for TOC linking?
   - With JS: dynamic TOC page numbers
   - Without: static or manual TOC numbering

3. **Test scope**: How comprehensive?
   - MVP: basic print preview, 3 browsers, 1 real document
   - Full: all 6 examples, 5+ browsers, regression testing

4. **Backward compatibility**: Keep old `.sheet` model available?
   - Yes: maintain `assets/report.css` alongside new `assets/report-linear.css`
   - No: clean break, docs only for new model

---

## Timeline Estimate

| Phase | Days | Notes |
|---|---|---|
| **Step 1** | 1 | CSS design |
| **Step 2** | 3 | Template rewrite |
| **Step 3** | 1 | paginate.js simplification |
| **Step 4** | 2 | Example rewrite |
| **Step 5** | 1 | Doc updates |
| **Step 6** | 2–3 | Testing & validation |
| **Step 7** | 1 | Automation |
| **Buffer** | 2–3 | Unexpected issues |
| **Total** | **13–16 days** | ~2–3 weeks (full-time) |

---

## Final Note

**Phase 6 is optional.** Execute only if:
- Phase 5 (colors) + Phase 5b (editing UX) don't fully solve your problem
- You need a production-grade, maintainable skill for long-term use
- You're willing to invest 2–3 weeks and handle a complete rewrite

If Phase 5 + 5b are sufficient, stop there. The skill will be usable and the fix surface is much smaller.
