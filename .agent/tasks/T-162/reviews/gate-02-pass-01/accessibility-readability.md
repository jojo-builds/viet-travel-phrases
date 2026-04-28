# Gate 2 Pass 1: Accessibility / Readability

BLOCK. The prototype is close, but the rendered quiz states do not pass mobile readability/non-overlap.

Blocking findings:

- In `docs/design/practice-quiz-concepts/prototype.html`, the bottom chrome visually overlaps the main quiz CTA. `Choose an answer` is partially hidden, and after feedback the `Next prompt` button plus mascot copy fall behind the Home/Browse/Saved dock/search island.
- Feedback-expanded quiz states do not fit the fixed, overflow-hidden phone frame. There is no scroll/reflow fallback, so continuation controls and lower content are clipped or covered.
- The red prompt labels and primary CTA text are slightly under WCAG AA normal-text contrast against white, about `4.34:1`; use a darker red or larger text.

Tap targets and choice wrapping are otherwise mostly reasonable.

Approval: BLOCK
