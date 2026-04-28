# Gate 3 Pass 2: Source Truth

Findings:

- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` still said `LanguagePacks/viet/` contained only `.gitkeep`, contradicting T-165 and the current tree.
- `docs/design/homepage-research/README.md` still said the SQLite runtime/read path was generated but not bundled, contradicting the T-165 DEBUG bundled fixture/read-path proof.

Required correction before approval: keep docs aligned with the current split: production runtime remains JSON-backed, while the T-165 SQLite fixture/report is bundled for DEBUG validation.

Approval: BLOCK
