#!/bin/bash
# build-renumber.sh — Auto-renumber sheet IDs and page footers

set -e

if [ $# -ne 1 ]; then
  echo "Usage: bash build-renumber.sh <html-file>"
  exit 1
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
  echo "❌ Error: $FILE not found"
  exit 1
fi

echo "🔄 Renumbering pages in $FILE..."

python3 - "$FILE" << 'EOF'
import re
import sys

file_path = sys.argv[1]

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Find all sections with class="sheet"
sections = list(re.finditer(r'<section[^>]*?class="[^"]*sheet[^"]*?"[^>]*?>', content))

# Identify which sections are "regular" (not cover/toc)
regular_indices = []
for i, match in enumerate(sections):
    tag = match.group(0)
    if '--cover' not in tag and '--toc' not in tag:
        regular_indices.append(i)

total_pages = len(regular_indices)

# Build ID mapping for regular sheets
id_map = {}
for page_num, section_idx in enumerate(regular_indices, 1):
    match = sections[section_idx]
    tag = match.group(0)
    id_match = re.search(r'id="page(\d+)"', tag)
    if id_match:
        old_id = id_match.group(1)
        id_map[old_id] = str(page_num)

# Step 1: Replace page IDs
for old_id, new_id in id_map.items():
    content = re.sub(rf'id="page{re.escape(old_id)}"', f'id="page{new_id}"', content)

# Step 2: For each regular sheet, find and replace its page number
# Parse the content again to get fresh positions
sections = list(re.finditer(r'<section[^>]*?class="[^"]*sheet[^"]*?"[^>]*?>', content))

for page_num, section_idx in enumerate(regular_indices, 1):
    match = sections[section_idx]
    sheet_start = match.start()

    # Find end of this sheet (start of next section or end of file)
    if section_idx + 1 < len(sections):
        sheet_end = sections[section_idx + 1].start()
    else:
        sheet_end = len(content)

    # Extract sheet region and replace page number
    sheet_html = content[sheet_start:sheet_end]

    # Pattern: <span class="pageno">Page <span class="num">OLD</span>/OLD</span>
    old_pageno_pattern = r'<span class="pageno">Page <span class="num">\d+</span>/\d+</span>'
    new_pageno = f'<span class="pageno">Page <span class="num">{page_num}</span>/{total_pages}</span>'

    sheet_html_updated = re.sub(old_pageno_pattern, new_pageno, sheet_html)

    # Replace in main content
    content = content[:sheet_start] + sheet_html_updated + content[sheet_end:]

    # Recalculate section positions after modification
    # because string lengths may have changed
    sections = list(re.finditer(r'<section[^>]*?class="[^"]*sheet[^"]*?"[^>]*?>', content))

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print(f'✓ Renumbered {total_pages} numbered pages (cover and TOC skipped)')

EOF
