APPROVED

This revision fixes the main correctness risk for the Apple lane: one repo-owned packet becomes the only literal operator checklist, while `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, and `LATEST_VALIDATION.md` stay status/evidence-only instead of competing runbooks. It also preserves the key purchase/restore truth boundaries: `1.0.0 (3)` remains the latest installable build, builds `(4)` and `(5)` remain in-flight references only, and there is still no durable App Store Connect/TestFlight purchase, restore, or device-proof evidence beyond the `2026-04-16` snapshot.

Keep the packet explicit that internal preview is preflight-only and TestFlight plus Sandbox is the durable purchase/restore lane.
