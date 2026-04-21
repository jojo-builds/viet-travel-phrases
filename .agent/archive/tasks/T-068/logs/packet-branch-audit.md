# Packet Branch Audit

Date: 2026-04-20
Task: T-068

## Scope

- Repair the Viet TestFlight execution packet so downstream steps follow the build selected in Step 2 after any retry or resubmit branch.
- Keep the current durable ops truth unchanged unless a direct alignment edit is required.

## Current truth preserved

- Latest installable artifact remains `1.0.0 (3)`.
- Build `1.0.0 (4)` remains the current in-flight preview reference.
- Build `1.0.0 (5)` remains the current in-flight store/TestFlight reference.
- No newer durable install, TestFlight, purchase, restore, restart, or device-proof evidence was found during this task.

## Issue found

- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md` Step 2 correctly owns the retry/resubmit branch.
- After that branch, Step 5 still hard-codes `Attach build 1.0.0 (5) to the internal-testing group.`
- That hard-coded instruction can drift from the build actually selected in Step 2 if the retry path produces a newer store/TestFlight build.

## Bounded fix

- Define the selected preview build and selected TestFlight build inside Step 2.
- Use those selected builds in Step 4 and Step 5 gating text and in the Step 5 attach instruction.
- Leave the historical truth boundary and all non-packet ops surfaces unchanged unless a direct mismatch appears.

## Alignment check

- `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, `TESTING_RUNBOOK.md`, and `ops/apps/viet.json` already preserve the same durable build boundary.
- No additional truth-sync edit is required unless the packet change introduces a contradiction.
