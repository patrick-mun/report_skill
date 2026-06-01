/* paginate.js — A4 sheet pagination helper (see references/pagination.md).
   Works with .sheet, .sheet--cover, .sheet--toc.
     1. Numbers content sheets only (cover + TOC are excluded from count).
     2. Flags any sheet whose content overflows A4 (screen only).
     3. Populates .toc-page-num inside <a class="toc-entry"> links
        by resolving each href="#id" to its parent sheet's page number.
     4. Smooth-scrolls to target sheet when a TOC entry is clicked.
   Inline at end of <body>. No dependency, no network. */
(function () {
  "use strict";

  function paginate() {
    var sheets = Array.prototype.slice.call(
      document.querySelectorAll(".sheet")
    );

    /* Split: cover + toc sheets vs content sheets */
    var contentSheets = sheets.filter(function (s) {
      return (
        !s.classList.contains("sheet--cover") &&
        !s.classList.contains("sheet--toc")
      );
    });

    /* --- Numbering + overflow detection --- */
    sheets.forEach(function (sheet) {
      /* Overflow flag (screen only) */
      var flag = sheet.querySelector(".overflow-flag");
      if (!flag) {
        flag = document.createElement("div");
        flag.className = "overflow-flag";
        flag.textContent = "Contenu trop long pour une page A4 — à scinder";
        sheet.appendChild(flag);
      }
      sheet.classList.toggle(
        "is-overflowing",
        sheet.scrollHeight > sheet.clientHeight + 2
      );

      /* Footer page label */
      var footer = sheet.querySelector(".sheet__footer");
      if (!footer) return;
      var no = footer.querySelector(".pageno");
      if (!no) {
        no = document.createElement("span");
        no.className = "pageno";
        footer.appendChild(no);
      }

      if (
        sheet.classList.contains("sheet--cover") ||
        sheet.classList.contains("sheet--toc")
      ) {
        no.textContent = ""; /* no number on cover / TOC */
      } else {
        var idx = contentSheets.indexOf(sheet);
        no.textContent =
          "Page " + (idx + 1) + " / " + contentSheets.length;
      }
    });

    /* --- TOC page numbers --- */
    var tocEntries = document.querySelectorAll("a.toc-entry[href]");
    tocEntries.forEach(function (link) {
      var href = link.getAttribute("href");
      if (!href || href.charAt(0) !== "#") return;
      var target = document.getElementById(href.slice(1));
      if (!target) return;
      var targetSheet = target.closest
        ? target.closest(".sheet")
        : (function () {
            var el = target;
            while (el && el !== document.body) {
              if (
                el.classList &&
                el.classList.contains("sheet")
              )
                return el;
              el = el.parentNode;
            }
            return null;
          })();
      if (!targetSheet) return;
      var contentIdx = contentSheets.indexOf(targetSheet);
      var numEl = link.querySelector(".toc-page-num");
      if (numEl) {
        numEl.textContent =
          contentIdx >= 0 ? String(contentIdx + 1) : "—";
      }
    });
  }

  /* --- Smooth scroll for TOC clicks (screen only) --- */
  function bindTocLinks() {
    document.querySelectorAll('a.toc-entry[href^="#"]').forEach(
      function (link) {
        link.addEventListener("click", function (e) {
          var id = this.getAttribute("href").slice(1);
          var target = document.getElementById(id);
          if (!target) return;
          e.preventDefault();
          target.scrollIntoView({ behavior: "smooth", block: "start" });
        });
      }
    );
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", function () {
      paginate();
      bindTocLinks();
    });
  } else {
    paginate();
    bindTocLinks();
  }
  window.addEventListener("load", paginate);
  window.addEventListener("beforeprint", paginate);
})();
