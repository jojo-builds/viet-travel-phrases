# Task Spec: T-036

## Title
Desktop Codex automation pilot, Portugal research and prep-only lane bootstrap

## Objective
Create one additional future-language prep lane only after the current higher-priority Tagalog and Viet follow-ups are already represented in the queue. The goal is a bounded Portugal Portuguese bootstrap with destination-fit research, prep-only constraints, and enough scaffolding to decide later whether a fuller lane is worth pursuing.

## Allowed write scopes
- .agent/tasks/T-036/**
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
- produce durable destination research plus an initial authoring scaffold recommendation
- do not pretend Portugal is a nearer execution priority than the current Viet and Tagalog lanes

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate and require unanimous approval before advancement.
