# Gate 2 Pass 3: Accessibility / Readability

Judgment: BLOCK.

Blocking findings:

- Bottom chrome overlap is still present in `docs/design/practice-quiz-concepts/prototype.html`. In a 390x844 WKWebView render, chrome starts at y=795; `Choose an answer` intersects it before selection on prompts 1/4 at y=750-798, prompt 2 at y=776-824, and prompt 3 at y=769-817.
- Feedback text itself no longer clips into the chrome, but after selection the mascot/progress panel still collides with the chrome: prompt 2 panel y=775-863 and prompt 3/4 panel y=768-856 against chrome y=795-853. The `Next prompt` / `Complete session` button starts below the visible safe area and requires scrolling.

Non-blocking checks: red foreground contrast is acceptable; English choice details are hidden before selection and reveal only after answering.

Approval: BLOCK
