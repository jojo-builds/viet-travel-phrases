# Gate 1 Pass 1: Navigation And Chrome

Finding 1: Bottom dock is still decorative.

The static bottom chrome now exposes Home, Browse, and Saved on home/article routes, but each item is rendered as a plain `AppShellDockItem` with no route action, and Home is selected unconditionally. With T-167 making Home a real root and Browse a distinct phrase/catalog state, the primary chrome cannot navigate among those states and visually marks Home even on browse/detail screens.

Finding 2: Search house icon closes to history.

The search bottom chrome shows a house icon, but it calls `closeSearch()`, which delegates to `goBack()`. If search was opened from browse or a detail page, tapping the house returns there instead of Home, so the Home/search transition depends on history rather than the control's meaning.

Approval: BLOCK
