# Gate 2 Pass 1 - Answer-Page UX Review

- Verdict: `BLOCK`

## Findings

- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\lib\vietAnswerPagePreview.ts:526-533` uses repair-page implied-question copy that reads like internal schema language (`when I need repair`) instead of a traveler question.
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\lib\vietAnswerPagePreview.ts:492-510` and `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\PhraseProductPrototype.tsx:1590-1597` leave the local-reality framing inconsistent by populating practical pages from `what-to-show` while the component still presents a fixed `Local reality` explainer.
- `E:\AI\SpeakLocal-App-Family-worktrees\liquid-glass-native\app\components\preview\PhraseProductPrototype.tsx:456-467`, `:1061-1088`, `:1513-1516`, and `:1647-1677` leak preview/sample wording into the traveler UI and can show follow-up headings with no real destination.

## Rationale

The AI-shaped answer-page structure is close, but the current visible copy still exposes prototype scaffolding in a few important states. Gate 2 should not advance until the fallback language feels fully product-facing and the adaptive local-reality lane matches the page-specific content.

## Advancement

Gate 2 should not advance yet.
