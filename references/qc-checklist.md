# QA Checklist — quality control before report delivery

This checklist is run **after consolidation and before the final HTML is sent to the user**. It covers the most common issues observed in multi-source reports (especially those involving methodology documents, budgets, and scientific content).

## Phase 1: Content completeness

- [ ] All source files have been included (slides, budget, methodology, bibliography, etc.).
- [ ] No section placeholder like `[To complete: …]` remains in the body text (these are acceptable only in annexes with explicit user note).
- [ ] All referenced sections exist: every "See Section 5" or "Figure 3" must have a corresponding section/figure in the document.
- [ ] Bibliography/references section present and complete if promised in title or abstract.
  - Count sections in the reference guide (e.g. "18 sections thématiques") and verify all are present in the document.
  - No orphaned headers like "D.1 …" without content underneath.

## Phase 2: Numbering and cross-references

- [ ] **Figure numbering is continuous** (1, 2, 3, 4, 5… no gaps). Use this command to check:
  ```bash
  grep -o 'Figure [0-9]\+\|Table [0-9]\+' document.html | sort -u
  ```
  If you see "Figure 1, 2, 3, 5" (missing 4), either renumber Figure 5→4 or find the missing content.
  
- [ ] **All figures have captions** with source attribution: "Figure N: [title]. Source: [file.md §3 or reference]."
- [ ] **All tables have captions** with numbers: "Table N: [title]."
- [ ] **Every cross-reference is valid:**
  ```bash
  # Extract all references like "See Figure 3" and verify Figure 3 exists
  grep -o 'Figure [0-9]\+\|Table [0-9]\+' document.html | cut -d' ' -f2 | sort -u > referenced.txt
  grep -o '<h[1-6][^>]*id=' document.html | sed 's/.*id="/Figure /' | grep "^Figure" | cut -d' ' -f2 | sort -u > defined.txt
  comm -23 referenced.txt defined.txt  # shows missing figures
  ```

## Phase 3: Typography and encoding

- [ ] **French accents and special characters** are correct:
  - `Équipe` (not `Equipe`)
  - `Maîtrise` (not `Maîtré`)
  - en-dashes `–` for ranges (not hyphens `-`)
  - `diploïdes` (not `dipoïdes`)
  - `Axe austronésien` (not `Axeaust ronésien` — check for broken compound words)
  
  Use a regex search in your editor: `[À-ÿ]` to find all accented characters and spot errors.

- [ ] **Entity encoding consistency**: if sources use HTML entities (`&#160;` for non-breaking space), they should be preserved or converted uniformly. Check for mixed `&nbsp;` and `&#160;`.
- [ ] **Quotes and apostrophes**: Unicode quotes `"…"` (not `"…"` or straight `"…"`), and `'` (not `'`).
- [ ] **Hyphenation and breaking**: long words (e.g. "bioinformatique") are not broken mid-word at page boundaries.

## Phase 4: Visual layout

- [ ] **No overflow flags (red boxes)** visible on-screen. If found: split the offending `.sheet` into two sheets.
- [ ] **Orphaned headings**: no section heading (h2, h3) should appear alone at the bottom of a page without its body following.
- [ ] **Lonely blocks**: no single line of text orphaned at the top of a new page.
- [ ] **Tables and figures are whole**: no table or figure split across two pages (move it to the page where it fits, or give it its own page).
- [ ] **Callout boxes and stat cards** render with correct colors and don't overflow their container.

## Phase 5: Metadata and footers

- [ ] **Document title** in `<title>` tag matches the cover page title.
- [ ] **Footers consistent**: every sheet has a `sheet__footer` with document identifier and (auto-filled) page number.
- [ ] **Cover sheet** has all required metadata: date, version, responsible party, sources (GitHub URLs, etc.).
- [ ] **Table of Contents** page numbers are correct after any content changes.

## Phase 6: Sources and traceability

- [ ] Every claim, statistic, figure in the body text has a source attribution or reference number.
- [ ] No orphaned citations like `(Smith et al.)` without a corresponding entry in the bibliography.
- [ ] Bibliography entries are formatted consistently (author, year, title, source, DOI where available).
- [ ] GitHub URLs and external links are current (test a few by pasting into browser).

## Phase 7: Print readiness

- [ ] **Print preview (`Ctrl/Cmd + P`) shows:**
  - Margins set to **None**.
  - **Background graphics** enabled.
  - One page per sheet, no surprise breaks.
  - Footers with page numbers visible at bottom-right.
  
- [ ] **Export to PDF:**
  - Use browser "Save as PDF" (Chrome/Firefox preferred).
  - Verify all pages present and no content cut off.
  - Test the PDF on a different device to confirm rendering.

## Phase 8: Audience and language fit (if multi-audience)

If the report has multiple versions (funder, scientist, clinician):
- [ ] Each version uses the correct vocabulary and depth for the audience.
- [ ] Abbreviations are expanded appropriately (scientists may skip some, clinicians need more).
- [ ] Technical depth matches: a funder version should not have low-level methodological details.
- [ ] All versions are dated consistently (same date, version number).

## Red flags (stop and ask the user)

Stop and ask the user to clarify or approve before sending if you find:

1. **Missing promised section**: the cover or abstract promises "Appendix C — Regulatory Compliance" but it's not in the document.
2. **Conflicting numbers**: budget items add to 1.5M in one place and 1.3M in another.
3. **Outdated content**: a section header says "D.1–5 Bibliographie" but sections D.6–18 also exist (mismatch suggests the doc wasn't updated after restructuring).
4. **Unresolved placeholders**: `[To complete: …]` left in the body text (appendices are OK).
5. **Orphaned graphics**: a figure caption references data that's not in the source, or a table has no explanation.
6. **Encoding errors**: mojibake (corrupted characters), broken special characters, or inconsistent entity encoding.

## Automation tips

If you process many reports, automate these checks:

```bash
# Count figures and tables
echo "Figures: $(grep -o 'Figure&#160;[0-9]\+\|Figure [0-9]\+' report.html | cut -d' ' -f2 | sort -u | wc -l)"
echo "Tables: $(grep -o 'Table [0-9]\+' report.html | cut -d' ' -f2 | sort -u | wc -l)"

# Find orphaned headings (h2/h3 at end of a sheet with no following content)
grep -n '</h[23]>' report.html | tail -5

# List all external links
grep -o 'href="http[^"]*' report.html | sort -u

# Check for common typos (French)
grep -E 'Equipe|Maître|dipoide|Axeaust' report.html
```

Run these before the final delivery to catch low-hanging fruit.
