# Pagination — A4 layout with CSS @page (linear flux model)

Modern A4 pagination uses **CSS @page rules** and browser-native pagination instead of rigid explicit page boxes. This approach is cleaner, more maintainable, more editable (like Word), and leverages standard web standards.

## The linear flux model (Phase 6)

Content flows naturally in the browser (like any web page), and **CSS handles pagination automatically**:
- `@page { size: A4; margin: 20mm; }` — tells the browser each page is A4-sized
- `h2 { break-before: page; }` — major sections start on a new page
- `table, figure, aside { break-inside: avoid; }` — keep block elements whole

**On screen:** Content flows top-to-bottom (like reading a continuous document).  
**In print:** The browser respects page boundaries and renders A4-sized pages.  
**Result:** No overflow detection needed, no manual page splitting, cleaner HTML.

### Skeleton

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    /* Inline assets/report-linear.css here */
    @page {
      size: A4;
      margin: 20mm;
    }
    h2 { break-before: page; }
    table, figure { break-inside: avoid; }
  </style>
</head>
<body>
  <main>
    <!-- Cover page -->
    <section class="cover">
      <h1>Report Title</h1>
      <p>Author, date, etc.</p>
    </section>

    <!-- Table of Contents -->
    <nav class="toc-page">
      <h2>Table of Contents</h2>
      <ol>
        <li><a href="#s1">Section 1</a></li>
        <li><a href="#s2">Section 2</a></li>
      </ol>
    </nav>

    <!-- Content sections (each h2 starts a new page) -->
    <section id="s1">
      <h2>Section 1: Title</h2>
      <p>Content here.</p>
    </section>

    <section id="s2">
      <h2>Section 2: Title</h2>
      <p>Content here.</p>
    </section>

    <!-- Single footer at the end (appears on all pages) -->
    <footer class="page-footer">
      <span>Document Title</span>
      <span class="pageno">Page X / Y</span>
    </footer>
  </main>

  <script>
    /* Optional: inline assets/paginate.js here for TOC linking and page numbering */
  </script>
</body>
</html>
```

## Key features

- **No `.sheet` boxes:** Content is semantic HTML (`<section>`, `<nav>`, `<main>`, `<footer>`).
- **CSS handles pagination:** The `@page` rule + `break-*` properties do the heavy lifting.
- **Automatic page breaks:** `h2` headings trigger page breaks via `break-before: page`.
- **Block protection:** Tables, figures, callouts don't split across pages (`break-inside: avoid`).
- **Single footer:** One `<footer>` at the end applies to all pages in print.
- **Optional JS:** `paginate.js` adds TOC link smooth-scrolling and page number estimation (nice to have, not required).

## CSS @page rule

```css
@page {
  size: A4;                /* 210 × 297 mm */
  margin: 20mm;            /* All sides */
}

/* Major section headings start on new pages */
h2 {
  break-before: page;
}

/* Block elements don't split */
table, figure, aside.callout {
  break-inside: avoid;
}
```

## Why this model (vs. rigid `.sheet` boxes)

| Aspect | Old `.sheet` model | New linear flux |
|--------|-------------------|-----------------|
| Page unit | Explicit 210×297mm box | Semantic HTML + CSS @page |
| Content flow | Rigid, hard to edit | Natural flow (Word-like) |
| Overflow detection | JavaScript pixel measurement | CSS handles it |
| Page breaks | Manual (split sheets manually) | Automatic (h2 triggers break) |
| Maintenance | Brittle (re-numbering pages) | Clean (add section, done) |
| Dependencies | Custom paginate.js required | Browser CSS @page (standard) |
| Portability | Self-contained (CSS + JS inline) | Self-contained (CSS inline) |

## How to add a new section

No renumbering needed. Just:

```html
<section id="s5">
  <h2>New Section Title</h2>
  <p>Your content.</p>
</section>
```

The `h2` triggers a page break automatically. Update the TOC if needed:

```html
<li><a href="#s5">New Section Title</a></li>
```

Done.

## Best practices for readable pages

- **One major topic per section (h2).** Each `<h2>` starts a new page — align section boundaries with topic boundaries.
- **Keep related content together.** Use `<h3>` for subsections (doesn't force a page break).
- **Tables and figures whole.** The CSS `break-inside: avoid` keeps them on one page. If a single table is too large to fit on a page with any surrounding text, put it on its own page by adjusting the preceding content.
- **Avoid orphaned headings.** Don't end a page with a heading whose body is on the next page — the CSS `orphans` rule (3 lines minimum) helps, but structure intentionally.
- **Usable height ≈ 257 mm** per page (297 − 20 − 20 mm margins). Roughly 40–50 lines of body text, fewer with large visuals or tables.
- **Color preservation in print.** Use `color-adjust: exact` (or `-webkit-print-color-adjust: exact`) on colored elements so they print as intended. `assets/report-linear.css` includes this for all visual components.

## Print checklist (before PDF export)

1. **Open the HTML file in Chrome or Firefox.**

2. **On-screen preview:**
   - Scroll through the entire document.
   - Check that `h2` headings appear at the top of sections (not orphaned at the bottom of a page).
   - Verify tables and figures don't have awkward wrapping or overflow.
   - Check footer appearance (should be visible on every page when printed).

3. **Print preview (`Ctrl/Cmd + P`):**
   - Click "More settings" or equivalent.
   - **Margins:** Set to "None" (the CSS already includes 20mm margins via `@page`).
   - **Background graphics:** Enable so colored stat cards, callouts, and composition bars print correctly.
   - **Paper size:** Confirm it shows "A4".
   - **Orientation:** Portrait.

4. **Verify on the preview:**
   - Page count matches expectation (check last page number in footer).
   - Page breaks occur at `h2` headings, not mid-table or mid-figure.
   - Footers appear on all content pages.
   - Colors are preserved (stat cards, bars, callouts all visible).
   - Text and tables are readable, not cramped.

5. **Export to PDF:**
   - Use the browser's "Save as PDF" option.
   - Open the PDF and spot-check a few pages: colors, fonts, footers, page breaks all as expected.

6. **Special cases:**
   - **Missing page numbers in footer:** If the footer shows "Page — / —", it means `paginate.js` hasn't run yet. This is fine — the footer will still appear, just without auto-numbered page counts. For manual numbering, edit the footer text directly.
   - **Broken TOC links:** If TOC links don't work, ensure your sections have matching `id` attributes (e.g., `id="s1"` and `href="#s1"`).
   - **Color not printing:** Enable "Background graphics" in print settings. If still missing, ensure the colored element has `color-adjust: exact` in the CSS.

## When to use the linear flux model

✅ Use this model (report-linear.css + semantic HTML) for:
- New documents created from scratch
- Documents that need to be edited frequently
- Reports shared as single HTML files
- Anything that benefits from Word-like editability

❌ Legacy `.sheet` model (report.css) is only for:
- Existing documents built with the old model
- Edge cases where pixel-perfect page control is absolutely required
- Backward compatibility (the old files still work)

## Migration from the old `.sheet` model

See `STEP3-MIGRATION.md` for detailed guidance on migrating from rigid `.sheet` boxes to semantic HTML + CSS @page.
