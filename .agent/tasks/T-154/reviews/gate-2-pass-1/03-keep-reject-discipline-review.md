CHANGES_REQUESTED

- The triage ledger underreports `viet-transport-destination`: it omits kept rows that remain visible in the sidecars, including anchor `taxi-1`, `taxi-7`, and `transport-premium-wait-here`.
- The ledger also underreports `viet-health-doctor` by failing to record core keep `problems-6` even though both sidecars anchor that hub on it.
- The bathroom hub notes and ledger say the keep set stayed tightly bounded, but the sidecars also retain `v500-dire-navi-where-is-the-nearest-restroom` and `v500-airp-bord-arri-where-are-the-restrooms`, which reads as overlap creep against the stated boundary.
- The harvest notes overstate saturated-row discipline because they do not clarify that the avoided rows still carry legacy support load from earlier passes.

Gate recommendation: tighten the retained bathroom scope and rewrite the ledger / harvest notes so every kept row on the targeted hubs is explicitly and honestly accounted for.
