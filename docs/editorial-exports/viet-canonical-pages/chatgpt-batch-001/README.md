# Viet ChatGPT Editorial Batch 001

This packet gives ChatGPT 5.5 Pro enough current page context to fill deterministic editorial patch rows later.

The repo remains the source of truth. This batch does not import content, create pages, generate audio/images, or touch native UI.

## Selected Pages

- 1. `viet-phrase-city-hanoi-place-bun-cha-huong-lien` / `city-hanoi-place-bun-cha-huong-lien` - undefined (restaurant, active_review)
- 2. `viet-phrase-city-hanoi-place-pho-bat-dan` / `city-hanoi-place-pho-bat-dan` - undefined (restaurant, active_review)
- 3. `viet-phrase-city-hoian-place-cao-lau-city` / `city-hoian-place-cao-lau-city` - undefined (dish_identity, active_review)
- 4. `viet-phrase-city-hue-place-bun-bo-city` / `city-hue-place-bun-bo-city` - undefined (dish, active_review)
- 5. `viet-phrase-city-danang-place-ba-na-hills` / `city-danang-place-ba-na-hills` - undefined (journey_place, reference_completed)
- 6. `viet-phrase-city-danang-place-dragon-bridge` / `city-danang-place-dragon-bridge` - undefined (place_navigation, active_review)
- 7. `viet-phrase-city-danang-place-marble-mountains` / `city-danang-place-marble-mountains` - undefined (place_journey, active_review)
- 8. `viet-phrase-city-danang-place-son-tra` / `city-danang-place-son-tra` - undefined (place_navigation, active_review)
- 9. `viet-phrase-city-danang-place-bach-dang-street` / `city-danang-place-bach-dang-street` - undefined (street_pronouncer, active_review)
- 10. `viet-phrase-city-danang-place-nguyen-van-linh-street` / `city-danang-place-nguyen-van-linh-street` - undefined (street_pronouncer, active_review)
- 11. `viet-phrase-city-danang-place-vo-nguyen-giap-street` / `city-danang-place-vo-nguyen-giap-street` - undefined (street_pronouncer, active_review)
- 12. `viet-phrase-city-danang-go-ba-na-hills` / `city-danang-go-ba-na-hills` - undefined (route_ticket, active_review)
- 13. `viet-phrase-city-danang-where-ba-na-hills` / `city-danang-where-ba-na-hills` - undefined (place_navigation, active_review)
- 14. `viet-phrase-city-danang-ticket-marble-mountains` / `city-danang-ticket-marble-mountains` - undefined (route_ticket, active_review)
- 15. `viet-phrase-city-danang-go-dragon-bridge` / `city-danang-go-dragon-bridge` - undefined (route_ticket, active_review)
- 16. `viet-phrase-city-danang-near-nguyen-van-linh-street` / `city-danang-near-nguyen-van-linh-street` - undefined (street_driver, active_review)
- 17. `viet-phrase-acknowledge-da-chao-anh` / `acknowledge-da-chao-anh` - undefined (relationship_politeness, active_review)
- 18. `viet-phrase-v500-airp-bord-arri-where-is-the-taxi-counter` / `v500-airp-bord-arri-where-is-the-taxi-counter` - undefined (airport_taxi, active_review)
- 19. `viet-phrase-v900-airp-bord-arri-can-you-help-me-track-my-bag` / `v900-airp-bord-arri-can-you-help-me-track-my-bag` - undefined (airport_baggage, active_review)
- 20. `viet-phrase-hotel-9` / `hotel-9` - undefined (hotel_taxi, active_review)
- 21. `viet-phrase-v900-hote-acco-can-you-arrange-a-taxi-for-me` / `v900-hote-acco-can-you-arrange-a-taxi-for-me` - undefined (hotel_taxi, active_review)
- 22. `viet-phrase-food-peanut-allergy` / `food-peanut-allergy` - undefined (food_allergy, active_review)
- 23. `viet-phrase-v500-food-drin-i-am-allergic-to-shellfish` / `v500-food-drin-i-am-allergic-to-shellfish` - undefined (food_allergy, active_review)
- 24. `viet-phrase-emergency-hospital` / `emergency-hospital` - undefined (emergency_help, active_review)
- 25. `viet-phrase-emergency-3` / `emergency-3` - undefined (emergency_passport, active_review)

## Files

- `pages.csv` and `pages.json`
- `sections.csv` and `sections.json`
- `phrase_rows.csv` and `phrase_rows.json`
- `breakdowns.csv` and `breakdowns.json`
- `relationships.csv` and `relationships.json`
- `renderer_directives.csv` and `renderer_directives.json`
- `asset_directives.csv` and `asset_directives.json`
- `validator_rules.csv` and `validator_rules.json`
- `review_notes.csv` and `review_notes.json`
- `schema_version.csv` and `schema_version.json`
- `page_patch.csv` and `page_patch.json`
- `section_patch.csv` and `section_patch.json`
- `phrase_row_patch.csv` and `phrase_row_patch.json`
- `breakdown_patch.csv` and `breakdown_patch.json`
- `relationship_reorder_patch.csv` and `relationship_reorder_patch.json`
- `renderer_directives_patch.csv` and `renderer_directives_patch.json`
- `asset_directives_patch.csv` and `asset_directives_patch.json`
- `validator_rules_patch.csv` and `validator_rules_patch.json`
- `questions_for_jojo.csv` and `questions_for_jojo.json`
- `CHATGPT_PROMPT.md`
- `IMPORT_README.md`
- `manifest.json`
- `schema-version.json`

## Regenerate

```bash
node native-ios/scripts/export-viet-chatgpt-editorial-batch.js
node native-ios/scripts/validate-viet-chatgpt-editorial-batch.js
```
