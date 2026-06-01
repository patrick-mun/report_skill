/* paginate.js — A4 sheet pagination helper (see references/pagination.md).
   For documents built with the .sheet model. It:
     1. numbers every .sheet footer ("Page n / total") bottom-right;
     2. flags any sheet whose content overflows one A4 page (screen only),
        so the author knows to split that page.
   Inline this script at the end of <body> so the output stays self-contained.
   No dependency, no network. */
(function () {
  "use strict";

  function paginate() {
    var sheets = Array.prototype.slice.call(document.querySelectorAll(".sheet"));
    var total = sheets.length;

    sheets.forEach(function (sheet, i) {
      // --- page number ---
      var footer = sheet.querySelector(".sheet__footer");
      if (footer) {
        var no = footer.querySelector(".pageno");
        if (!no) {
          no = document.createElement("span");
          no.className = "pageno";
          footer.appendChild(no);
        }
        no.textContent = "Page " + (i + 1) + " / " + total;
      }

      // --- overflow detection (screen only) ---
      var flag = sheet.querySelector(".overflow-flag");
      if (!flag) {
        flag = document.createElement("div");
        flag.className = "overflow-flag";
        flag.textContent = "Contenu trop long pour une page A4 — à scinder";
        sheet.appendChild(flag);
      }
      // a small tolerance avoids false positives from sub-pixel rounding
      var overflowing = sheet.scrollHeight > sheet.clientHeight + 2;
      sheet.classList.toggle("is-overflowing", overflowing);
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", paginate);
  } else {
    paginate();
  }
  // re-check after fonts/images settle and before printing
  window.addEventListener("load", paginate);
  window.addEventListener("beforeprint", paginate);
})();
