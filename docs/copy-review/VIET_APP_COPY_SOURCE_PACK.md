# Viet App Copy Source Pack

This is a documentation-only extraction of a historical Viet app copy snapshot from the main runtime flows. It is meant to give ChatGPT the language from that earlier build to critique and rewrite later, not to serve as current live-count truth and not to replace the durable truth in `docs/DECISIONS.md`, `docs/PRIORITIES.md`, or `docs/operations/*`.

## Historical Snapshot

- Extracted from the repo runtime sources on `2026-04-15`.
- Scope: current visible product/UI copy and naming from the main Viet flows.
- Focus: home screen, search, saved screen, premium screen, category/scenario flow, phrase-card labels/tags, CTA/button text, and the visible category/situation naming system.
- Intentional non-goal: this does not dump every phrase variant row in the pack. It focuses on UI/runtime copy and the situation-level naming users actually navigate through.
- Historical build snapshot from the inspected Viet pack:
  - `18` live categories
  - `117` free visible entries
  - `29` unlock-only visible entries
  - `146` total visible entries
  - `156` total phrase rows
- Current live-count truth now lives in:
  - `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
  - `docs/V2_BASELINE.md`
  - `docs/operations/APP_STATUS.md`

## Primary Source Files

- `app/family/presentation/viet.ts`
- `app/family/presentation/vietPremium.ts`
- `app/family/packs/viet.generated.ts`
- `app/app/(tabs)/index.tsx`
- `app/app/(tabs)/saved.tsx`
- `app/app/premium.tsx`
- `app/app/scenario/[id].tsx`
- `app/components/home/HomeTopSection.tsx`
- `app/components/home/HomeSearchDock.tsx`
- `app/components/home/LibraryCategoryCard.tsx`
- `app/components/PhraseCard.tsx`
- `app/lib/premiumStoreMessages.ts`

## App-Level Labels And Naming

- Tab label: `"Phrasebook"`
- Tab label: `"Saved"`
- Phrase card field label: `"Vietnamese"`
- Phrase card field label: `"Pronunciation"`
- Phrase card field label: `"English"`
- Settings icon accessibility label: `"Open settings"` (icon-only control, not visible body text)

## Category Names Currently Used

- `"Polite Basics"`
- `"Understanding & Repair"`
- `"Transport"`
- `"Hotel & Accommodation"`
- `"Food & Drink"`
- `"Money, Numbers & Prices"`
- `"Directions & Navigation"`
- `"Airport, Border & Arrival"`
- `"Health & Pharmacy"`
- `"Problems & Help"`
- `"Time, Dates & Booking"`
- `"Shopping"`
- `"Phone, Internet & Power"`
- `"Bathroom & Personal Needs"`
- `"Emergency & Safety"`
- `"Social & Small Talk"`
- `"Sightseeing & Activities"`
- `"Local Services & Everyday Tasks"`

## Home Screen Copy

### Top / Hero

- Greeting badge: `"Xin chao!"`
- Subtitle: `"Offline Vietnamese help for real trips"`
- Hero title: `"Start with the phrase that gets you unstuck."`
- Hero body: `"Browse by category, open the situation that matches what is happening, and use the main phrase first. The Full Trip Pack adds extra follow-up and recovery phrases inside these same categories."`

### Home Metrics / Status

- Metric pill: `"Free now"` -> currently `117`
- Metric pill: `"Unlock adds"` -> currently `29`
- Metric pill: `"Total live"` -> currently `146`
- Premium status pill when locked: `"Full Trip Pack available"`
- Premium status pill when unlocked: `"Full Trip Pack active"`
- Premium teaser badge: `"Full Trip Pack"`
- Premium teaser title: `"Free covers the basics. Full Trip Pack adds the tougher follow-up moments."`
- Premium teaser body: `"Free currently includes 117 visible entries across all 18 categories. The Full Trip Pack adds 29 more live follow-up and recovery entries inside those same categories."`
- Premium teaser CTA: `"See what it adds"`
- Locked teaser chip: `"117 free now"`
- Locked teaser chip: `"+29 unlock adds now"`
- Locked teaser chip: `"146 total live now"`

### Home Section Labels

- Quick phrases section title: `"Need a fast phrase?"`
- Quick phrases section subtitle: `"Use these for the fastest basics before you open a category."`
- Featured categories section title: `"Browse by category"`
- Featured categories section subtitle: `"Each category is grouped by situation. Start with the main phrase, then check extra versions only when you need them."`
- Full library section title: `"All categories"`
- Full library section subtitle: `"All 18 categories are open now. The Full Trip Pack adds extra follow-up and recovery situations inside the same categories."`

### Home Quick Phrase Cards Currently Featured

- Card chip: `"Quick pick"`
- Quick phrase: `"Hello"` / `"Xin chào"`
- Quick phrase: `"Thank you"` / `"Cảm ơn"`
- Quick phrase: `"Excuse me / sorry"` / `"Xin lỗi"`
- Quick phrase: `"How much is this?"` / `"Cái này bao nhiêu?"`
- Quick phrase: `"I don't understand"` / `"Tôi không hiểu"`
- Home quick-phrase audio fallback if a card has planned audio: `"Audio coming soon."`
- Home quick-phrase audio fallback if a card has no audio and no planned asset: `"Text for now."`

### Search Copy

- Search placeholder: `"Search English, Vietnamese, or pronunciation"`
- Search results title: `"Search results"`
- Search result count label: `"1 match"` / `"{n} matches"`
- Search empty title: `"No matching phrases"`
- Search empty body: `"Try another word or clear search to return to browsing."`
- Search clear CTA: `"Clear"`
- Search result context label: `"Category"`
- Search result context label: `"Situation"`

## Saved Screen Copy

- Header eyebrow: `"Saved phrases"`
- Screen title: `"Saved for this trip"`
- Header body: `"Keep your go-to phrase cards one tap away when signal, pace, or nerves get worse mid-trip."`
- Count chip pattern: `"{n} ready offline"`
- Empty state eyebrow: `"Saved phrases"`
- Empty state title: `"No saved phrases yet"`
- Empty state body: `"Save a useful phrase so it is ready for the next ride, check-in, or quick order."`
- Saved-card context label: `"Category"`
- Saved-card context label: `"Situation"`
- Data fallback label if category or situation lookup fails: `"Unknown"`

## Premium Screen Copy

### Top-Level Premium Labels

- Screen status pill when locked: `"Full Trip Pack available"`
- Screen status pill when unlocked: `"Full Trip Pack active"`
- Unlock model label: `"One-time unlock"`
- Screen title: `"What the Full Trip Pack adds"`
- Screen body: `"The live Viet app currently includes 117 free visible entries across all 18 categories. The Full Trip Pack adds 29 more live follow-up and recovery entries, for 146 visible entries total today. The longer-range plan is still 750 total entries, but the live app is not there yet."`

### Premium Metrics

- Metric label: `"Free now"` -> currently `117`
- Metric label: `"Unlock adds now"` -> currently `29`
- Metric label: `"Total live now"` -> currently `146`
- Metric label: `"Live categories"` -> currently `18`

### Premium Explanation Box

- Box title: `"What unlock adds today"`
- Box body: `"The Full Trip Pack does not send you to a separate part of the app. It adds deeper follow-up and recovery phrases inside the same categories you already opened for free."`
- Conditional audio note when some unlock-only rows still lack audio: `"Audio is still incomplete in this version. {readyCount} unlock-only rows already have audio, and {plannedCount} are still text-first for now."`
- Conditional audio note when all unlock-only rows currently have audio: `"Unlock-only rows that are live today already include audio."`

### Premium CTAs / Buttons

- Primary button when locked and store-ready: `"Unlock for $4.99"`
- Primary button when unlocked: `"Full Trip Pack active"`
- Primary button when store unavailable: `"Purchase not available in this build"`
- Secondary button when store-ready: `"Restore purchase"`
- Dev-only button when preview unlock is off: `"Enable validation unlock"`
- Dev-only button when preview unlock is on: `"Clear validation unlock"`

### Premium Helper Copy Under Buttons

- Default helper copy when there is no active store-status override: `"Purchase and restore work only when this build can reach the real App Store. If the App Store is not available here, the app keeps purchase disabled instead of pretending it worked."`
- Additional always-visible note: `"Some newer unlock-only phrases are still text-first while audio catches up. The app stays honest about that instead of claiming full audio coverage."`
- Dev-only note when preview unlock is active: `"Developer validation unlock is enabled on this device. It does not represent a real App Store purchase."`

### Premium Store Status Messages

- Unsupported platform: `"Buy and restore work only in a real iPhone build. This screen can still show what the unlock adds, but purchase stays off in Expo Go, web, and Android."`
- Missing product ID: `"This build is missing the premium product ID mapping, so purchase and restore stay disabled."`
- Connecting: `"Connecting to the App Store..."`
- Connection failed: `"This iPhone build could not reach the App Store yet. Check network access, sandbox account state, and that this is a native build with StoreKit available."`
- Product unavailable: `"This iPhone build can reach StoreKit, but the Full Trip Pack product is not loading yet. Confirm the App Store Connect item exists for this bundle and matches the configured product ID."`

### Premium Alerts

- Restore success title: `"Purchase restored"`
- Restore success body: `"The Full Trip Pack is unlocked again on this device."`
- Alert title: `"Purchase unavailable"`
- Alert body: `"This build is missing the premium product ID mapping."`
- Alert title: `"App Store purchase unavailable"`
- Alert body: `"Use a real iPhone build on device to buy or restore the Full Trip Pack."`
- Alert title: `"App Store unavailable"`
- Alert body: `"This build could not connect to the App Store right now."`
- Alert title: `"Product unavailable"`
- Alert body: `"The Full Trip Pack product is not loading yet for this build."`
- Alert title: `"Nothing to restore"`
- Alert body: `"No previous Full Trip Pack purchase was found for this Apple account."`
- Alert title: `"Store error"`
- Alert body fallback: `"The App Store request did not finish cleanly."`

### Premium Manage Section

- Section title: `"What the Full Trip Pack adds"`
- Section body: `"It is not a separate part of the app. It adds extra follow-up, repair, and recovery phrases inside the same categories once the first line is not enough."`
- Benefit bullet: `"Free already covers all 18 travel categories."`
- Benefit bullet: `"The one-time unlock adds the next step after the basic phrase: follow-up, repair, and recovery."`
- Benefit bullet: `"Each situation still starts with one main phrase, with only a few extra versions when they help."`
- Benefit bullet: `"Historical live reality in that snapshot was 150 free visible entries plus 350 unlock-only visible entries, for 500 total visible entries."`

### Premium Category Section

- Section title: `"Categories open now"`
- Section body: `"You can already browse every category for free. The Full Trip Pack adds more depth inside these same categories instead of hiding whole sections."`

## Phrase Card Labels, Tags, And Supporting Copy

### Phrase Card Structure

- Label: `"Pronunciation"`
- Label: `"English"`
- Context box title: `"Found in"`
- Context label: `"Category"`
- Context label: `"Situation"`
- Usage box title: `"When to use it"`
- Response box title: `"You may hear"`

### Variant / Alternate Phrasing Labels

- Variant chip currently observed: `"More polite"`
- Variant chip currently observed: `"Clearer"`
- Variant chip currently observed: `"Also common"`
- Variant fallback if missing a label: `"Variant"`
- Variant section title on scenario screen: `"More ways to say this"`
- Variant section body on scenario screen: `"Use these when you need a clearer, softer, or more natural version."`
- Variant count chip pattern: `"{n} more below"`
- Variant count chip pattern: `"{n} options"`

### Audio / Availability Labels

- Scenario summary metric: `"Audio now"`
- Scenario summary metric: `"Text for now"`
- Phrase card chip when audio is planned: `"Audio coming"`
- Phrase card chip when audio is unavailable: `"Text for now"`
- Home quick-phrase fallback when audio is planned: `"Audio coming soon."`

### Warning / Note Chips

- Warning chip currently observed in pack data: `"recognition only"`

### Save / State Text

- Saved-state label when `showLabel=true`: `"Saved"`
- Unsaved label when `showLabel=true`: `"Save"`
- Audio button label when `showLabel=true` and playing: `"Stop"`
- Audio button label when `showLabel=true` and idle: `"Play"`
- Audio button error label when `showLabel=true`: `"Error"`

## Category / Scenario Flow Copy

### Shared Category-Flow Labels

- Scenario summary metric: `"Situations here"`
- Scenario tip label: `"Travel tip"`
- Scenario preview label: `"What unlock adds here"`
- Scenario preview title: `"Full Trip Pack adds more depth in this category"`
- Scenario preview body pattern: `"Free already covers the main phrase here. The Full Trip Pack adds {situationCount} more situations and {phraseCount} more phrases in this category today."`
- Scenario preview extra line pattern: `"+{n} more deeper moments in this category."`
- Scenario preview chip pattern: `"{starterCount} free now"`
- Scenario preview chip pattern: `"+{premiumSituationCount} more situations"`
- Scenario preview chip pattern: `"+{premiumPhraseCount} more phrases"`
- Scenario preview audio note: `"Some unlock-only cards here are still text-first while audio catches up."`
- Scenario preview audio note: `"Added unlock cards in this category already include audio."`
- Scenario preview CTA: `"See what it adds"`

### Category Cards: Repeated Labels / Microcopy

- Availability/status chip: `"Free now"`
- Availability/status chip: `"Unlock only"`
- Availability/status chip: `"Open now"`
- Availability/status chip: `"Planned later"`
- Non-interactive planned badge: `"Planned next"`
- Compact count chip pattern: `"{starterCount} free now"`
- Compact count chip pattern: `"+{unlockAdds} unlock adds"`
- Compact count chip pattern when planned: `"{totalCount} planned"`
- Compact summary pattern: `"{starterCount} free now. Unlock adds {unlockAdds} more here."`
- Compact summary pattern when no unlock depth exists: `"{starterCount} free entries ready now."`
- Compact summary pattern when planned: `"{totalCount} entries planned"`
- Large-card metric label: `"Free now"`
- Large-card metric label: `"Unlock adds"`
- Large-card metric label: `"Total live"`
- Footer CTA when live: `"Open category"`
- Footer CTA when non-interactive planned card: `"Planned later"`

### Current Categories, Descriptions, Tips, And Visible Situation Headings

### Polite Basics

- Home/library card description: `"Open, soften, and close exchanges safely."`
- Scenario screen description: `"Open, soften, and close everyday exchanges safely."`
- Scenario tip: `"In busy travel moments, short polite phrases work better than long textbook sentences."`
- Card highlights: `"hello"`, `"thank you"`, `"excuse me"`, `"goodbye"`
- Visible situation headings:
  - `[Free live] Say hello first | Summary: Use a short greeting before you ask for anything else. | Primary English card: "Hello"`
  - `[Free live] Thank people clearly | Summary: A short thank-you keeps service moments warm and simple. | Primary English card: "Thank you"`
  - `[Free live] Give a polite acknowledgment | Summary: This helps you respond respectfully even before you know the full answer. | Primary English card: "Yes / polite acknowledgment"`
  - `[Free live] Decline without sounding cold | Summary: Short refusal plus thanks is safer than just saying no. | Primary English card: "No, thank you"`
  - `[Free live] Get attention or apologize | Summary: This is the safe all-purpose phrase for passing by, starting a question, or apologizing lightly. | Primary English card: "Excuse me / sorry"`
  - `[Free live] Soften a small mistake | Summary: Use this to lower tension when someone apologizes. | Primary English card: "It's okay"`
  - `[Free live] Close the exchange cleanly | Summary: A quick goodbye finishes the moment politely without extra talk. | Primary English card: "Goodbye"`

### Understanding & Repair

- Home/library card description: `"Recover when you missed the word, speed, or number."`
- Scenario screen description: `"Recover when you miss something or need the second sentence."`
- Scenario tip: `"This category should rescue more moments than generic phrasebooks usually do, so keep it close."`
- Card highlights: `"I do not understand"`, `"speak slower"`, `"say it again"`, `"write it down"`
- Visible situation headings:
  - `[Free live] Say that you do not understand | Summary: Lead with this before you ask for a repeat or a simpler version. | Primary English card: "I don't understand"`
  - `[Free live] Ask for slower speech | Summary: This is the default repair phrase when the problem is speed, not meaning. | Primary English card: "Can you speak a little slower?"`
  - `[Free live] Ask for a repeat | Summary: Use this when you missed the sentence and want the same words again. | Primary English card: "Please say that again"`
  - `[Free live] Ask to see it written | Summary: Written text often rescues numbers, names, and addresses faster than more speech. | Primary English card: "Please write it down"`
  - `[Free live] Ask what a word means | Summary: Use this when one key word blocks the whole moment. | Primary English card: "What does that mean?"`
  - `[Unlock-only live] Clarify the exact thing they mean | Summary: This helps when there are two prices, doors, stops, or choices in play. | Primary English card: "Which one do you mean?"`
  - `[Unlock-only live] Move the repair to the map or screen | Summary: Screens often solve travel confusion faster than more spoken detail. | Primary English card: "Can you show me on the map?"`
  - `[Unlock-only live] Recover when the number was the real problem | Summary: This is useful for room numbers, gates, prices, and bus numbers. | Primary English card: "Please say the number again"`

### Transport

- Home/library card description: `"Keep rides, buses, and station moments from going sideways."`
- Scenario screen description: `"Keep rides, buses, and station moments from going sideways."`
- Scenario tip: `"Show your map, speak in short chunks, and confirm the stop before the vehicle pulls away."`
- Card highlights: `"take me here"`, `"stop here"`, `"cash"`, `"right platform"`
- Visible situation headings:
  - `[Free live] Show the destination first | Summary: In most ride situations, the destination is the first sentence that matters. | Primary English card: "Take me here"`
  - `[Free live] Name the district or area clearly | Summary: Use the place name when it is shorter than a full address. | Primary English card: "Go to District 1"`
  - `[Free live] End the ride where you want it | Summary: This is the safe phrase for the last turn or final stop. | Primary English card: "You can stop here"`
  - `[Free live] Guide the route once | Summary: Use this only when you need to redirect the ride, not for every turn. | Primary English card: "Go this way"`
  - `[Free live] Ask for the air conditioning | Summary: This is a small comfort phrase, but it matters on long hot rides. | Primary English card: "Please turn on the air conditioning"`
  - `[Free live] Ask for a short wait | Summary: Keep this to very short stops so the driver understands the scope. | Primary English card: "Wait for me five minutes"`
  - `[Free live] Make payment method clear | Summary: This prevents confusion before the ride ends. | Primary English card: "I'll pay cash"`
  - `[Unlock-only live] Confirm the right platform or bay | Summary: This is the transport recovery phrase when you are not sure you are in the right place. | Primary English card: "Is this the right platform?"`
  - `[Unlock-only live] Ask whether the vehicle goes where you need | Summary: This is safer than asking for the whole route story. | Primary English card: "Does this bus go to…?"`

### Hotel & Accommodation

- Home/library card description: `"Handle check-in and room problems with less friction."`
- Scenario screen description: `"Handle check-in, room issues, and front-desk fixes with less friction."`
- Scenario tip: `"Hotels respond fastest when you lead with the room problem, then the exact thing you need next."`
- Card highlights: `"check in"`, `"check out"`, `"air conditioner"`, `"key card"`
- Visible situation headings:
  - `[Free live] Lead with the reservation | Summary: At check-in, reservation first is usually the fastest path. | Primary English card: "I have a reservation"`
  - `[Free live] Ask to check in | Summary: This is the default phrase when the reservation exists and you need the next step. | Primary English card: "I'd like to check in"`
  - `[Free live] Confirm check-out time | Summary: This prevents late-checkout surprises. | Primary English card: "What time is check-out?"`
  - `[Free live] Report that the room is too hot | Summary: Lead with the room problem before asking for the fix. | Primary English card: "This room is too hot"`
  - `[Free live] Report that the air conditioner is not working | Summary: This is the more specific follow-up when the heat problem is the air conditioner. | Primary English card: "The air conditioner isn't working"`
  - `[Free live] Ask for extra towels | Summary: Simple service requests should stay free and obvious. | Primary English card: "More towels please"`
  - `[Free live] Ask the hotel to hold your bags | Summary: This is a common before-check-in or after-checkout phrase. | Primary English card: "Please hold my luggage"`
  - `[Unlock-only live] Report the key card problem | Summary: This is one of the first premium recovery families that becomes useful in a real trip. | Primary English card: "The key card doesn't work"`
  - `[Unlock-only live] Ask the desk to arrange the next step | Summary: This is a practical second sentence, not a brand-new category. | Primary English card: "Can you call a taxi for me?"`

### Food & Drink

- Home/library card description: `"Order quickly, adjust the meal, and recover when the order goes wrong."`
- Scenario screen description: `"Order quickly, adjust the meal, and keep the table moving."`
- Scenario tip: `"Lead with the core request first, then add one small adjustment if you need it."`
- Card highlights: `"coffee"`, `"not spicy"`, `"water"`, `"wrong order"`
- Visible situation headings:
  - `[Free live] Order the classic iced milk coffee | Summary: Start with the base drink before you add any small changes. | Primary English card: "One iced milk coffee please"`
  - `[Free live] Order iced black coffee | Summary: Keep the order short and direct at busy counters. | Primary English card: "I'd like an iced black coffee"`
  - `[Free live] Order bạc xỉu | Summary: This is the sweeter milk-heavy coffee option many travelers ask for. | Primary English card: "I'd like an iced bạc xỉu"`
  - `[Free live] Adjust the ice | Summary: Use the base request first, then add this if you need it. | Primary English card: "Just a little ice"`
  - `[Free live] Adjust the sugar | Summary: This is one of the most useful café follow-ups for travelers. | Primary English card: "No sugar please"`
  - `[Free live] Take it away instead of staying | Summary: This keeps the order atomic and easy to recognize. | Primary English card: "To go"`
  - `[Free live] Signal that you are ready to pay | Summary: Use this to move the counter moment forward without extra explanation. | Primary English card: "Please let me pay"`
  - `[Free live] Order one portion simply | Summary: Start with the quantity before you add customizations. | Primary English card: "One portion please"`
  - `[Free live] Choose the exact dish | Summary: Pointing plus this phrase works well at busy stalls. | Primary English card: "I'll take this bowl"`
  - `[Free live] Ask for mild food first | Summary: This is one of the most practical restaurant safety phrases. | Primary English card: "Not spicy please"`
  - `[Free live] Ask for more herbs or greens | Summary: This helps on noodle, rice, and street-food orders. | Primary English card: "More herbs please"`
  - `[Free live] Ask for bottled water | Summary: This stays in the free layer because it solves a first-day survival need. | Primary English card: "Do you have bottled water?"`
  - `[Free live] Ask for the missing utensils | Summary: Keep this short and direct in busy places. | Primary English card: "A spoon and chopsticks please"`
  - `[Free live] Turn the meal into takeaway | Summary: This is the default restaurant exit phrase when you still want the food. | Primary English card: "Pack it to go"`
  - `[Free live] Check for a specific ingredient | Summary: This is the kind of safety phrase free users should not have to guess at. | Primary English card: "Does this have egg or peanuts?"`
  - `[Unlock-only live] Fix the wrong order | Summary: This is a classic Continue + Recover phrase, not a new category. | Primary English card: "This isn't what I ordered"`
  - `[Unlock-only live] Ask to pay separately | Summary: This is premium depth because the trip gets messier after the happy path meal works. | Primary English card: "Can we pay separately?"`

### Money, Numbers & Prices

- Home/library card description: `"Handle prices, totals, and payment basics clearly."`
- Scenario screen description: `"Check prices, counts, and payment basics without getting lost in the math."`
- Scenario tip: `"Pointing at the amount while saying the phrase keeps number misunderstandings lower."`
- Card highlights: `"how much"`, `"per kilo"`, `"final price"`, `"small bills"`
- Visible situation headings:
  - `[Free live] Ask the basic price | Summary: Point at the thing first, then say the phrase. | Primary English card: "How much is this?"`
  - `[Free live] Ask for the price by weight | Summary: This is especially useful in markets and fruit stalls. | Primary English card: "How much per kilo?"`
  - `[Free live] React to a high price | Summary: This is useful even if you are not bargaining aggressively. | Primary English card: "Too expensive"`
  - `[Free live] Ask to lower the price a little | Summary: Use this only where bargaining is normal. | Primary English card: "Can you lower it a little?"`
  - `[Free live] Ask for the final price | Summary: This helps you move from browsing to decision. | Primary English card: "What's your final price?"`
  - `[Free live] Compare another option | Summary: This keeps the interaction moving without committing yet. | Primary English card: "Show me another one"`
  - `[Free live] Commit to the item | Summary: This closes the shopping moment quickly. | Primary English card: "I'll take this one"`
  - `[Unlock-only live] Ask for the total amount | Summary: This is the natural second sentence after individual price checking. | Primary English card: "How much altogether?"`
  - `[Unlock-only live] Ask for smaller bills or change | Summary: This is premium depth that matters once the trip gets practical. | Primary English card: "Do you have smaller bills?"`

### Directions & Navigation

- Home/library card description: `"Get back on track one turn at a time."`
- Scenario screen description: `"Get back on track when the map, landmark, or turn is unclear."`
- Scenario tip: `"Ask one turn at a time instead of trying to ask for the whole route in one sentence."`
- Card highlights: `"near here"`, `"turn left"`, `"go straight"`, `"which exit"`
- Visible situation headings:
  - `[Free live] Ask how to get there | Summary: Lead with the place name, not a long route story. | Primary English card: "Excuse me, how do I get to Bến Thành Market?"`
  - `[Free live] Check whether it is nearby | Summary: This helps you decide whether to walk or change plans. | Primary English card: "Is it near here?"`
  - `[Free live] Ask how long on foot | Summary: This keeps the answer concrete instead of vague. | Primary English card: "How long on foot?"`
  - `[Free live] Ask where to turn left | Summary: Take the route one turn at a time. | Primary English card: "Where do I turn left?"`
  - `[Free live] Confirm the right turn | Summary: This is a good repair phrase when you think you heard the turn but want confirmation. | Primary English card: "Turn right, correct?"`
  - `[Free live] Confirm that you should keep going straight | Summary: This is one of the safest route check phrases. | Primary English card: "Go straight?"`
  - `[Free live] Close the directions exchange | Summary: This is useful when the other person kept helping and you want to end the exchange cleanly. | Primary English card: "Thanks, I understand now"`
  - `[Unlock-only live] Ask for the pickup point | Summary: This is a practical route phrase once the trip is deeper than just walking. | Primary English card: "Where is the pickup point?"`
  - `[Unlock-only live] Ask which exit you need | Summary: This becomes useful in stations, airports, and malls. | Primary English card: "Which exit?"`

### Airport, Border & Arrival

- Home/library card description: `"Land, clear the arrival steps, and reach the city cleanly."`
- Scenario screen description: `"Land, clear arrival friction, and reach the city with fewer dead ends."`
- Scenario tip: `"The best arrival phrases are calm and atomic: luggage, SIM, ATM, pickup, and where to go next."`
- Card highlights: `"immigration"`, `"baggage claim"`, `"SIM"`, `"pickup area"`
- Visible situation headings:
  - `[Free live] Find immigration first | Summary: Arrival phrases should keep you moving to the next checkpoint fast. | Primary English card: "Where is immigration?"`
  - `[Free live] Find baggage claim | Summary: Keep this simple because staff can usually point if the phrase is clear. | Primary English card: "Where is baggage claim?"`
  - `[Free live] Find the SIM or eSIM counter | Summary: Connectivity is a first-day survival need, not just premium polish. | Primary English card: "Where can I buy a SIM card?"`
  - `[Free live] Find cash access after landing | Summary: This helps when rides or food still need cash on the first day. | Primary English card: "Where is the ATM?"`
  - `[Free live] Find the pickup area | Summary: This keeps the first transport handoff from going messy. | Primary English card: "Where is the pickup area?"`
  - `[Free live] Report the missing bag | Summary: Missing baggage is still a first-day survival problem and should stay in starter access. | Primary English card: "My bag did not arrive"`
  - `[Unlock-only live] Find the next terminal | Summary: This matters once the trip includes connections or separate domestic legs. | Primary English card: "Where is the domestic terminal?"`

### Health & Pharmacy

- Home/library card description: `"Keep the basic travel symptoms and pharmacy asks free."`
- Scenario screen description: `"Cover the basic travel symptoms that should stay free and usable."`
- Scenario tip: `"Use symptom phrases plus the body part or medicine request instead of trying to explain everything."`
- Card highlights: `"doctor"`, `"pharmacy"`, `"headache"`, `"stomach hurts"`
- Visible situation headings:
  - `[Free live] Ask for a doctor directly | Summary: Basic medical phrasing stays free because it belongs to the first-48-hours safety layer. | Primary English card: "I need a doctor"`
  - `[Free live] Find the pharmacy | Summary: This should stay free because it solves a common travel problem quickly. | Primary English card: "Where is the pharmacy?"`
  - `[Free live] Name the symptom clearly | Summary: Short symptom phrases work better than long explanations. | Primary English card: "I have a headache"`
  - `[Free live] Name a stomach problem clearly | Summary: This is one of the highest-value travel symptom phrases. | Primary English card: "My stomach hurts"`
  - `[Free live] Ask for motion sickness medicine | Summary: Useful for buses, ferries, and mountain travel. | Primary English card: "Do you have motion sickness medicine?"`
  - `[Free live] Explain an allergy risk | Summary: Basic allergy warning language should stay in starter access. | Primary English card: "I am allergic to this"`
  - `[Free live] Ask for diarrhea medicine | Summary: This is a common first-48-hours pharmacy recovery phrase and should stay in starter access. | Primary English card: "I need something for diarrhea"`

### Problems & Help

- Home/library card description: `"Ask for practical help when the trip breaks or stalls."`
- Scenario screen description: `"Ask for practical help when something on the trip breaks or disappears."`
- Scenario tip: `"Name the problem first, then the action you need from the other person."`
- Card highlights: `"I am lost"`, `"left something"`, `"help me"`, `"call the hotel"`
- Visible situation headings:
  - `[Free live] Say that you are lost | Summary: This is the simplest first sentence when navigation has already failed. | Primary English card: "I'm lost"`
  - `[Free live] Say you left something behind | Summary: This is a common hotel, taxi, and café recovery phrase. | Primary English card: "I left something behind"`
  - `[Free live] Ask for help plainly | Summary: When the trip is messy, this is the safest first sentence before the details. | Primary English card: "Can you help me?"`
  - `[Free live] Ask someone to call the hotel | Summary: This is a high-value second sentence once the problem involves a room, booking, or bag. | Primary English card: "Please call the hotel for me"`
  - `[Free live] Ask for the manager | Summary: This is a practical escalation phrase, not a dramatic one. | Primary English card: "I need the manager"`
  - `[Unlock-only live] Recover from a payment problem | Summary: This is premium because the trip has moved past the happy path and into dispute resolution. | Primary English card: "I was charged twice"`
  - `[Unlock-only live] Ask to file a report | Summary: This is the confidence-layer phrase when the issue needs paperwork, not just quick help. | Primary English card: "I need to file a report"`

### Time, Dates & Booking

- Home/library card description: `"Confirm timing and booking details cleanly."`
- Scenario screen description: `"Confirm timing, booking details, and meeting points clearly."`
- Scenario tip: `"Time phrases are safer when you pair them with a date, room, bus, or booking reference."`
- Card highlights: `"what time"`, `"today"`, `"tomorrow morning"`, `"booking"`
- Visible situation headings:
  - `[Free live] Ask the basic time question | Summary: This is the safest time question because the thing itself can be pointed to or named separately. | Primary English card: "What time?"`
  - `[Free live] Anchor the moment to today | Summary: This helps when you need to confirm whether something is today or not. | Primary English card: "Today"`
  - `[Free live] Anchor the moment to tomorrow morning | Summary: Short date anchors keep booking conversations simple. | Primary English card: "Tomorrow morning"`
  - `[Free live] Lead with the booking itself | Summary: Start with the booking before you ask about timing changes. | Primary English card: "I have a booking"`
  - `[Free live] Ask opening time | Summary: This is one of the highest-value time questions for everyday travel. | Primary English card: "What time does it open?"`
  - `[Unlock-only live] Ask to move it later | Summary: This is premium because it belongs to the confidence layer after the basic booking works. | Primary English card: "Can we move it later?"`
  - `[Unlock-only live] Ask when boarding starts | Summary: This belongs to the trip-gets-real layer of travel timing. | Primary English card: "What time does boarding start?"`

### Shopping

- Home/library card description: `"Compare size, color, fit, and checkout without friction."`
- Scenario screen description: `"Compare items, sizes, and colors without turning the app into bargaining theater."`
- Scenario tip: `"Use shopping phrases for choosing and checking fit first. Price negotiation can stay separate."`
- Card highlights: `"this size"`, `"another color"`, `"try it on"`, `"where do I pay"`
- Visible situation headings:
  - `[Free live] Ask for your size | Summary: Shopping should stay traveler-practical, not fashion-school. | Primary English card: "I want this size"`
  - `[Free live] Ask for another color | Summary: This is the simplest comparison phrase for clothing and small goods. | Primary English card: "Do you have another color?"`
  - `[Free live] Ask to try it on | Summary: This keeps the shopping moment functional and short. | Primary English card: "Can I try this on?"`
  - `[Free live] Say you are just browsing | Summary: This helps you deflect pressure politely. | Primary English card: "I'm just looking"`
  - `[Free live] Ask where to pay | Summary: This is the traveler version of checkout phrasing. | Primary English card: "Where do I pay?"`
  - `[Unlock-only live] Ask to exchange the item | Summary: This is premium because it belongs to the problem-after-purchase layer. | Primary English card: "I want to exchange this"`

### Phone, Internet & Power

- Home/library card description: `"Recover when the phone, charger, or data becomes the problem."`
- Scenario screen description: `"Get connected again when your phone, charger, or data becomes the problem."`
- Scenario tip: `"The fastest recovery path is usually SIM, Wi-Fi, outlet, charger, or battery phrasing."`
- Card highlights: `"Wi-Fi password"`, `"SIM"`, `"charger"`, `"charge phone"`
- Visible situation headings:
  - `[Free live] Ask for the Wi-Fi password | Summary: Connectivity repair belongs near the top of the first-day starter layer. | Primary English card: "What is the Wi-Fi password?"`
  - `[Free live] Ask where to buy a SIM | Summary: Keep this separate from airport phrasing because the need keeps recurring later in town. | Primary English card: "Do you sell SIM cards?"`
  - `[Free live] Say your phone battery is dead | Summary: This is the short version of a common travel problem. | Primary English card: "My phone battery is dead"`
  - `[Free live] Ask for a charger | Summary: This is the quickest recovery phrase when the battery problem can be fixed nearby. | Primary English card: "Do you have a charger?"`
  - `[Free live] Ask where you can charge the phone | Summary: This works in cafés, hotels, airports, and waiting areas. | Primary English card: "Where can I charge my phone?"`
  - `[Unlock-only live] Ask for a data top-up | Summary: This is premium because the trip already moved past the simple first SIM step. | Primary English card: "I need a data top-up"`
  - `[Unlock-only live] Report the eSIM problem | Summary: This is premium because it is a deeper connectivity recovery moment. | Primary English card: "My eSIM is not working"`

### Bathroom & Personal Needs

- Home/library card description: `"Handle the small needs that still ruin a day if you cannot ask."`
- Scenario screen description: `"Handle the small needs that still ruin a day if you cannot ask for them."`
- Scenario tip: `"These phrases stay short and direct on purpose because the moment is usually urgent."`
- Card highlights: `"bathroom"`, `"toilet paper"`, `"soap"`, `"water"`
- Visible situation headings:
  - `[Free live] Find the bathroom | Summary: This is a direct survival phrase and should stay short. | Primary English card: "Where is the bathroom?"`
  - `[Free live] Ask for toilet paper | Summary: This is the most common bathroom follow-up after finding the room. | Primary English card: "Do you have toilet paper?"`
  - `[Free live] Ask for soap | Summary: Keep this direct because the need is obvious and immediate. | Primary English card: "Do you have soap?"`
  - `[Free live] Ask to wash your hands | Summary: Useful in markets, food areas, and roadside stops. | Primary English card: "Can I wash my hands here?"`
  - `[Free live] Ask for water | Summary: This covers both bathroom and personal-need moments where you just need water fast. | Primary English card: "I need water"`
  - `[Unlock-only live] Ask whether there is a shower | Summary: This is premium because it belongs to the more-comfort and transit-recovery layer. | Primary English card: "Is there a shower here?"`

### Emergency & Safety

- Home/library card description: `"Keep the core emergency script short, free, and easy to reach."`
- Scenario screen description: `"Keep a basic emergency script free, simple, and easy to reach."`
- Scenario tip: `"Emergency phrasing should tell people what is wrong right now, not explain the whole story."`
- Card highlights: `"police"`, `"ambulance"`, `"passport"`, `"help"`
- Visible situation headings:
  - `[Free live] Call the police | Summary: Basic emergency phrasing stays in the free layer. | Primary English card: "Call the police"`
  - `[Free live] Call an ambulance | Summary: Basic emergency phrasing stays in the free layer. | Primary English card: "Call an ambulance"`
  - `[Free live] Say your passport is missing | Summary: Lost passport is a core travel emergency and should stay accessible. | Primary English card: "I lost my passport"`
  - `[Free live] Say you do not feel safe | Summary: This is a short high-signal safety phrase for stressful moments. | Primary English card: "I do not feel safe"`
  - `[Free live] Call for help loudly | Summary: This is the smallest emergency phrase, but still essential. | Primary English card: "Help!"`
  - `[Unlock-only live] Report a stolen bag | Summary: This is premium because it belongs to the recovery layer after the emergency begins. | Primary English card: "My bag was stolen"`
  - `[Unlock-only live] Ask for the embassy | Summary: This is premium because it becomes relevant only once the emergency is already serious. | Primary English card: "I need the embassy"`

### Social & Small Talk

- Home/library card description: `"Stay friendly without drifting into language-school mode."`
- Scenario screen description: `"Keep light conversation friendly without drifting into language-school territory."`
- Scenario tip: `"Short friendliness works better than deep small talk when you are moving through a trip."`
- Card highlights: `"where I am from"`, `"first time"`, `"food is good"`, `"recommend here"`
- Visible situation headings:
  - `[Free live] Say where you are from | Summary: Keep small talk simple and traveler-specific. | Primary English card: "I'm from the United States"`
  - `[Free live] Say you are from England | Summary: Keep small talk simple and traveler-specific. | Primary English card: "I'm from England"`
  - `[Free live] Say it is your first time | Summary: This is one of the easiest travel small-talk answers to use. | Primary English card: "This is my first time"`
  - `[Free live] Say you like Vietnam | Summary: This is a warm small-talk phrase that still stays practical. | Primary English card: "I like Vietnam"`
  - `[Free live] Say the food is good | Summary: This is one of the easiest friendly travel comments to make. | Primary English card: "The food is so good"`
  - `[Free live] Comment on the weather | Summary: This is low-stakes and easy for both sides to recognize. | Primary English card: "The weather is so hot"`
  - `[Free live] Ask how the other person is | Summary: This is friendly, but still simple enough to stay practical. | Primary English card: "How are you?"`
  - `[Unlock-only live] Ask how long someone is staying | Summary: This is premium because it belongs to the next sentence after the obvious first exchange works. | Primary English card: "How long are you staying?"`
  - `[Unlock-only live] Ask what they recommend | Summary: This is premium because it turns small talk into useful local guidance. | Primary English card: "What do you recommend here?"`

### Sightseeing & Activities

- Home/library card description: `"Use simple phrases for tickets, hours, and meeting points."`
- Scenario screen description: `"Use simple travel phrases for tickets, opening hours, and activity moments."`
- Scenario tip: `"Ask about time, price, photo rules, and meeting points before the activity starts."`
- Card highlights: `"ticket"`, `"start here"`, `"photos"`, `"meeting point"`
- Visible situation headings:
  - `[Free live] Ask the ticket price | Summary: Tickets, hours, and meeting points are the core sightseeing needs. | Primary English card: "How much is the ticket?"`
  - `[Free live] Ask where to start | Summary: This helps when the entrance area is not obvious. | Primary English card: "Where do we start?"`
  - `[Free live] Ask whether photos are allowed | Summary: This is a common temple, museum, and activity phrase. | Primary English card: "Can I take photos here?"`
  - `[Free live] Ask what time it closes | Summary: This is the most useful sightseeing follow-up after ticket price. | Primary English card: "What time does it close?"`
  - `[Free live] Find the meeting point | Summary: This avoids missed tours and pickup confusion. | Primary English card: "Where is the meeting point?"`
  - `[Unlock-only live] Ask whether booking ahead is needed | Summary: This is premium because it matters when the trip gets planned more tightly. | Primary English card: "Do I need to book in advance?"`

### Local Services & Everyday Tasks

- Home/library card description: `"Solve the everyday errands that keep the trip running."`
- Scenario screen description: `"Solve the ordinary errands that keep a trip running day to day."`
- Scenario tip: `"Errand phrasing works best when it is item-first and action-second."`
- Card highlights: `"water"`, `"bag"`, `"tissues"`, `"print this"`
- Visible situation headings:
  - `[Free live] Buy water | Summary: This is one of the clearest first-day errand phrases. | Primary English card: "A bottle of water please"`
  - `[Free live] Ask for a bag | Summary: This helps in stores, markets, and takeaway counters. | Primary English card: "Do you have a bag?"`
  - `[Free live] Ask for tissues | Summary: This stays practical and day-to-day, not fancy. | Primary English card: "Tissues please"`
  - `[Free live] Find sunscreen | Summary: This is a common heat-and-sun travel errand that belongs in the starter layer. | Primary English card: "Where is the sunscreen?"`
  - `[Free live] Ask someone to open it | Summary: This solves the small real-world task without extra explanation. | Primary English card: "Please open this for me"`
  - `[Free live] Ask whether card works here | Summary: This helps when you do not want to reach the register and stall out. | Primary English card: "Can I pay by card?"`
  - `[Free live] Ask for the receipt | Summary: Keep this direct because it is usually the last step of the errand. | Primary English card: "Please give me the receipt"`
  - `[Unlock-only live] Ask to print something | Summary: This is premium because it belongs to the deeper errand layer after basic store use works. | Primary English card: "Can I print this?"`
  - `[Unlock-only live] Ask to refill the water bottle | Summary: This is premium because it is useful, but not part of the bare-minimum first sentence layer. | Primary English card: "Can you refill this water bottle?"`

## Likely Copy-Review Hotspots (Observation Only, Not Rewrites)

- The app currently uses several overlapping unit words for similar concepts: `"category"`, `"situation"`, `"entry"`, `"phrase"`, `"card"`, `"row"`, and `"moment"`.
- The premium system is named in multiple ways depending on screen and state: `"Full Trip Pack"`, `"unlock"`, `"one-time unlock"`, `"purchase"`, `"restore"`, and `"validation unlock"`.
- Counts are described with several slightly different patterns: `"Unlock adds"`, `"Unlock adds now"`, `"+29 unlock adds now"`, `"+{n} more situations"`, `"+{n} more phrases"`, `"Total live"`, and `"Total live now"`.
- Audio state language also varies across surfaces: `"Audio now"`, `"Audio coming"`, `"Audio coming soon."`, `"Text for now"`, and `"text-first while audio catches up"`.
- The home screen teaches a model of `"category" -> "situation" -> "main phrase first"`, but the actual in-flow headings and card chrome do not always reinforce those terms consistently.
- `"What the Full Trip Pack adds"` appears as both the main premium screen title and the later premium manage-section title.
- Saved uses both `"Saved phrases"` and `"Saved for this trip"` for the same screen.
- Some category card descriptions and scenario screen descriptions are near-duplicates rather than exact matches.
- Several family titles are instructional/meta rather than concrete travel-language labels, for example `"Lead with the reservation"`, `"Give a polite acknowledgment"`, `"Move the repair to the map or screen"`, `"Anchor the moment to today"`.
- The family-heading system often mixes traveler intent, advice, and phrase purpose in the same title layer. The summary sentence then sometimes repeats the same concept in another wording pass.

## Exact Feedback Strings: Search Result Against Current Runtime

- Exact string not found in current inspected user-visible Viet runtime copy: `"Intent family"`
- Exact string not found in current inspected user-visible Viet runtime copy: `"Audio Ready"`
- Exact string not found in current inspected user-visible Viet runtime copy: `"Starter Now"`
- `"Say this first"` exists in generated pack data for primary phrases, but the current UI does not visibly render that label on the primary phrase card.
- The closest currently visible neighboring terms are:
  - `"Situation"`
  - `"Audio now"`
  - `"Audio coming"`
  - `"Audio coming soon."`
  - `"Text for now"`
  - `"Free now"`
  - `"Open now"`

## Configured But Not Currently Surfaced Or Not Currently Used As Visible Copy

- `premium.plannedSectionTitle` / `premium.plannedSectionBody` exist in `app/family/presentation/vietPremium.ts`, but the current Viet premium screen has no planned-category section because all current premium categories are marked live.
- `premium.scenarioPreviewBody` exists in `app/family/presentation/vietPremium.ts`, but the scenario screen currently uses custom hard-coded preview body copy instead.
- `premium.storeUnavailableTitle`, `premium.storePlaceholderBody`, `premium.restoredAlertTitle`, and `premium.restoredAlertBody` exist in config, but the visible premium/store messaging currently comes from `app/app/premium.tsx` and `app/lib/premiumStoreMessages.ts`.
- `premium.liveNowStatLabel`, `premium.starterStatLabel`, and `premium.fullLibraryStatLabel` exist in config, but the current visible metric labels are hard-coded in screen/card components.

## Best Hand-Off Prompting Note

- If this file is pasted into ChatGPT for a rewrite pass, the most useful follow-up prompt is likely: critique clarity, naming, information hierarchy, and premium-language tone while preserving the app's offline practical-travel positioning and the current free-vs-unlock structure.
