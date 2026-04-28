# T-138 feature brief

## Source
- Orchestrator synthesis from the user's current review pain point
- Figma research + existing dashboard capture workflow

## Feature
Build a visual screen board / screenshot contact-sheet workflow so the current app screens can be reviewed in one place without needing to click around Expo for every comparison.

## Intent
- give the user a single-shot visual board of what currently exists
- use current dashboard preview and existing capture seams instead of inventing a second fake app
- make the result useful immediately even before Figma is connected
- leave the output easy to move into Figma later if desired

## Required behavior from the orchestrator direction
- show current screens/states in one artifact the user can scan quickly
- keep this separate from the live app feature code
- avoid expensive native builds
- use existing preview/capture infrastructure where possible
- document how to refresh the board when new features land

## Product constraints from orchestrator
- this task must stay disjoint from the active Liquid Glass UI write surface
- it should use a separate visual-board branch/worktree
- it should create a durable review artifact plus a refresh workflow, not just one one-off screenshot dump
- this is a meaningful task and should use the full 3-gate / 4-reviewer contract
