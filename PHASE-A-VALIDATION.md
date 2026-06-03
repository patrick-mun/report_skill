# Phase A — Paged.js Validation Report

**Status: ✅ PASS** — Paged.js produces per-page footers with `Page n / total` in real PDF output.

## Objective

Confirm that **Paged.js** (CSS `@page` polyfill) resolves the skill's core gap:
the linear-flux model cannot produce repeating per-page footers or page numbers
in Chrome's native print, because Chrome does not support `@page` margin-boxes.

## Method

- Built `test-pagedjs.html`: a multi-page document using the linear-flux structure
  (`section.cover` → `nav.toc-page` → `main` with `break-before: page` on `h2`),
  plus `@page` margin-boxes:
  ```css
  @page {
    @bottom-left  { content: "…title…"; }
    @bottom-right { content: "Page " counter(page) " / " counter(pages); }
  }
  @page :first { @bottom-left { content: ""; } @bottom-right { content: ""; } }
  ```
- Vendored `assets/vendor/paged.polyfill.min.js` (Paged.js v0.4.3) from the npm registry.
- Rendered headless (Chromium via Playwright), waited for Paged.js completion
  (`PagedConfig.after` hook), generated a real PDF (`page.pdf`, `preferCSSPageSize: true`),
  and extracted text directly from the PDF with PyMuPDF.

## Evidence (from the actual PDF file, not screen DOM)

| PDF page | Extracted footer |
|---|---|
| 1 (cover) | *(none — `@page :first` exclusion works)* |
| 3 (content) | `Paged.js Validation · CHU` · `Page 3 / 16` |
| 16 (last) | `Paged.js Validation · CHU` · `Page 16 / 16` |

- ✅ `counter(page)` resolves and increments on every page.
- ✅ `counter(pages)` resolves to the correct total (`/ 16`).
- ✅ Footer (left + right) renders on every content page.
- ✅ Cover page excluded via `@page :first`.
- ✅ PDF page count (16) == Paged.js page count (16) → **no double-pagination**
  (using `preferCSSPageSize: true`).
- ✅ Transparent: load + print, no print-dialog interaction required.

## Findings that update the plan

1. **Polyfill weight is ~503 KB minified (97 KB gzipped), not ~25 KB** as estimated
   in the plan. This materially affects the "single self-contained file" promise:
   - Inlined, every report carries +503 KB of JS.
   - **Phase B decision point:** inline the polyfill (true single file, heavier) vs.
     reference `assets/vendor/paged.polyfill.min.js` (lighter HTML, needs the file
     alongside). Recommend inlining for the self-contained promise, and documenting
     the weight; offer a build flag for the external option.
2. **Margin-box content renders via `::after` pseudo-elements**, so QA/verification
   must inspect the rendered PDF or computed `::after`, never `element.textContent`.
3. **`@page :first` reliably blanks the cover footer.** Using `content: ""` keeps the
   `hasContent` class but renders nothing — visually and in PDF text, the cover is clean.
4. **`paginate.js` page-number estimation becomes obsolete** — Paged.js owns page
   numbers now. `paginate.js` should be reduced to TOC smooth-scroll + (optionally)
   filling on-screen TOC page numbers from Paged.js's computed page locations.

## Conclusion

Paged.js is confirmed as the engine. **Proceed to Phase B** (integrate into
`report-linear.css` margin-boxes, adapt `build-inline-css.sh`, decide inline vs.
external polyfill, simplify `paginate.js`).
