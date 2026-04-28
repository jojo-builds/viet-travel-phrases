# Tagalog Substantial Expansion Notes

## Summary

- Existing phrase-source rows before this pass: `70`
- New families added in this pass: `63`
- New rows added in this pass: `126`
- New phrase-source rows after this pass: `196`
- New starter primaries: `23`
- New premium primaries: `40`

## Scenario additions

### Grab / Taxi

- `tagalog-grab-taxi-8`: Is this the pickup point?
- `tagalog-grab-taxi-9`: Please wait here
- `tagalog-grab-taxi-10`: Please use the meter
- `tagalog-grab-taxi-11`: Please drop me at the entrance
- `tagalog-grab-taxi-12`: Please wait, I'm coming
- `tagalog-grab-taxi-13`: I changed the destination in the app
- `tagalog-grab-taxi-14`: I think this is the wrong road
- `tagalog-grab-taxi-15`: Can you help me with my bag?
- `tagalog-grab-taxi-16`: Can we avoid the toll road?
- `tagalog-grab-taxi-17`: Please stop at an ATM first

### Hotel / Hostel

- `tagalog-hotel-hostel-8`: I booked under this name
- `tagalog-hotel-hostel-9`: Is breakfast included?
- `tagalog-hotel-hostel-10`: Can I leave my luggage here?
- `tagalog-hotel-hostel-11`: The key card isn't working
- `tagalog-hotel-hostel-12`: Can you change my room?
- `tagalog-hotel-hostel-13`: I need fresh towels
- `tagalog-hotel-hostel-14`: The shower has no hot water
- `tagalog-hotel-hostel-15`: Can someone help with the Wi-Fi?
- `tagalog-hotel-hostel-16`: Can I check out later?
- `tagalog-hotel-hostel-17`: Please call me a taxi
- `tagalog-hotel-hostel-18`: The room is too noisy
- `tagalog-hotel-hostel-19`: Can you send housekeeping?

### Street Food / Restaurant

- `tagalog-street-food-8`: Do you have vegetarian food?
- `tagalog-street-food-9`: No pork, please
- `tagalog-street-food-10`: No seafood, please
- `tagalog-street-food-11`: Can I see the menu?
- `tagalog-street-food-12`: What's your best seller?
- `tagalog-street-food-13`: Please make it less sweet
- `tagalog-street-food-14`: Can I get extra rice?
- `tagalog-street-food-15`: I'm allergic to peanuts
- `tagalog-street-food-16`: Can I pay separately?
- `tagalog-street-food-17`: No ice in the drink

### Asking Price / Totals

- `tagalog-asking-price-8`: How much is it in total?
- `tagalog-asking-price-9`: Do you accept cash?
- `tagalog-asking-price-10`: Do you have change?
- `tagalog-asking-price-11`: Please count it again
- `tagalog-asking-price-12`: Please write the total
- `tagalog-asking-price-13`: Which one is cheaper?
- `tagalog-asking-price-14`: Can I have smaller bills?
- `tagalog-asking-price-15`: This price is different from the sign

### Convenience Store

- `tagalog-convenience-store-8`: Can I tap to pay?
- `tagalog-convenience-store-9`: The card didn't go through
- `tagalog-convenience-store-10`: I only have a large bill
- `tagalog-convenience-store-11`: Please remove this item
- `tagalog-convenience-store-12`: Can I have the receipt?

### Directions

- `tagalog-directions-8`: Where is the entrance?
- `tagalog-directions-9`: Which exit should I take?
- `tagalog-directions-10`: Which stop do I get off?
- `tagalog-directions-11`: Please show me on the map
- `tagalog-directions-12`: Is it across the street?
- `tagalog-directions-13`: Can you mark it here?
- `tagalog-directions-14`: How far is it by car?
- `tagalog-directions-15`: Is it open now?
- `tagalog-directions-16`: Is there another way?
- `tagalog-directions-17`: Can I walk there safely?

### Repair / Pharmacy / Acute Help

- `tagalog-simple-problems-8`: Please write it down
- `tagalog-simple-problems-9`: Can you say the number again?
- `tagalog-simple-problems-10`: Can you type it into my phone?
- `tagalog-simple-problems-11`: I only speak a little Tagalog
- `tagalog-simple-problems-12`: Is there someone who speaks English?
- `tagalog-simple-problems-13`: Where is the nearest pharmacy?
- `tagalog-simple-problems-14`: I have a fever
- `tagalog-simple-problems-15`: My stomach hurts

## Notes

- All new rows are `audio_status=planned`.
- New packet rows use direct-script pronunciation equal to the authored Tagalog text for now.
- Convenience-store/payment families were tuned away from a weaker add-on phrase toward a stronger item-removal correction family after Gate 1 review.
- Repair and pharmacy families were explicitly tied into the relation sidecar so they do not drift into isolated rows.
