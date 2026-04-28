# Gate 1 Pass 1: Refresh Workflow Review

Approval: APPROVE

- Extending the existing `capture-design-preview.ts` plus `generate-design-board.ts` seam is safer than adding a manual board-only workflow.
- The current generator already carries auditable capture metadata, so the refresh can stay reproducible if the new answer-state fields are added carefully.
- The main workflow risk is interaction timing because same-page swaps and deeper opens happen after the route finishes its initial load.
- A larger blind wait would not be enough; scripted captures should wait for the expected resulting state explicitly.

Must-fix before edits begin:

- If multiple entries reuse `/design-preview/phrase`, the manifest and tiles must record the answer-state id and the scripted interaction recipe or expected resulting state, and the capture step must wait for that resulting state explicitly.
