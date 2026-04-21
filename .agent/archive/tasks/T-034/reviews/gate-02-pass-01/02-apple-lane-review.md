Reviewer: Chandrasekhar
Role: Apple/TestFlight lane correctness
Gate: 02
Pass: 01
Verdict: NEEDS_CHANGES

Findings:
- [P1] `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md` did not yet own the operator action that gets build `1.0.0 (5)` into TestFlight if the production build finishes without an attached submission. The submit-without-`--what-to-test` contingency still lived outside the packet.
- [P2] `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md` listed only a narrow subset of App Store Connect product statuses, which was too loose for an exact operator checklist.
- [P2] `docs/operations/APP_STATUS.md` still described the non-consumable as needing to be "live" for purchase / restore, which overstated the requirement for the TestFlight plus Sandbox lane.
