# Gate 1 Pass 1 Authoring Scaffold Review

- reviewer: Epicurus (`019da7c0-6b08-78e2-a70b-27a9ac27a496`)
Approval: BLOCK
- scope: untouched Indonesian lane before scaffold creation

## Findings

- The lane is still missing the two concrete scaffold outputs the task contract requires: `content-draft/indonesian/phrase-source.csv` and `content-draft/indonesian/first-wave-priority.csv`.
- Because the lane stops at research and posture notes, the next translation task would still have to redo row selection, rewrite triage, and first-wave ranking.
- A strong package here must do more than list good ideas. `phrase-source.csv` needs row-level seam coverage with stable IDs, explicit rewrite and defer markers, and review-visible notes. `first-wave-priority.csv` needs a ranked, translation-ready queue that settles which Indonesia-specific supplementals are first-wave versus later.

## Recommended edits

- Create `content-draft/indonesian/phrase-source.csv` as the reusable row-level Indonesian source scaffold for the shared seam.
- Create `content-draft/indonesian/first-wave-priority.csv` as a ranked translation-ready queue with explicit decisions on payment, ride-pickup, repair, and supplemental Indonesian rows.
- Tighten `README.md`, `source-notes.md`, and `research-backlog.md` so the next translation task points at those concrete files instead of rebuilding the scaffold from scratch.
