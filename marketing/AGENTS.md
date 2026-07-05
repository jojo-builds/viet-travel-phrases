# SpeakLocal Marketing Lane

This folder is the marketing-agency lane for SpeakLocal Vietnam. Use it for positioning, campaigns, App Store copy, ASO, screenshots, video planning, creative briefs, launch plans, channel strategy, and measurement.

## Product Truth

- The shipping app is the native iOS app under `native-ios/`.
- Treat `main` as the current product truth unless Jojo explicitly says a feature branch is the test target.
- Do not use Expo, React Native, Metro, or old web app surfaces as marketing truth.
- Do not invent app features, screens, audio, AI behavior, subscription terms, claims, or language coverage that are not present in the native app or clearly marked as future-facing.
- SpeakLocal is not Google Translate, a general AI translation box, or a school-style language course. The product promise is a curated Vietnam travel companion: food and menu discovery, places and things to do, culture-aware phrase pages, playable audio, browse/search discovery, Messages-style guided conversations, and beginner-friendly Vietnam trip support.
- Runtime app copy and screenshots should not imply arbitrary AI translation unless Jojo explicitly changes the product direction.

## Audience Lens

Primary audience:

- English-speaking travelers who are excited to go to Vietnam and want the country to feel more vivid and less intimidating before they arrive.
- First-time or early-stage Vietnam travelers who want curated food, menu, place, culture, and phrase guidance instead of having to invent every search or prompt themselves.
- People who want to see useful Vietnam travel situations, hear the Vietnamese, save/practice what matters, and use the app during the trip without trying to become fluent.

Marketing should make the app feel:

- practical;
- premium and native to iOS;
- friendly but adult;
- useful before and during the trip;
- positive, curious, and discovery-led;
- more curated and sensory than a generic phrase dump because it connects traveler moments to places, food, culture, images where available, and playable audio.

## Work Areas

Use this lane for:

- App Store name, subtitle, keywords, description, promotional text, and release notes;
- App Store screenshot storyboards and source screenshot plans;
- app preview video scripts, shot lists, captions, and edit notes;
- paid ad copy and creative briefs for TikTok, Instagram, YouTube Shorts, Reddit, Google, and Apple Search Ads;
- organic content calendars and short-form video concepts;
- landing page and website copy;
- positioning, customer segments, hooks, objections, and offer testing;
- competitor and category research;
- review mining, app positioning research, and ASO research;
- launch checklists, beta/tester messaging, and retention ideas;
- measurement plans, experiment logs, and ROI assumptions.

For work that spans several of these areas, create a project folder under `marketing/projects/<project-slug>/`.

## Required Marketing Output Shape

Every campaign, creative, or App Store asset should state:

- audience segment;
- user problem or travel moment;
- hook;
- channel;
- offer or CTA;
- required app evidence, screenshots, or screen recordings;
- claim risk or feature dependency;
- success metric;
- next action.

Do not leave a marketing idea as vibes only. Make it executable.

## Research Rules

- For App Store metadata, screenshots, app preview video specs, privacy labels, or submission requirements, verify against current official Apple documentation before treating a spec as final.
- For paid channel specs, verify current platform requirements before final export.
- Research notes belong in `marketing/research/`.
- Durable recommendations should cite sources or name the app evidence used.

## Screenshot And Video Rules

- Screenshots and videos should use the current native iOS build, preferably from `main` after it has been installed or validated.
- Do not use mockups for final App Store or ad creative unless clearly labeled as drafts.
- When requesting app screenshots from another agent, specify exact routes, device, state setup, and crop/orientation.
- App Store screenshot storyboards belong in `marketing/screenshots/`.
- App preview video scripts, shot lists, and edit notes belong in `marketing/video/`.
- Raw large exports should normally stay out of git unless Jojo explicitly wants them committed.

## Copy Rules

- Keep copy specific to travel moments, not generic language-learning claims.
- Prefer simple hooks like "Land in Vietnam with the phrases you need first" over vague claims like "Learn Vietnamese fast."
- Keep the emotional center positive: discovery, preparation, food, places, culture, and confidence. Avoid worry-led, fear-led, or crisis-first framing.
- Do not overpromise fluency, translation completeness, or emergency/legal/medical reliability.
- Vietnamese phrase claims should match actual app content and playable audio when possible.
- If a claim depends on an unreleased feature, mark it `FUTURE / DO NOT PUBLISH`.

## Parallel Work

- Marketing work can usually happen directly in `marketing/` on `main` because it does not touch app code.
- If a marketing task needs app code, screenshots automation, or native UI changes, create or use the appropriate feature branch/worktree and follow the root `AGENTS.md` feature workflow.
- If multiple marketing campaigns are being developed in parallel and may conflict, use subfolders under `marketing/campaigns/` instead of separate app worktrees.

## Suggested Workflow

1. Read `marketing/README.md`, this file, and current app/product docs linked from the root `AGENTS.md`.
2. Identify the marketing job: App Store, paid ad, organic content, launch plan, screenshot/video, ASO, or research.
3. Check the current native app truth before making claims.
4. Produce a brief, draft, script, or plan in the matching subfolder.
5. Mark anything unverified as `NEEDS_APP_PROOF`, `NEEDS_SOURCE`, `NEEDS_SCREENSHOT`, or `FUTURE / DO NOT PUBLISH`.
6. Close with changed files, assumptions, sources used, and next steps.
