# Gate 1 Pass 1: Returning-User Honesty

Findings: none for this lane.

The Home `Continue`, `Saved`, and `Practice pool` shelves are gated on resolved local IDs from `LocalUserIntentStore`; the store starts empty, ignores invalid recent IDs, and only saves/toggles valid openable canonical page IDs. I did not see seeded fake recent/saved/practice data in the reviewed paths. Tests cover fresh empty state plus recent/saved/practice persistence behavior.

Approval: APPROVE
