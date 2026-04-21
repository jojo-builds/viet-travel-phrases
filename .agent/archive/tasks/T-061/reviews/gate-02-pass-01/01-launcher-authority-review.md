NOT APPROVED

- `E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py` still honored the legacy `runtimeReviewPathProven` fallback instead of repo-level `productionReady` alone.
- Candidate ordering still let `selectionOrder` outrank reclaimable-vs-queued group priority, which conflicted with the queue docs.
- Direct helper execution from the compatibility alias root was still accepted, which left `Invoke-SpeakLocalQueueTool` advisory instead of authoritative.
