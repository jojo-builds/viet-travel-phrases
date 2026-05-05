# Viet Hero Image Production Tracker

This packet is the durable workflow surface for SpeakLocal Vietnam hero images.

The Google Sheet is the easy review surface. These CSV/JSON files are the repo mirror so the queue can be regenerated and audited without relying on memory from a prior thread.

## Why This Exists

The app masthead is a shallow cropped viewport over the source image. A generated image can look good as a standalone file and still fail in the phone hero if the subject lands too low, too small, or outside the crop.

The tracker therefore records:

- the current asset and dimensions;
- the target hero name;
- page type and priority;
- focal-zone requirements;
- generation prompt guidance;
- QA gates;
- simulator/phone proof requirements.

## Current Standard

- Committed repo PNG target: `853 x 1844` until the native renderer standard changes.
- Preferred source master: `>= 1600 x 2400`.
- The main subject must be visible in the upper third and center 70% width.
- No readable generated text, fake signage, logos, or watermarks.
- Specific pages must not use generic Vietnam imagery.

## Immediate Queue

Open P0 rows: 15

High-value P0 examples include Da Nang city, Marble Mountains, Linh Ung Pagoda, My Khe Beach, Da Nang Airport, Nén Đà Nẵng, Nguyễn Văn Linh Street, Bạch Đằng Street, Bún chả Hương Liên, Phở Bát Đàn, Bún bò Huế, and Cao lầu.

## Files

- `asset_tracker.csv`: all tracked hero image rows.
- `image_queue.csv`: incomplete rows sorted by priority.
- `standards.csv`: current app asset/crop standards.
- `prompt_recipes.csv`: reusable image prompt recipes by page profile.
- `qa_gates.csv`: required checks before marking an asset done.
- `manifest.json`: counts and source paths.
