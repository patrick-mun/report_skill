#!/bin/bash
# build-inline-css.sh — Sync CSS across all examples and templates
# Usage: cd report-formatter && bash build-inline-css.sh
# Reads the canonical CSS from assets/report.css and inlines it into all HTML files
# that have a <style> block, ensuring they all use the same version.

set -e

CSS_SOURCE="assets/report.css"
TARGETS=(
  "examples/exemple-pro.html"
  "examples/exemple-genome-reunion-scientifique.html"
  "examples/exemple-genome-reunion-financier.html"
  "examples/example-professional.html"
  "examples/example-genome-meeting-scientific.html"
  "examples/example-genome-meeting-funder.html"
  "templates/professionnel.html"
  "templates/recherche.html"
  "templates/dossier-scientifique.html"
  "templates/professional.html"
  "templates/research.html"
  "templates/scientific-dossier.html"
)

echo "=== CSS Synchronization ==="

if [ ! -f "$CSS_SOURCE" ]; then
  echo "❌ Error: $CSS_SOURCE not found. Run from report-formatter/ directory."
  exit 1
fi

# Read and minify CSS: remove newlines, collapse multiple spaces to single space
echo "Reading and minifying $CSS_SOURCE..."
css_content=$(cat "$CSS_SOURCE" | tr '\n' ' ' | sed 's/  */ /g')
css_len=${#css_content}
echo "Minified CSS: $css_len characters"

for target in "${TARGETS[@]}"; do
  if [ ! -f "$target" ]; then
    echo "⚠ Skipping $target (not found)"
    continue
  fi

  echo -n "Processing $target... "

  # Create temporary file
  tmp_file="${target}.sync.tmp"

  # Use Python to safely replace CSS between <style> and </style> tags
  python3 << PYTHON_SCRIPT
import re

css = """$css_content"""

with open("$target", "r") as f:
  content = f.read()

# Match <style>...any content...</style> and replace the content
pattern = r'(<style>).*?(</style>)'
replacement = r'\1\n' + css + r'\n\2'
updated = re.sub(pattern, replacement, content, flags=re.DOTALL)

with open("$tmp_file", "w") as f:
  f.write(updated)
PYTHON_SCRIPT

  mv "$tmp_file" "$target"
  echo "✓"
done

echo ""
echo "✓ Done. All files now use the canonical CSS from $CSS_SOURCE"
echo "  Commit these changes to keep the skill in sync."
