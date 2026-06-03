#!/bin/bash
# build-inline-css.sh — Make every template/example a self-contained, paginated HTML file.
#
# For each target it:
#   1. Inlines the canonical CSS from assets/report-linear.css into <style>…</style>.
#   2. Inlines the Paged.js polyfill (assets/vendor/paged.polyfill.min.js) plus a small
#      PagedConfig hook, so the file paginates to A4 with a repeating footer and
#      "Page n / total" numbering — on screen AND in print — with no external files.
#   3. Repairs structure: one <style>, one </head>, one <body>.
#   4. Normalizes the footer: removes any legacy <span class="pageno">…</span>
#      (the page number now comes from the CSS @page counter) and strips the old
#      end-of-body pagination <script> (Paged.js replaces it).
#
# Usage: cd report_skill && bash build-inline-css.sh

set -e

CSS_SOURCE="assets/report-linear.css"
PAGED_SOURCE="assets/vendor/paged.polyfill.min.js"
CONFIG_SOURCE="assets/paginate.js"

for src in "$CSS_SOURCE" "$PAGED_SOURCE" "$CONFIG_SOURCE"; do
  if [ ! -f "$src" ]; then
    echo "❌ Error: $src not found. Run from the report_skill/ directory."
    exit 1
  fi
done

echo "=== Build self-contained paginated HTML (Linear Flux + Paged.js) ==="
echo "CSS:      $CSS_SOURCE ($(wc -l < "$CSS_SOURCE") lines)"
echo "Paged.js: $PAGED_SOURCE ($(( $(wc -c < "$PAGED_SOURCE") / 1024 )) KB)"

python3 - "$CSS_SOURCE" "$PAGED_SOURCE" "$CONFIG_SOURCE" <<'PYTHON_SCRIPT'
import sys, glob, re

css_source, paged_source, config_source = sys.argv[1], sys.argv[2], sys.argv[3]
with open(css_source, "r", encoding="utf-8") as f:
    css = f.read().strip()
with open(paged_source, "r", encoding="utf-8") as f:
    paged = f.read().strip()
with open(config_source, "r", encoding="utf-8") as f:
    config = f.read().strip()

# PagedConfig + TOC helper (single source of truth: assets/paginate.js).
# Must come BEFORE the polyfill, which reads window.PagedConfig at startup.
paged_config = "<script>\n" + config + "\n</script>"

paged_script = ("<script>/* Paged.js v0.4.3 — inlined polyfill: A4 pagination, "
                "running footer, page numbers. Source: assets/vendor/paged.polyfill.min.js */\n"
                + paged + "\n</script>")

head_injection = paged_config + "\n" + paged_script

# Files with bespoke CSS or the deprecated .sheet model are NOT synced here.
EXCLUDE = {
    "templates/sheet-blank.html",                 # deprecated .sheet model
    "examples/demo-phase2-avant-apres.html",      # standalone demo with custom CSS
}

targets = sorted(glob.glob("templates/*.html")) + sorted(glob.glob("examples/*.html"))
targets = [t for t in targets if t not in EXCLUDE]

for path in targets:
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    # 1) Everything up to & including the first <style> is the head prefix.
    m_style = re.search(r"<style[^>]*>", content)
    if not m_style:
        print(f"  ⚠ Skipping {path} (no <style> block)")
        continue
    prefix = content[: m_style.end()]

    # 2) Find where the real HTML body begins.
    m_body = re.search(r"<body[^>]*>", content)
    if m_body:
        body_tag = content[m_body.start(): m_body.end()]   # keep <body> attributes
        body_inner = content[m_body.end():]
    else:
        m_cover = re.search(r'<section class="cover"', content)
        if not m_cover:
            print(f"  ⚠ Skipping {path} (no <body> and no cover section)")
            continue
        m_lang = re.search(r'<html[^>]*\blang="([^"]+)"', content)
        lang = m_lang.group(1) if m_lang else None
        body_tag = f'<body lang="{lang}">' if lang else "<body>"
        body_inner = content[m_cover.start():]

    # 3) Normalize the footer: drop legacy page-number span (counter handles it now).
    body_inner = re.sub(r'\s*<span class="pageno">.*?</span>', "", body_inner, flags=re.DOTALL)

    # 4) Strip the old end-of-body pagination script (Paged.js replaces it).
    body_inner = re.sub(r'\s*<script>(?:(?!</script>).)*?numberPages(?:(?!</script>).)*?</script>',
                        "", body_inner, flags=re.DOTALL)

    rebuilt = (
        prefix + "\n"
        + css + "\n"
        + "  </style>\n"
        + head_injection + "\n"
        + "</head>\n"
        + body_tag + "\n"
        + body_inner.lstrip("\n")
    )

    with open(path, "w", encoding="utf-8") as f:
        f.write(rebuilt)

    so = rebuilt.count("<style")
    sc = rebuilt.count("</style>")
    bo = len(re.findall(r"<body", rebuilt))
    pg = rebuilt.count("window.PagedConfig =")
    no_pageno = rebuilt.count('class="pageno"')
    flag = "OK" if (so == 1 and sc == 1 and bo == 1 and pg == 1 and no_pageno == 0) else "FAIL"
    print(f"  [{flag}] {path}  (style={so}/{sc} body={bo} paged={pg} pageno={no_pageno})")

print("Done.")
PYTHON_SCRIPT

echo "=== Build complete ==="
