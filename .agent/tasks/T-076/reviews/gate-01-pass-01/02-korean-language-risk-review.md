Role:
Reviewer 2 - Korean language risk

Gate:
Gate 1

Scope reviewed:
`E:\AI\SpeakLocal-App-Family\.agent\tasks\T-076\spec.md`
`E:\AI\SpeakLocal-App-Family\.agent\tasks\T-076\state.json`
`E:\AI\SpeakLocal-App-Family\content-draft\korean\source-notes.md`
`E:\AI\SpeakLocal-App-Family\content-draft\korean\phrase-source.csv`
`E:\AI\SpeakLocal-App-Family\content-draft\korean\first-wave-priority.csv`
`E:\AI\SpeakLocal-App-Family\research\language-pipeline\korean\SOUTH-KOREA-TRAVEL-RESEARCH.md`

Findings:
- The source notes are honest about Korean politeness posture, script/pronunciation handling, and the need to keep medical, emergency, and payment wording under explicit review.
- The first-wave ranking is sensible for a bounded pass: it front-loads excuse-me, thanks, transit, payment, reservation, and repair phrases before lower-value small talk.
- The risk flags are visible rather than hidden. `service-wording-review`, `transit-review`, `payment-review`, `food-review`, and `expert-review-medical` make the remaining Korean-sensitive rows easy to defer without pretending they are settled.
- The current setup is strong enough to begin a bounded translation pass because the English source wording has already been Korea-fit rewritten where needed, and the unresolved rows are clearly labeled.

Approval:
APPROVE
