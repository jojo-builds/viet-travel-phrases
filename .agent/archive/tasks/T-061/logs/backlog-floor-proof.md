# Backlog floor proof

## Source
- `E:\AI\SpeakLocal-App-Family\.agent\coordination\queue-index.json`
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-034\state.json`
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-035\state.json`
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-062\state.json`
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-063\state.json`
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-064\state.json`
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-065\state.json`
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-066\state.json`
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-067\state.json`
- last repaired at `2026-04-19T16:15:58.673498-05:00`

## Active meaningful queued tasks after proof
- `T-034` - `apple_release_testflight`
- `T-035` - `shared_phrasebook_truth`
- `T-062` - `german_prep_lane`
- `T-063` - `korean_prep_lane`
- `T-064` - `indonesia_prep_lane`
- `T-066` - `website_content_conversion`
- `T-067` - `website_starter_exports`
- `T-065` - `future_language_content_drafts`

## Queue stats after repair
```json
{
  "queuedCount": 8,
  "reclaimableCount": 0,
  "inProgressCount": 0,
  "blockedCount": 20,
  "draftCount": 1,
  "recentlyCompletedCount": 38
}
```

## Floor conclusion
- The post-proof active queue still exceeds the required minimum of 6 meaningful non-overlapping active tasks.
- The queued state files for `T-034`, `T-035`, and `T-062` through `T-067` all remain in queued lifecycle state and declare `automation.taskClass: "meaningful"` with `automation.proofTask: false`.
- Those queued tasks also retain the distinct write locks listed above within the queued claimable set, so the restored meaningful queued backlog floor remains non-test and non-overlapping for active queue selection.
- Blocked tasks elsewhere in the queue still reuse some of those locks, so this log proves the queued claimable floor only, not total lock uniqueness across every non-active task.
- Some of those queued tasks target `prepared-next` rather than `live`, so this log proves the queued backlog floor, not a fully live-only queue.
- The four proof-worker tasks (`T-030` through `T-033`) ended blocked, but the backlog floor was restored without seeding proof/synthetic tasks.
