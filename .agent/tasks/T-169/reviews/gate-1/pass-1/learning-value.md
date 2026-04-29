# Gate 1 Pass 1 - Learning Value

Reviewer: Ptolemy  
Lane: learning value and anti-generic-trivia risk

Findings:

- Blocking: `phrase_chunk_rebuild` includes incorrect token glosses that would teach wrong Vietnamese. Examples included `tới` glossed as `I / me`, `thế` as `i`, `công` as `gate`, `ATM` as `the`, and `Wi-Fi` as `is`.
- Blocking: `viet-practice-chunks-health-1` answers `Nhà thuốc ở đâu?`, but uses `health-pharmacy-clearer-piece-*` chunks that rebuild `Nhà thuốc gần nhất ở đâu?`.
- The deck is otherwise clearly phrase-sourced rather than generic travel trivia: 70 items, 14 scenarios, 7 question types, anchored source IDs, source-page actions, and generally useful traveler feedback.

Approval: BLOCK

