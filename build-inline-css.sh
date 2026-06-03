#!/bin/bash
# build-inline-css.sh — Sync the canonical CSS into every standalone HTML file.
#
# Reads assets/report-linear.css (the Linear Flux Model stylesheet) and inlines
# it into the <style> block of every template and example, guaranteeing a single
# source of truth. It also REPAIRS structure: CSS always ends up inside
# <style>…</style>, the <head> closes once, and a <body> wraps the content.
#
# Usage: cd report_skill && bash build-inline-css.sh

set -e

CSS_SOURCE="assets/report-linear.css"

if [ ! -f "$CSS_SOURCE" ]; then
  echo "❌ Error: $CSS_SOURCE not found. Run from the report_skill/ directory."
  exit 1
fi

echo "=== CSS Synchronization (Linear Flux Model) ==="
echo "Source: $CSS_SOURCE ($(wc -l < "$CSS_SOURCE") lines)"

python3 - "$CSS_SOURCE" <<'PYTHON_SCRIPT'
import sys, glob, re

css_source = sys.argv[1]
with open(css_source, "r", encoding="utf-8") as f:
    css = f.read().strip()

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
        # Broken file: no <body>. Body content starts at the cover section.
        m_cover = re.search(r'<section class="cover"', content)
        if not m_cover:
            print(f"  ⚠ Skipping {path} (no <body> and no cover section)")
            continue
        m_lang = re.search(r'<html[^>]*\blang="([^"]+)"', content)
        lang = m_lang.group(1) if m_lang else None
        body_tag = f'<body lang="{lang}">' if lang else "<body>"
        body_inner = content[m_cover.start():]

    rebuilt = (
        prefix + "\n"
        + css + "\n"
        + "  </style>\n"
        + "</head>\n"
        + body_tag + "\n"
        + body_inner.lstrip("\n")
    )

    with open(path, "w", encoding="utf-8") as f:
        f.write(rebuilt)

    so = rebuilt.count("<style")
    sc = rebuilt.count("</style>")
    bo = len(re.findall(r"<body", rebuilt))
    flag = "OK" if (so == 1 and sc == 1 and bo == 1) else "FAIL"
    print(f"  [{flag}] {path}  (<style>={so} </style>={sc} <body>={bo})")

print("Done.")
PYTHON_SCRIPT

echo "=== Synchronization complete ==="
