# Gate 1 Pass 1: Answer State Coverage Review

Approval: APPROVE

- The current board only captures one static `/design-preview/phrase` tile, so adding interaction-aware phrase captures is the right way to cover the required default, hero-swap, and deeper-open states.
- The planned state set matches the `T-144` interaction contract: same-page `Swap hero`, deeper `Open page`, and a search-related state from the current seam.
- Regrouping the board around shell/search, answer states, and deeper linked states matches the task spec better than the current source-only grouping.
- The board also needs stronger proof metadata because route plus timestamp alone does not explain which answer state was actually captured.

Must-fix before edits begin:

- Anchor each new phrase tile to a distinct answer-state id and capture recipe rather than treating multiple `/design-preview/phrase` screenshots as generic route duplicates.
