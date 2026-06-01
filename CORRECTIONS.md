# Corrections à apporter — audit du skill `report-formatter`

Audit réalisé le 2026-06-01. Liste des écarts relevés entre les exemples (qui
font foi) et le reste du skill, classés par sévérité.

## Tableau des corrections

| # | Sévérité | Zone | Problème constaté | Correction proposée | État |
|---|----------|------|-------------------|---------------------|------|
| 1 | 🔴 Critique | `templates/professionnel.html`, `recherche.html`, `dossier-scientifique.html` | Les 3 templates utilisent encore l'ancien modèle `class="page"` en flux continu : aucun `.sheet`, pas de page de garde, pas de sommaire, pas de pied de page. Non imprimable en A4. | Reconstruire les 3 templates sur le modèle `.sheet` (cover + `.sheet--toc` + `.sheet__footer`), avec `report.css` et `paginate.js` inline, à l'image des exemples. | ☐ |
| 2 | 🔴 Critique | `templates/dossier-scientifique.html` | Sommaire latéral `toc-side` qui contredit le modèle `.sheet--toc` documenté dans `references/pagination.md`. | Supprimer `toc-side` et adopter la feuille de sommaire `.sheet--toc` cliquable et auto-numérotée. | ☐ |
| 3 | 🟠 Haute | `assets/report.css` + `examples/*.html` | CSS recopié intégralement dans chaque exemple (~1600 lignes ×3) et déjà divergent : padding `16mm` vs `15mm`, corps `15px` vs `14.5px`, couleurs d'accent différentes. Corriger un bug = 3 éditions manuelles. | Désigner `assets/report.css` comme source unique de vérité et soit (a) documenter la procédure de ré-inline, soit (b) ajouter un petit script de build qui inline le CSS dans les exemples. | ☐ |
| 4 | 🟠 Haute | `assets/report.css` | Classe orpheline `.cover-divider` définie mais jamais utilisée ; les exemples utilisent `.cover-accent-band`. Vestige d'un renommage incomplet, trompeur. | Renommer/aligner sur `.cover-accent-band` et retirer la définition morte. | ☐ |
| 5 | 🟠 Haute | `assets/report.css` | Classe orpheline `.glossary` définie mais jamais instanciée dans un template ou exemple. | Soit l'instancier dans un template, soit la retirer du CSS. | ☐ |
| 6 | 🟡 Moyenne | `SKILL.md` | `--mode layered` mentionné (ligne ~47) mais pas formalisé à côté des valeurs `--audience`. Ambiguïté entre `--mode` et `--audience`. | Documenter explicitement `--mode layered|audience` et son interaction avec `--audience`. | ☐ |
| 7 | 🟡 Moyenne | `references/pagination.md` | Le guide donne un padding de feuille `16mm 18mm 12mm`, mais les exemples génome utilisent `15mm 17mm 11mm`. Variante non documentée. | Harmoniser la valeur de padding entre le guide et les exemples (une seule référence). | ☐ |
| 8 | 🟢 Basse | global | Aucun template/exemple en anglais (acceptable : le skill est francophone par défaut). | Optionnel : prévoir un jeu anglophone si besoin de réutilisation hors FR. | ☐ |

## Points sains (aucune action requise)

- Architecture du skill conforme aux conventions Claude Code (SKILL.md / references / assets / templates / examples).
- `paginate.js` et `report.css` parfaitement cohérents : toutes les classes référencées par le JS existent dans le CSS.
- Les 3 exemples sont propres et auto-suffisants (CSS + JS inline, cover + TOC + footers).
- Références complètes, sans contradiction de fond ; `LICENSE` MIT présente ; français cohérent partout.
