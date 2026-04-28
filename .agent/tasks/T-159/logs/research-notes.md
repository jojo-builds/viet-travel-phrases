# T-159 Research And Asset Notes

Run date: 2026-04-28  
Worker session: `eccee964-ab34-4e92-880c-20595eaecfd6`

## External sources used

- Reddit language-learning pain points: https://www.reddit.com/r/languagelearning/comments/1lze50r/what_are_your_biggest_problems_with_language/
- Reddit Duolingo repetition thread: https://www.reddit.com/r/duolingo/comments/1g3whea/duolingo_repetitive/
- Reddit Duolingo stall thread: https://www.reddit.com/r/duolingo/comments/1rrsqpz/is_it_just_me_or_does_duolingo_eventually_just/
- Reddit streak discussion: https://www.reddit.com/r/languagelearning/comments/1hd7t0e/too_many_apps_rely_on_streaks/
- Retrieval practice review: https://link.springer.com/article/10.1007/s10648-021-09595-9
- Spacing plus retrieval review: https://www.nature.com/articles/s44159-022-00089-1
- Duolingo spaced repetition article: https://blog.duolingo.com/spaced-repetition-for-learning/
- Apple feedback guidance: https://developer.apple.com/design/human-interface-guidelines/feedback
- Gamification misuse case study: https://arxiv.org/abs/2203.16175
- Negative gamification effects mapping study: https://arxiv.org/abs/2305.08346

## Source summaries

- Reddit threads are anecdotal but consistently point at repetition fatigue, streak/gamification pressure, weak feedback, and practice that does not transfer to real communication.
- Learning-science sources support retrieval practice, feedback, and spacing as the core retention loop.
- Product-design sources support contextual, accessible feedback and caution against points/badges/leaderboards becoming the user's real goal.

## Asset inventory commands

```bash
jq '{metadata, scenarioCount:(.scenarios|length), familyCount:(.families|length), phraseRows:(.phrases|length)}' native-ios/Resources/viet-phrase-catalog.json
jq '{pageCount:(.pages|length), categoryIDs: ([.pages[]?.categoryIDs[]?] | unique), phraseRows: ([.pages[]?.sections[]?.phrases[]?] | length), breakdownTokens: ([.pages[]?.sections[]?.breakdown[]?] | length)}' native-ios/Resources/viet-authored-listing-pages.json
jq '{metadata, requiredCount:(.required|length), missingCount:(.missing|length), resolvedCount:([.required[] | select(.resolved == true)] | length)}' native-ios/Resources/viet-authored-audio-audit.json
find native-ios -iname '*mascot*' -o -iname '*character*' -o -iname '*guide*'
```

## Asset notes

- `content-draft/viet/viet-phrase-catalog.json` was named in the task spec but is absent in this checkout.
- The live generated native catalog is `native-ios/Resources/viet-phrase-catalog.json`, with metadata source `../../content-draft/viet/phrase-source.csv`.
- Native asset search found no mascot/character asset; two audio filenames include the word `guide`, but they are phrase audio, not mascot assets.
