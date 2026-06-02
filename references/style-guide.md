# Style guide — editorial rules for fast, clear reading

These rules apply to every report the skill produces. The goal is **rapid reading and immediate comprehension**: a busy reader should grasp the essentials in under a minute and find any detail quickly.

## 1. Lead with the essentials

- Always place an **executive summary / abstract** at the very top: 3 to 5 bullet points or a short paragraph stating the purpose, key findings, and main recommendation or conclusion.
- The reader must understand the "so what" before any detail.

## 2. Heading hierarchy

- Use **at most three levels** of headings (`h1` title, `h2` sections, `h3` sub-sections).
- Headings are **informative**, not generic: prefer "Results: adoption up 30%" over a bare "Results".
- One `h1` per document (the report title).

## 3. Paragraphs and sentences

- **One idea per paragraph.** Keep paragraphs to 3–5 sentences.
- Prefer short, direct sentences. Avoid nested subordinate clauses.
- Active voice where possible.

## 4. Lists and tables

- Use **bulleted lists** for enumerations and unordered points.
- Use **numbered lists** for sequences, steps, or ranked items.
- Use **tables** for any comparison across two or more dimensions. Give every table a numbered caption ("Table 1: …").

## 5. Key-point callouts

- Pull critical takeaways into a **callout box** (`<aside class="callout">`): "Key takeaway", "Key point", "Recommendation".
- Use callouts sparingly — one or two per section at most.

## 6. Figures and tables

- Every figure and table gets a **numbered caption** below it ("Figure 1: …", "Table 2: …").
- Reference figures/tables by number in the text.

## 7. Emphasis

- Use **bold** sparingly for the few words that matter most.
- Do **not** use underline (reads as a link) and avoid italics for emphasis (reserve italics for terms, titles, foreign words).
- Never use ALL CAPS for emphasis.

## 8. Numbers, units, dates

- Use a space as thousands separator (12,000 or 12 000), 30% with a space before %.
- Spell out dates clearly (June 1, 2026).
- Be consistent with units and decimals throughout.

## 9. Acronyms and glossary

- Expand each acronym on first use: "artificial intelligence (AI)".
- If there are many domain terms, add a short **glossary** before the annexes.

## 10. References (research reports)

- List references consistently (author, year, title, source).
- Number them and cite by number in the body where relevant.

## 11. Tone

- Neutral, precise, professional. No marketing language, no hype.
- Stay faithful to the source meaning — reformat, don't reinterpret.

## 12. Figure and table numbering — consistency across the document

- **Number continuously** across the entire document: Figure 1, 2, 3… (not 1, 2, 4 — gaps signal missing/moved content).
- **Reference by number** in text ("See Figure 3" or "Table 2 shows…") — never "the figure above" or "below".
- Use consistent phrasing: "Figure N: [descriptive title]" and "Table N: [descriptive title]".
- If a figure or section is removed during consolidation, renumber all subsequent figures/tables to avoid gaps.
- For appendices (Annexes A, B, C…), use separate numbering: "Figure A1:", "Table B3:".

## 13. Final quality checks (before delivery)

Before declaring the report ready for print:

1. **Run the print preview** (`Ctrl/Cmd + P`): verify no overflow flags (red dashed boxes) on any sheet.
2. **Check figure/table continuity**: open the Table of Contents and count: do all figures up to Figure N appear? Are numbers consecutive? (Check especially after major edits or multi-source consolidation.)
3. **Scan for common typos** in figures/tables (especially captions): accents (`Équipe` not `Equipe`), en-dashes (–), and entity encoding issues.
4. **Verify cross-references**: every "See Figure X" must have a corresponding Figure X in the document.
5. **Check headers and footers**: every sheet should have a footer with document title and page number.
6. **Orphaned blocks**: no heading should end a sheet without its body appearing on the same or immediately following sheet. No single-line paragraph at the top of a page.
7. **Source attribution**: every figure, table, statistic must have a caption with source. If no source found during consolidation, mark as `[source: …]` and flag to the user.

If any check fails, correct and regenerate before sending.
