# Task Spec: T-034

## Title
Desktop Codex automation pilot, Viet TestFlight readiness and purchase-proof execution packet

## Objective
Strengthen the Viet release-execution lane by turning the existing preview-build, App Store Connect, and device-proof truth into one operator-ready execution packet. The task should reduce handoff friction for the next real human device pass without claiming that the pass itself already happened.

## Allowed write scopes
- .agent/tasks/T-034/**
- .agent/coordination/queue-index.json
- docs/operations/**
- ops/apps/viet.json

## Must not touch
- app/** as a write surface
- site/**
- content-draft/** as a write surface
- generated release artifacts

## Concrete execution requirement
- reconcile the current preview-build, TestFlight, App Store Connect, and purchase/restore proof prerequisites into one exact checklist
- tighten blocked-vs-ready wording so no release state is overstated
- leave a crisp operator sequence for the next real iPhone pass

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate and require unanimous approval before advancement.
