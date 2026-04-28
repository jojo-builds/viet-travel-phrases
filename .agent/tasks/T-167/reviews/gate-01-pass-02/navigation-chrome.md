# Gate 1 Pass 2: Navigation And Chrome

Finding: Back-swipe preview reveals unrelated root pages.

During a back drag, `pageOpacity` returns 1 for every mounted route. Since Home, Saved, and Browse are all mounted in the ZStack, and Browse is declared above Home/Saved, swiping back from a detail/home-root or from Browse/Saved can reveal the wrong page behind the current page instead of the actual back destination. This breaks the browser-like back/forward behavior T-167 is preserving; the back path needs the same destination-specific visibility treatment that forward preview already has.

Pass 1 blockers are fixed at the control level: dock items now perform route actions and use `selectedDockItem`, and the search home icon now calls `openHome()` instead of history-close.

Review scope was read-only; I inspected diffs/files and did not run builds or tests.

Approval: BLOCK
