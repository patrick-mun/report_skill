#!/bin/bash
# build-renumber.sh — Auto-renumber sheet IDs and page footers
# Usage: bash build-renumber.sh <html-file>
# Sequential renumbering: id="pageXXX" and footer <span class="pageno">

set -e

if [ $# -ne 1 ]; then
  echo "Usage: bash build-renumber.sh <html-file>"
  echo "Example: bash build-renumber.sh examples/exemple-pro.html"
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

# Find all sheet sections
sections = []
for m in re.finditer(r'<section[^>]*?class="[^"]*sheet[^"]*?"[^>]*?>', content):
    text = m.group(0)
    is_special = '--cover' in text or '--toc' in text
    sections.append({'pos': m.start(), 'text': text, 'is_special': is_special})

# Build ID mapping for regular sheets
regular_sheets = [s for s in sections if not s['is_special']]
id_map = {}
for i, sheet in enumerate(regular_sheets, 1):
    m = re.search(r'id="page(\d+)"', sheet['text'])
    if m:
        id_map[m.group(1)] = str(i)

total = len(regular_sheets)

# Replace page IDs
for old, new in id_map.items():
    content = re.sub(rf'id="page{re.escape(old)}"', f'id="page{new}"', content)

# Update pageno spans
sections = list(re.finditer(r'<section[^>]*?class="[^"]*sheet[^"]*?"[^>]*?>', content))
page_num = 1
for i, m in enumerate(sections):
    text = m.group(0)
    if '--cover' in text or '--toc' in text:
        continue

    sheet_start = m.start()
    sheet_end = sections[i+1].start() if i+1 < len(sections) else len(content)
    region = content[sheet_start:sheet_end]

    pageno = re.search(r'<span class="pageno">.*?</span>', region)
    if pageno:
        pos_start = sheet_start + pageno.start()
        pos_end = sheet_start + pageno.end()
        new_text = f'<span class="pageno">Page <span class="num">{page_num}</span>/{total}</span>'
        content = content[:pos_start] + new_text + content[pos_end:]

    page_num += 1

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print(f'✓ Renumbered {total} numbered pages (cover and TOC skipped)')

EOF

echo "Done."
