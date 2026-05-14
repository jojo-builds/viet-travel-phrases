# Entity and Template Phrase Policy

SpeakLocal should not inflate the phrasebook by treating every `action + noun` combination as homepage, Browse, or category inventory.

## Product Rule

Browse starts with things:

- city names
- landmarks
- streets
- neighborhoods
- restaurants
- cafes
- dishes
- drinks
- markets

Phrase depth comes after the user selects a thing, searches for an action, or enters a Message/Story flow.

## Derived Place Phrases

Rows tagged `derived-place-phrases` are generated helper phrases such as:

- `Where is Dragon Bridge?`
- `Go to Dragon Bridge`
- `Stop at Dragon Bridge`
- `Is there an ATM near Dragon Bridge?`

These rows may be useful as temporary contextual helpers, but they are not top-level catalog inventory.

Do not surface them in:

- homepage shelves
- city hub "Names to know"
- city hub quick phrase rows
- Browse category starter rows
- Browse category shelves
- entity-first category cards
- entity-only search results such as `Dragon Bridge`

For attractions, landmarks, museums, parks, rivers, beaches, nature sights, and villages, do not create durable action-plus-place phrase pages. The traveler page should teach the attraction name, then link reusable phrase pages such as `Take me here`, `Please stop right here`, `Two tickets, please`, `Where is the entrance?`, `Where is the pickup point?`, and `Can you take a photo for me?`.

They may surface only when:

- a future template UI intentionally renders "ways to use this name" without promoting every row as a full listing page
- a Message/Story flow deliberately needs that exact phrase and the phrase is explicitly promoted as high value
- the entity type is outside the attraction/landmark family and a reviewed product decision says that action-plus-place audio is worth the app size

## Audio Rule

Do not commission unique audio for every generated place phrase by default. Prioritize audio for:

- entity names people need to show or hear
- high-value full phrases such as bathroom, passport, taxi, help, hotel, airport, allergy, payment, and directions
- hand-promoted city/place phrases that are genuinely common and useful

For long-tail place actions, prefer a template/entity model:

- one reviewed template
- one reviewed entity name
- full audio only when the phrase is promoted as high value
- no full listing page for one-off attraction actions such as `Let me off near Dragon Bridge` or `Two tickets to Bà Nà Hills`

## Vietnamese Template Guardrail

Templates must be compatible with the entity type.

Place-compatible examples:

- `{place} ở đâu?`
- `Cho tôi đến {place}.`
- `Cho tôi xuống gần {place}.`

Food/drink-compatible examples:

- `Cho tôi một {item}.`
- `{item} có gì?`

Do not blindly apply place templates to dishes, drinks, ingredients, services, or people.
