# Gate 1 Pass 2 Authoring Scaffold Review

- reviewer: Epicurus (`019da7c0-6b08-78e2-a70b-27a9ac27a496`)
Approval: APPROVE
- scope: clarified pre-edit Indonesian scaffold plan

## Findings

- The declared `phrase-source.csv` contract now makes the scaffold concrete instead of thematic, and the combination of all 70 shared baseline rows plus a small Indonesia-specific supplemental set is the right bounded package for making the next translation pass startable.
- The supplemental scope is materially helpful rather than churn-heavy. Ride-hailing pickup flow, payment clarification, toilet, and repair phrases are exactly the Indonesia-specific seams the current research already identifies as high-value and weakly covered by the shared baseline.
- A ranked 30-row `first-wave-priority.csv` is the right size for a starter queue, as long as it is truly translation-ready and every shortlisted row resolves back to `phrase-source.csv` with matching `english_text`.
- Tightening `README.md`, `source-notes.md`, and `research-backlog.md` to route the next pass directly into those two files is the right downstream move and should prevent the next translator from redoing orientation, row selection, or rewrite triage.

## Recommended edits

- Keep the supplemental set deliberately small and explicitly justified so the lane does not sprawl into a second baseline.
- Encode rewrite debt and later-review risk directly in `notes` and `status`, especially for politeness choices, QR and payment wording, medical rows, and any transport-dispute language.
- Keep unresolved questions like address terms and broader colloquial aliasing visible as later-review topics rather than promoting them into the first-wave core by default.
