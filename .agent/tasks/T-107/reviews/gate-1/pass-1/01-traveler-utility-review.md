Findings
- None. The planned direction is traveler-useful and matches the current model: it keeps `scenario -> family -> phrase row` intact, adds a sidecar relation layer instead of a graph DB, and focuses the sample on practical forward-tap behavior.

Risks
- If the optional CSV linkage columns stay sample-only, they need to remain strictly optional and documented as non-breaking so the existing Viet pack does not require backfill or behavior changes.
- The docs should make clear that the sample set is proving the handoff shape, not redefining runtime truth for the full library.

Approval: APPROVE
