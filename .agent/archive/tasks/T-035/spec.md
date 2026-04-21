# Task Spec: T-035

## Title
Desktop Codex automation pilot, shared phrasebook source seam audit for active prep lanes

## Objective
Run one bounded audit across the shared English source seam that feeds the active prep lanes, focusing on rows repeatedly flagged in Italy, Japan, Turkey, Thailand, Spain, France, and Tagalog work. The task should tighten ambiguous or traveler-awkward English source wording where that improves downstream translation quality, while preserving lock discipline and avoiding runtime wiring.

## Allowed write scopes
- .agent/tasks/T-035/**
- .agent/coordination/queue-index.json
- docs/LANGUAGE_PREP_WORKFLOW.md only if the audit exposes a durable shared rule worth codifying
- templates/** only if a bounded shared source artifact truly needs correction
- content-draft/** only for a minimal shared-source reference surface explicitly justified in the result

## Must not touch
- app/**
- site/**
- ops/**
- docs/operations/**
- release/build/TestFlight files

## Concrete execution requirement
- focus on a meaningful bounded set of repeated high-friction source rows, not a broad rewrite spree
- leave behind exact before/after reasoning and the downstream lanes helped
- preserve honest notes where a shared source line should stay unresolved pending expert review

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate and require unanimous approval before advancement.
