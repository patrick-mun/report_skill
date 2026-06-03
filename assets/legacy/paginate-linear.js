/* ============================================================================
   paginate-linear.js — Minimal pagination helper for linear flux model

   SIMPLIFIED from the old paginate.js (which was built for .sheet model).

   This script does TWO things:
   1. Number pages: Count content sections and update the footer page number
   2. Link TOC: Make TOC entries clickable with smooth scroll

   WHY SO MINIMAL?
   - The OLD overflow detection is gone (CSS @page now handles pagination)
   - The OLD .sheet detection is gone (we use <section> + <main> now)
   - Browser handles page breaks automatically (break-before: page, break-inside: avoid)

   WHAT REMAINS:
   - Simple section counter (for footer display: "Page X / Y")
   - TOC linking (smooth scroll, page number lookup)

   NO DEPENDENCIES: Pure JavaScript. No framework needed.
   NO PERFORMANCE COST: Runs once on load, re-runs on print.
   ============================================================================ */

(function() {
  "use strict";

  /* ========================================================================
     FUNCTION: numberPages()
     Count the main content sections and update the footer page number.

     OLD behavior: Looked for .sheet elements and measured pixel height.
     NEW behavior: Count <section> elements with id="s*" (or similar),
                   estimate total pages based on section count.

     NOTE: In pure CSS pagination, we don't know the true page count until
     the browser lays out the document. This is an ESTIMATE for UX.
     For accurate page counts, use print preview (Ctrl+P).
     ======================================================================== */
  function numberPages() {
    // Count content sections (id="s1", "s2", "s3", etc.)
    var contentSections = document.querySelectorAll('main > section[id^="s"]');

    if (contentSections.length === 0) {
      // Fallback: if no main > section, try all section[id^="s"]
      contentSections = document.querySelectorAll('section[id^="s"]');
    }

    // Rough estimate: ~1.5 sections per page on average
    // (covers, TOC, content with varying heights)
    var estimatedPages = Math.max(1, Math.ceil(contentSections.length / 1.5));

    // Update the footer page number display
    var pagenoEl = document.querySelector('.pageno');
    if (pagenoEl) {
      pagenoEl.textContent = 'Page — / ~' + estimatedPages;
      // Tip: Replace "Page — / ~X" with actual page count from print dialog
    }

    // Update TOC page numbers (simple: section 1 = page 2, 2 = page 3, etc.)
    // Because: page 1 = cover, page 2 starts with TOC or first section
    var tocEntries = document.querySelectorAll('a.toc-entry[href^="#"]');
    tocEntries.forEach(function(link, idx) {
      var numEl = link.querySelector('.toc-page-num');
      if (numEl) {
        // Estimate: each TOC entry corresponds to roughly (idx+2) page
        numEl.textContent = String(idx + 2);
      }
    });
  }

  /* ========================================================================
     FUNCTION: bindTocLinks()
     Make TOC entries clickable. Smooth scroll to the target section.

     OLD behavior: Found .sheet parent of the target, looked up its page number.
     NEW behavior: Find the target section directly, scroll to it.
     ======================================================================== */
  function bindTocLinks() {
    document.querySelectorAll('a.toc-entry[href^="#"]').forEach(function(link) {
      link.addEventListener('click', function(e) {
        // Extract the section ID from the href (e.g., "#s1" -> "s1")
        var id = this.getAttribute('href').slice(1);
        var target = document.getElementById(id);

        if (target) {
          // Prevent default link behavior
          e.preventDefault();

          // Smooth scroll to the target section
          target.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
      });
    });
  }

  /* ========================================================================
     EXECUTION: Run on document ready and on print
     ======================================================================== */

  // If DOM is still loading, wait for DOMContentLoaded
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      numberPages();
      bindTocLinks();
    });
  } else {
    // DOM is ready, run immediately
    numberPages();
    bindTocLinks();
  }

  // Re-run on load (just in case)
  window.addEventListener('load', numberPages);

  // Re-run before print (in case content shifted)
  window.addEventListener('beforeprint', numberPages);

  // Optional: Re-run on resize (for responsive adjustments)
  // window.addEventListener('resize', numberPages);
})();

/* ============================================================================
   MIGRATION NOTES:
   - Old paginate.js: 137 lines, with overflow detection + .sheet logic
   - New paginate-linear.js: ~120 lines, pure pagination helper
   - If you don't need page numbering at all, you can DELETE this file.
     CSS @page handles everything else.
   ============================================================================ */
