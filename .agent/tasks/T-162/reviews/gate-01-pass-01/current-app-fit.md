# Gate 1 Pass 1: Current App Fit

Blocking findings:

- `docs/design/practice-quiz-concepts/prototype.html` shows bottom chrome as `Home / Saved / Browse`, but current native `AppChrome.primaryDockItems` is `Home / Browse / Saved`. For a current-app-fit packet, the prototype should mirror the live shell order.
- The prototype's Pronoun Coach prompt uses `Xin chào cô` and labels it as authored pronoun evidence, but current authored listing truth anchors the older-woman cue in `Bạn khỏe không?` relationship forms, not an authored `Xin chào cô` page/prompt. This risks handing off an unanchored practice prompt despite the pre-live plan's authored-evidence constraint.

Approval: BLOCK
