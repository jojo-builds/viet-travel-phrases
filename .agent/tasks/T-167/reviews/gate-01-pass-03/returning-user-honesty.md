# Gate 1 Pass 3: Returning-User Honesty

Findings: None.

The Home returning-user shelves are gated by resolved local state: `Continue` from `recentPageIDs`, `Saved` from `savedPageIDs`, and `Practice pool` from `practicePageIDs` in `HomeView.swift`. Fresh stores start empty and new saved/practice/recent writes validate against `PhraseCatalog.isOpenablePageID` in `LocalUserIntentStore.swift`. Save/practice UI on phrase pages is an honest affordance backed by store state, not prefilled personalization. `git diff --check` passed.

Approval: APPROVE
