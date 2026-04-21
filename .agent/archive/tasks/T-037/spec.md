# Task Spec: T-037

## Title
Desktop Codex automation pilot, Portugal first-wave authoring scaffold completion

## Objective
Build on the Portugal prep bootstrap once it exists by turning the lane into a more authoring-ready first-wave surface. The task should convert the research lane into a bounded shortlist and scaffold that makes a later translation pass possible without pretending Portugal is ahead of the current Viet, Tagalog, or active second-pass prep work.

## Allowed write scopes
- .agent/tasks/T-037/**
- .agent/coordination/queue-index.json
- research/language-pipeline/portuguese/**
- content-draft/portuguese/**

## Must not touch
- app/**
- site/**
- ops/**
- docs/operations/**
- release/build/TestFlight files
- existing Viet or Tagalog content as a write surface

## Concrete execution requirement
- preserve a clear prep-only boundary
- leave behind a ranked first-wave shortlist with rewrite flags where needed
- keep the work bounded to a meaningful authoring scaffold rather than runtime wiring or broad multilingual cleanup

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate and require unanimous approval before advancement.
