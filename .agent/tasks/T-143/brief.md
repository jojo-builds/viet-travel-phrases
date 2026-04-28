# T-143 feature brief

## Source
- Orchestrator follow-on after the `T-139` and `T-140` interruption pattern
- Explicit user ask on `2026-04-23` for future self-recovery

## Feature
Build automatic recovery-handoff generation for interrupted meaningful queue tasks so stale worker sessions can be resumed through fresh recovery tasks without waiting for manual orchestrator intervention.

## Intent
- reduce lost time when Codex desktop hits `loading model`, reauthentication, or subagent-delivery drift
- preserve already-landed work instead of restarting big tasks from scratch
- keep the existing queue tool and maintenance lane as the recovery surface, not a separate side system

## Required behavior from the orchestrator direction
- detect meaningful interrupted tasks that have expired ownership and evidence of landed work
- generate a recovery handoff automatically or through one bounded queue-maintenance command
- avoid creating duplicate recovery tasks for the same original task
- leave a clear relationship between the interrupted original task and the generated recovery task

## Product constraints from orchestrator
- this should build on the existing queue tool, queue maintenance, and recovery ledger surfaces
- it should not require the user to manually author recovery task folders when the interruption pattern is recognizable
- it should stay bounded to queue/process tooling and not spill into app feature lanes
