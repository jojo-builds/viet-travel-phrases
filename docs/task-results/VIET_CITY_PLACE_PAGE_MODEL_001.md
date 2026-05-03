# VIET_CITY_PLACE_PAGE_MODEL_001 Result

Status: done
Date: 2026-05-03
Lane: Research / Product Strategy

## Commit Hash

Report commit: `ac4b355d4a381f85ae1dc2a7bd45ddcf454214e2`

Receipt commit: recorded in final chat after this receipt is committed.

## Report Path

- `docs/content-audits/viet-city-place-page-model-001/README.md`

## Scope Proof

Docs-only work completed.

Changed by this task:

- `docs/content-audits/viet-city-place-page-model-001/README.md`
- `docs/task-results/VIET_CITY_PLACE_PAGE_MODEL_001.md`

Explicitly not edited by this task:

- app code
- generated native resources
- `content-draft/**`
- SQLite resources
- audio resources
- native Swift files
- validator scripts
- the pre-existing untracked `docs/design/homepage/visual-refresh-v3/`

Pre-existing unrelated dirty worktree items were left untouched.

## Research And Audit Checks

Read-only validation:

```text
node native-ios/scripts/validate-viet-city-library.js
City library OK: 750 pages, 638 beginner, 107 intermediate, 5 advanced
```

Read-only source inventory:

```text
phrase 601
place 149
```

Read-only place subcategory inventory:

```text
7 arrivals-routes
15 food-coffee
78 landmarks-attractions
35 neighborhoods-streets
14 shopping-markets
```

Public grounding sources included Vietnam Tourism for Bà Nà Hills, Da Nang, Hanoi, and Hanoi Old Quarter; Da Nang Fantasticity; Michelin Guide for Nén Danang; Nén Danang's official site; and Vietnam Tourism's Nén Danang Green Star note.

## Top Findings

1. The current city-library model is structurally valid but too flat: it has only `phrase` and `place`, so it cannot cleanly express city, restaurant, dish, category, or relationship/person page jobs.
2. The current validator passes while semantic quality issues remain, so the next validator needs page-kind-aware rules instead of only structure checks.
3. Restaurant/cafe pages can inherit landmark copy. Nén Đà Nẵng currently reads like a landmark page instead of a reservation/menu/dietary/payment restaurant page.
4. Place pages overgeneralize city-level copy: all 149 place pages use the broad "before you visit [city]" pattern, and many repeat the same place-brief prefix.
5. Some generated breakdowns treat English/proper-name fragments as if they were useful Vietnamese learning chunks, and filler phrase families such as `eat-near-*` and `atm-*` are too often promoted to article-like pages.

## Fold-In Recommendations

Adopt now:

- Use the seven-kind taxonomy: `phrase`, `place`, `city`, `restaurant`, `dish`, `category`, and `relationship/person`.
- Treat city and category pages as Browse collection surfaces, not phrase-detail articles.
- Gate relationship/person guidance away from place, restaurant, dish, and category pages.

Create task card:

- Add page-kind-aware city/place templates and validators before regenerating city resources.
- Rebalance restaurant and dish anchors city by city so Da Nang, Hanoi, HCMC, Hoi An, and Hue are not over-dependent on fine-dining or famous-name anchors.
- Define Browse collection copy and shelf rules for city/category surfaces.

Hold:

- Full resource regeneration and app UI rendering changes until the source schema and validator rules are accepted.

Reject:

- One shared article template for every city phrase and named place.
- Fake proper-name breakdowns.
- Restaurant pages that read like landmark pages.

Needs Jojo decision:

- Whether validator/template repair should happen before expanding the city library further.
- Whether Da Nang food should lead with everyday dishes and seafood before fine-dining examples.
- Whether restaurant pages should include reservation/payment/dietary phrase bundles in the first implementation pass.

## Example Outlines Included

- Bà Nà Hills as a `place` page.
- Da Nang as a `city` page.
- Hanoi Old Quarter as a neighborhood-style `place` page.
- Nén Đà Nẵng as a `restaurant` page.

## Recommended Next Task Prompt

```text
Open /Users/jojolim/Developer/products/speaklocal/app-family.
Read docs/content-audits/viet-city-place-page-model-001/README.md.
Create and implement a docs/content-data task that adds page-kind-aware city/place source schema, generator templates, and validator checks for phrase, place, city, restaurant, dish, category, and relationship/person pages.
Do not edit native Swift UI in this task.
Regenerate only the approved city/place resources after validators catch the known wrong-template failures.
Commit when done and write the result.
```
