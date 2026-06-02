# Pagination — print-perfect A4 sheets with footers and page numbers

Printing a continuous HTML flow to A4 is unreliable: the browser decides where to break, which leaves **lonely tables/figures on a page** and **large empty gaps** between sections. For any report meant to be printed or exported to PDF, use the **A4 sheet model** instead.

## The A4 sheet model

The document is split into explicit `.sheet` elements, each exactly **210 × 297 mm**. On screen they look like stacked sheets of paper — the grey gap between them marks the boundary to the next page. In print, each `.sheet` is exactly one physical A4 page. Because the sheet is the unit, **you** control what goes on each page; there are no surprise breaks or gaps.

### Skeleton

```html
<body class="paged">
  <section class="sheet">
    <div class="sheet__body">
      <!-- content of page 1 -->
    </div>
    <footer class="sheet__footer">
      <span>Document Title · confidentiality</span>
      <!-- .pageno is filled automatically by paginate.js -->
    </footer>
  </section>

  <section class="sheet">
    <div class="sheet__body"> <!-- page 2 --> </div>
    <footer class="sheet__footer"><span>Document Title</span></footer>
  </section>

  <script> /* inline assets/paginate.js here */ </script>
</body>
```

- `body.paged` switches on the paged background.
- Each `.sheet` = one A4 page. Put a `.sheet__footer` in every sheet.
- The left side of the footer is free (document title, confidentiality…); the **page number is added automatically at the bottom-right** by `paginate.js`.

## paginate.js (required for this model)

Inline `assets/paginate.js` at the end of `<body>`. It:

1. stamps every footer with `Page n / total`, bottom-right;
2. flags (on screen, red dashed outline + badge) any sheet whose content overflows one A4 page, so you know to split it.

No dependency, no network — the file stays self-contained.

## How to pack pages well (avoid gaps and lonely blocks)

- **Fill, don't scatter.** Aim to fill each sheet; start a new sheet at a natural boundary (a new top-level section, or before a large table/figure that would otherwise be split badly).
- **Keep a heading with its content.** Don't end a sheet with a heading whose body starts on the next sheet — move the heading to the next sheet.
- **Keep atomic visuals whole.** A table, figure, callout, chart or gantt should sit entirely on one sheet. If one alone nearly fills a page, give it its own sheet and pair surrounding text with it deliberately.
- **Watch the overflow flag.** If `paginate.js` marks a sheet as overflowing, split its content across two sheets. Re-numbering is automatic.
- **Usable height ≈ 265 mm** per sheet (297 − 16 − 12 mm padding, minus the footer). Roughly 45–55 lines of body text, fewer with visuals.

## Why not pure CSS `@page` counters or a JS layout engine?

- Browsers (Chrome/Firefox) ignore `@page { @bottom-right { content: counter(page) } }` margin boxes when printing, so CSS-only page numbers don't appear in browser-to-PDF. Stamping the number into the DOM (paginate.js) prints reliably.
- Auto-flow engines (e.g. Paged.js) can fragment content automatically and are an option for very long, frequently-edited documents, but they add a heavy JS dependency and reduce control. The explicit sheet model is lighter, fully self-contained, and gives precise control — preferred here.

## Print checklist (before PDF export)

1. **Open the HTML file in Chrome or Firefox.**
2. **On-screen overflow detection (critical):**
   - Look for **red dashed outline + "Contenu trop long" badge** on any `.sheet`.
   - If found, you **must split that sheet** into two sheets in the HTML source and retest before proceeding.
   - An overflowing page will print with content cut off or spilled onto the next page, breaking the layout.
3. **Verify margins and spacing** (print preview, `Ctrl/Cmd + P`):
   - Set **margins to None** (the `.sheet` CSS already provides 13 mm padding).
   - Enable **"Background graphics"** so colours and callout boxes print correctly.
4. **Check page numbering:**
   - Verify footers show "Page n / total" at bottom-right on all content sheets.
   - Cover and TOC should have blank page numbers.
5. **Visual check:**
   - No orphaned headings (a section heading alone at the bottom of a page).
   - No single-line paragraphs stranded at the top of a page.
   - Tables and figures sit whole on their sheet, not split across pages.
6. **Export to PDF:**
   - Use the browser's "Save as PDF" option (preferable to a separate PDF printer).
   - Verify the PDF displays correctly and all pages are present.

### Why overflow detection is critical

If `paginate.js` detects a sheet whose `scrollHeight` exceeds `clientHeight + 2px`, it marks it as overflowing. This is a **sign to split the content**, not a minor warning. A sheet that overflows on screen will be cut off or misaligned when printed, depending on the browser and printer settings.
