import csv
import json
from pathlib import Path


ROOT = Path(r"E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion")
CSV_PATH = ROOT / "content-draft" / "viet" / "phrase-source.csv"
REL_PATH = ROOT / "content-draft" / "viet" / "relation-sample-v1.json"
ANS_PATH = ROOT / "content-draft" / "viet" / "answer-page-sample-v1.json"


with CSV_PATH.open("r", encoding="utf-8-sig", newline="") as handle:
    reader = csv.DictReader(handle)
    rows = list(reader)
    fieldnames = reader.fieldnames

with REL_PATH.open("r", encoding="utf-8") as handle:
    relation_sample = json.load(handle)

with ANS_PATH.open("r", encoding="utf-8") as handle:
    answer_sample = json.load(handle)


family_rows = {}
phrase_rows = {}
for row in rows:
    family_rows.setdefault(row["family_id"], []).append(row)
    phrase_rows[row["phrase_id"]] = row


BASELINE_ANSWER_MARKED_ROW_COUNT = 33


def row_for_phrase(phrase_id):
    if phrase_id not in phrase_rows:
        raise KeyError(f"missing phrase id: {phrase_id}")
    return phrase_rows[phrase_id]


def family_title(family_id):
    return family_rows[family_id][0]["family_title"]


def family_summary(family_id):
    return family_rows[family_id][0]["family_summary"]


def scenario_id(family_id):
    return family_rows[family_id][0]["scenario_id"]


def access_tier(phrase_id):
    return row_for_phrase(phrase_id)["access_tier"]


def phrase_for_family(family_id, variant_role="say-first"):
    for row in family_rows.get(family_id, []):
        if row["variant_role"] == variant_role and row["status"] == "approved":
            return row["phrase_id"]
    raise KeyError(f"missing {variant_role} row for {family_id}")


def maybe_phrase_for_family(family_id, variant_role):
    for row in family_rows.get(family_id, []):
        if row["variant_role"] == variant_role and row["status"] == "approved":
            return row["phrase_id"]
    return None


def dedupe(sequence):
    result = []
    seen = set()
    for item in sequence:
        if item and item not in seen:
            result.append(item)
            seen.add(item)
    return result


def add_note_token(notes, token):
    parts = [part.strip() for part in (notes or "").split("|") if part.strip()]
    if token not in parts:
        parts.append(token)
    return " | ".join(parts)


def strip_managed_note_tokens(notes):
    parts = [part.strip() for part in (notes or "").split("|") if part.strip()]
    kept = [
        part
        for part in parts
        if not part.startswith("relation-sample=") and not part.startswith("answer-page-sample=")
    ]
    return " | ".join(kept)


def edge(target_family_id, reason, target_phrase_id=None):
    return {
        "targetFamilyId": target_family_id,
        "targetPhraseId": target_phrase_id,
        "reason": reason,
    }


def greetings(
    hub_id,
    family_id,
    coverage_moment,
    summary,
    core_bullets,
    use_cases,
    say_next_summary,
    likely_reply,
    repair_if_missed,
    ask_next,
    cross_class_exit,
    clearer_phrase_id=None,
    more_polite_phrase_id=None,
    alternate_phrase_ids=None,
):
    return {
        "hubId": hub_id,
        "familyId": family_id,
        "phraseClass": "greetings-social",
        "moduleMixId": "greetings-social-v1",
        "coverageMoment": coverage_moment,
        "summary": summary,
        "coreBullets": core_bullets,
        "useCases": use_cases,
        "sayNextSummary": say_next_summary,
        "clearerPhraseId": clearer_phrase_id,
        "morePolitePhraseId": more_polite_phrase_id,
        "alternatePhraseIds": alternate_phrase_ids or [],
        "relationBuckets": {
            "likelyReply": likely_reply,
            "repairIfMissed": repair_if_missed,
            "askNext": ask_next,
            "crossClassExit": cross_class_exit,
        },
    }


def urgent(
    hub_id,
    family_id,
    coverage_moment,
    summary,
    detail_bullets,
    local_reality,
    likely_reply,
    repair_if_missed,
    ask_next,
    escalate_to,
    cross_class_exit,
    clearer_phrase_id=None,
    more_polite_phrase_id=None,
    alternate_phrase_ids=None,
):
    return {
        "hubId": hub_id,
        "familyId": family_id,
        "phraseClass": "urgent-help-medical",
        "moduleMixId": "urgent-help-medical-v1",
        "coverageMoment": coverage_moment,
        "summary": summary,
        "detailBullets": detail_bullets,
        "localReality": local_reality,
        "clearerPhraseId": clearer_phrase_id,
        "morePolitePhraseId": more_polite_phrase_id,
        "alternatePhraseIds": alternate_phrase_ids or [],
        "relationBuckets": {
            "likelyReply": likely_reply,
            "repairIfMissed": repair_if_missed,
            "askNext": ask_next,
            "escalateTo": escalate_to,
            "crossClassExit": cross_class_exit,
        },
    }


def repair(
    hub_id,
    family_id,
    summary,
    show_write,
    number_check,
    courtesy,
    likely_reply,
    repair_if_missed,
    ask_next,
    cross_class_exit,
    clearer_phrase_id=None,
    more_polite_phrase_id=None,
    alternate_phrase_ids=None,
):
    return {
        "hubId": hub_id,
        "familyId": family_id,
        "phraseClass": "repair-clarification",
        "moduleMixId": "repair-clarification-v1",
        "coverageMoment": "repair",
        "summary": summary,
        "showWrite": show_write,
        "numberCheck": number_check,
        "courtesy": courtesy,
        "clearerPhraseId": clearer_phrase_id,
        "morePolitePhraseId": more_polite_phrase_id,
        "alternatePhraseIds": alternate_phrase_ids or [],
        "relationBuckets": {
            "likelyReply": likely_reply,
            "repairIfMissed": repair_if_missed,
            "askNext": ask_next,
            "crossClassExit": cross_class_exit,
        },
    }


def practical(
    hub_id,
    family_id,
    coverage_moment,
    summary,
    confirm_detail,
    what_to_show,
    local_reality,
    likely_reply,
    repair_if_missed,
    ask_next,
    cross_class_exit,
    clearer_phrase_id=None,
    more_polite_phrase_id=None,
    alternate_phrase_ids=None,
):
    return {
        "hubId": hub_id,
        "familyId": family_id,
        "phraseClass": "practical-service-navigation",
        "moduleMixId": "practical-service-navigation-v1",
        "coverageMoment": coverage_moment,
        "summary": summary,
        "confirmDetail": confirm_detail,
        "whatToShow": what_to_show,
        "localReality": local_reality,
        "clearerPhraseId": clearer_phrase_id,
        "morePolitePhraseId": more_polite_phrase_id,
        "alternatePhraseIds": alternate_phrase_ids or [],
        "relationBuckets": {
            "likelyReply": likely_reply,
            "repairIfMissed": repair_if_missed,
            "askNext": ask_next,
            "crossClassExit": cross_class_exit,
        },
    }


MODULE_MIXES = answer_sample["moduleMixes"]
MODULE_MIX_OPTIONAL_BUCKET_REMOVALS = {
    "greetings-social-v1": {"crossClassExit"},
    "urgent-help-medical-v1": {"crossClassExit"},
}
for module_mix in MODULE_MIXES:
    optional_buckets = MODULE_MIX_OPTIONAL_BUCKET_REMOVALS.get(module_mix.get("id"), set())
    if optional_buckets:
        module_mix["requiredRelationBuckets"] = [
            bucket_name
            for bucket_name in module_mix.get("requiredRelationBuckets", [])
            if bucket_name not in optional_buckets
        ]


NEW_HUBS = [
    practical(
        hub_id="viet-transport-fare",
        family_id="transport-fare",
        coverage_moment="transport",
        summary="Ask the fare before the ride settles so the money part stays clear while you still have leverage.",
        confirm_detail=[
            "Know whether the number is a flat fare, a meter start, or an app-linked price.",
            "If the answer comes as a fast number, switch immediately into a number-check phrase.",
        ],
        what_to_show=[
            "Show the destination in the app or on a map if route length is driving the fare.",
            "Hold up cash or the payment screen when the real question is card versus cash.",
        ],
        local_reality=[
            "Fare talk usually happens in traffic noise, with little patience for long bargaining speeches.",
            "A short follow-up like meter, final price, or write it down is safer than arguing in broad terms.",
        ],
        likely_reply=[
            edge("repair-number", "The first answer is usually a number, so be ready to catch or replay it cleanly."),
        ],
        repair_if_missed=[
            edge("repair-write-down", "Written digits are the safest repair when the spoken amount is muddy."),
            edge("repair-understand", "If the driver starts explaining too much, reset with a direct understanding repair."),
        ],
        ask_next=[
            edge("money-final-price", "After the first quote, the next useful move is often locking the final amount."),
            edge("transport-meter", "If the quote feels slippery, the meter request is the cleanest next branch."),
        ],
        cross_class_exit=[
            edge("v900-tran-is-that-the-total-price", "If extra charges appear later, pivot to the total-price check immediately."),
        ],
    ),
    practical(
        hub_id="viet-food-menu",
        family_id="food-menu",
        coverage_moment="food",
        summary="Open the meal with the menu before you commit to a dish or guess what the place can actually do for you.",
        confirm_detail=[
            "If you are not seated yet, be ready for the table question before the menu ever appears.",
            "Once the menu is open, move quickly to the one constraint or dish decision that matters most.",
        ],
        what_to_show=[
            "Point at the page, section, or photo instead of trying to narrate the whole menu out loud.",
            "Use your phone light, translation app, or camera only as backup after the menu is physically in front of you.",
        ],
        local_reality=[
            "Busy staff often treat menu, table, and drink questions as one fast sequence.",
            "The strongest follow-up is usually a food constraint or the first specific item, not more browsing talk.",
        ],
        likely_reply=[
            edge("food-need-table", "If you are still standing, the first response is often a seating question."),
            edge("food-bottled-water", "A drink prompt often arrives as soon as the menu lands."),
        ],
        repair_if_missed=[
            edge("repair-show-me", "If the menu response stays vague, ask them to point or show you the exact option."),
            edge("repair-translate-this", "Dish names and ingredients are often easier to rescue with direct translation help."),
        ],
        ask_next=[
            edge("food-not-spicy", "Once the menu is open, a spice or ingredient constraint is often the real next move."),
            edge("social-recommend", "If the menu is broad, a recommendation ask can narrow it quickly."),
        ],
        cross_class_exit=[
            edge("money-how-much", "If the menu has no clear prices, pivot into the price-check page instead of guessing."),
        ],
    ),
    practical(
        hub_id="viet-food-not-spicy",
        family_id="food-not-spicy",
        coverage_moment="food",
        summary="Use this before the dish is locked in so the kitchen hears the constraint early, not after the food arrives.",
        confirm_detail=[
            "Say whether you mean no spice at all or just less spice than the normal version.",
            "If the staff hesitate, be ready to point at the item and repeat the constraint more simply.",
        ],
        what_to_show=[
            "Point at the exact dish so the spice request attaches to one item instead of the whole table.",
            "If you have an allergy or ingredient issue, keep that phrase ready on your phone too.",
        ],
        local_reality=[
            "Spice requests work best before ordering is finalized, not once the plate is already moving.",
            "A short drink or menu follow-up often matters more than a long explanation of your tolerance.",
        ],
        likely_reply=[
            edge("health-allergy", "If the staff hear a safety concern, the conversation can shift straight into allergy protection."),
        ],
        repair_if_missed=[
            edge("repair-write-down", "Writing the request is safer when the kitchen detail is high-stakes."),
            edge("repair-translate-this", "Use direct translation help if ingredient language still feels uncertain."),
        ],
        ask_next=[
            edge("food-menu", "Sometimes you need the menu back in view to choose a safer dish."),
            edge("food-bottled-water", "A drink order is a common easy follow-up once the main constraint is set."),
        ],
        cross_class_exit=[
            edge("food-pay-now", "If the order is already placed and the dish is fixed, the safer move may be to wrap the meal up cleanly."),
        ],
        clearer_phrase_id="food-not-spicy-clearer",
    ),
    practical(
        hub_id="viet-food-bottled-water",
        family_id="food-bottled-water",
        coverage_moment="food",
        summary="This is the clean hydration request when you want bottled water without reopening the whole meal conversation.",
        confirm_detail=[
            "Know whether you need one bottle now or enough water for the whole table or trip segment.",
            "If the first answer sounds like a price, be ready to pivot into the amount check right away.",
        ],
        what_to_show=[
            "Point at a bottle on display or another table if the brand or size matters.",
            "Use your fingers to show quantity if one versus two bottles changes the total.",
        ],
        local_reality=[
            "Use it for a quick yes-or-no water ask, then move straight into price or payment if needed.",
            "Keep the follow-up short so the stop stays about getting the bottle, not reopening the whole meal.",
        ],
        likely_reply=[
            edge("money-how-much", "The most common reply branch is the price or total for the bottle."),
        ],
        repair_if_missed=[
            edge("repair-show-me", "If the answer is vague, ask the staff to show the bottle or point at it."),
        ],
        ask_next=[
            edge("food-pay-now", "If water is the only thing you need, payment often follows immediately."),
            edge("service-water", "If bottled water is unavailable, move into a simpler water-supply request."),
        ],
        cross_class_exit=[
            edge("food-menu", "If the stop turns into a full order, bounce back to the menu page quickly."),
        ],
    ),
    practical(
        hub_id="viet-money-how-much",
        family_id="money-how-much",
        coverage_moment="money",
        summary="Use this when pointing at one item so the price conversation starts with the exact object, not vague bargaining.",
        confirm_detail=[
            "Keep the item or screen visible so nobody guesses which thing you mean.",
            "If the number comes too fast, switch into a number or write-it-down repair without hesitation.",
        ],
        what_to_show=[
            "Point at the exact item, tray, or screen line before asking the price.",
            "If the answer changes, show the earlier quote or calculator screen instead of arguing from memory.",
        ],
        local_reality=[
            "Price checks usually become a chain of number clarifications, final-price checks, and payment choices.",
            "A calm follow-up works better than turning the first quote into a full bargaining speech.",
        ],
        likely_reply=[
            edge("repair-number", "The next moment is usually catching the number accurately, not talking more."),
        ],
        repair_if_missed=[
            edge("repair-write-down", "Written numbers are the cleanest way to keep price talk honest."),
            edge("v500-unde-repa-can-you-write-the-price", "If the amount is still fuzzy, ask directly for the price in writing."),
        ],
        ask_next=[
            edge("money-final-price", "After the first quote, the next practical move is often the final-price check."),
            edge("money-total", "If there is more than one item in play, jump to the full total before deciding."),
        ],
        cross_class_exit=[
            edge("food-pay-now", "If you are already holding the item or dish, the conversation may slide straight into payment."),
        ],
        alternate_phrase_ids=["money-how-much-common"],
    ),
    practical(
        hub_id="viet-money-final-price",
        family_id="money-final-price",
        coverage_moment="money",
        summary="Use this when you need the number that actually closes the decision, not the first loose quote in the air.",
        confirm_detail=[
            "Watch for service charges, add-ons, or changed numbers once the seller thinks you are committed.",
            "If the answer still sounds slippery, move straight to itemized, written, or included-fee checks.",
        ],
        what_to_show=[
            "Show the item, cart, or calculator screen so the final price ties to one clear thing.",
            "If a fee appeared late, point at the line or screen where the total changed.",
        ],
        local_reality=[
            "If the number changes, move quickly into fee, total, or written-bill follow-ups.",
            "The goal is to lock the real number before you agree or hand over money.",
        ],
        likely_reply=[
            edge("money-what-fee", "If the total jumps, the next staff explanation is often about a fee or extra line."),
            edge("money-service-included", "A service-included check is a common follow-up before payment lands."),
        ],
        repair_if_missed=[
            edge("repair-write-down", "A written total protects you better than repeating the same number aloud."),
            edge("repair-number", "If only the digits are unclear, a number replay is the fastest repair."),
        ],
        ask_next=[
            edge("b2-money-itemized-bill", "If the total still feels wrong, an itemized bill is the cleanest next branch."),
            edge("food-pay-now", "Once the final number is clear, the conversation usually moves into payment."),
        ],
        cross_class_exit=[
            edge("service-receipt", "If the total is settled, jump to the receipt request instead of reopening the price."),
        ],
    ),
    practical(
        hub_id="viet-hotel-reservation",
        family_id="hotel-reservation",
        coverage_moment="hotel",
        summary="Lead with the reservation so the desk knows you already belong in the system before the check-in details start.",
        confirm_detail=[
            "Be ready for the name, booking code, or passport follow-up the moment the staff start searching.",
            "If the lookup stalls, move into spelling or writing instead of repeating the same sentence louder.",
        ],
        what_to_show=[
            "Hold the booking confirmation, reservation app, or email ready before you speak.",
            "If the desk cannot find it, show the code or name spelling on the phone screen immediately.",
        ],
        local_reality=[
            "Reservation pages live or die on the next-step rails: check in, fix the booking, or hand over proof.",
            "Keep the next desk move obvious so the booking conversation does not drift into repetition.",
        ],
        likely_reply=[
            edge("hotel-check-in", "If the booking is found, the natural reply branch is moving straight into check-in."),
            edge("v500-hote-acco-here-is-my-passport-for-check-in", "Desk staff often pivot immediately to ID or supporting proof."),
        ],
        repair_if_missed=[
            edge("repair-spell-name", "Names and booking codes are where the desk usually needs repair help."),
            edge("repair-write-down", "Written details beat repeated speech when the desk is busy or noisy."),
        ],
        ask_next=[
            edge("hotel-booking-wrong", "If the booking is not matching, surface the booking-problem page right away."),
            edge("hotel-room-not-ready", "Sometimes the reservation exists but the real next issue is room readiness."),
        ],
        cross_class_exit=[
            edge("help-call-hotel", "If you are away from the desk and need someone else to intervene, move to the hotel-contact help page."),
        ],
    ),
    practical(
        hub_id="viet-hotel-check-in",
        family_id="hotel-check-in",
        coverage_moment="hotel",
        summary="Use this once the reservation is established and you want the desk to move from searching into actually giving you the room.",
        confirm_detail=[
            "Be ready for deposit, passport, room type, or timing follow-ups as soon as staff accept the request.",
            "If the desk looks confused, give the missing name, date, or number instead of repeating everything.",
        ],
        what_to_show=[
            "Keep the booking confirmation and passport visible before the phrase lands.",
            "If the desk asks for payment, point to the card, cash, or earlier confirmation of what was included.",
        ],
        local_reality=[
            "Check-in pages work best when they bridge straight into room details, deposit questions, or booking mismatch fixes.",
            "Keep the next desk move concrete so the booking problem turns into action instead of repetition.",
        ],
        likely_reply=[
            edge("hotel-reservation", "If the desk did not catch the setup, they often bounce back to the reservation itself."),
            edge("v500-hote-acco-do-you-need-a-deposit", "A deposit or payment question is a common immediate desk follow-up."),
        ],
        repair_if_missed=[
            edge("repair-write-down", "Written names, dates, or codes rescue check-in faster than repetition."),
            edge("repair-spell-name", "Spelling the guest name is often the difference between found and missing."),
        ],
        ask_next=[
            edge("hotel-checkout-time", "Once the room is real, the next practical timing question is often checkout."),
            edge("hotel-quiet-room", "If room placement matters, ask for the preference before the key is issued."),
        ],
        cross_class_exit=[
            edge("money-final-price", "If the desk pushes price or deposit talk, move straight into the final-money page."),
        ],
        more_polite_phrase_id="hotel-check-in-polite",
        alternate_phrase_ids=["hotel-check-in-polite"],
    ),
    practical(
        hub_id="viet-hotel-room-hot",
        family_id="hotel-room-hot",
        coverage_moment="hotel",
        summary="Say the room problem plainly first so the staff hear the failure before you start proposing the fix.",
        confirm_detail=[
            "Know whether the issue is heat, broken air conditioning, or the need for a different room entirely.",
            "If you already tested the controls, say that quickly so the desk does not send you back to try the same thing.",
        ],
        what_to_show=[
            "Show the room number, key card sleeve, or booking screen so the staff know which room is affected.",
            "If the AC panel or broken setting matters, a phone photo can save time.",
        ],
        local_reality=[
            "Move quickly into fix-it, room-change, or the next room-problem branch if the desk does not solve it.",
            "Keep the next move clear so the problem turns into a fix, a room change, or the next concrete room issue.",
        ],
        likely_reply=[
            edge("hotel-aircon-broken", "Staff often need to know whether the heat problem is really the air conditioner failing."),
            edge("v500-hote-acco-can-someone-come-fix-it", "The next question is often whether someone can come repair it."),
        ],
        repair_if_missed=[
            edge("repair-understand", "If the desk replies with a long explanation, reset before guessing."),
            edge("repair-english-help", "If the staff understand the issue but the detail conversation stalls, ask for English help fast."),
        ],
        ask_next=[
            edge("hotel-no-hot-water", "Room-comfort complaints often stack, so the next real issue may be water or another utility failure."),
            edge("v500-hote-acco-can-i-change-rooms", "If the room stays unusable, move directly into the room-change request."),
        ],
        cross_class_exit=[
            edge("help-call-hotel", "If you are not at the desk, shift into the hotel-contact help path instead of staying stuck in complaint mode."),
        ],
    ),
    practical(
        hub_id="viet-airport-passport",
        family_id="v500-airp-bord-arri-here-is-my-passport",
        coverage_moment="airport",
        summary="This is the calm document handoff phrase for checkpoints where the passport itself is the real answer.",
        confirm_detail=[
            "Be ready for follow-ups about purpose of stay, length of stay, or where you are going next.",
            "If the officer still wants something else, switch quickly to the next document or form rather than explaining broadly.",
        ],
        what_to_show=[
            "Hold the passport open to the exact page before you speak.",
            "If the next step is digital proof, keep the booking or phone screen ready as backup.",
        ],
        local_reality=[
            "Airport document pages must stay object-first and fast, because the counter decides the rhythm.",
            "The page only works if it chains into the next checkpoint question instead of dying after one document line.",
        ],
        likely_reply=[
            edge("v500-airp-bord-arri-i-am-here-for-tourism", "Officers often move directly into why you are here once the passport is visible."),
            edge("v500-airp-bord-arri-i-will-stay-for-five-days", "Length-of-stay questions are a common next ask after the passport handoff."),
        ],
        repair_if_missed=[
            edge("repair-show-me", "If the officer wants a specific page or section, ask them to show you exactly what they need."),
            edge("repair-write-down", "A written gate, desk, or form instruction is safer than guessing under pressure."),
        ],
        ask_next=[
            edge("v500-airp-bord-arri-here-is-my-visa", "The next document is often the visa or travel permission itself."),
            edge("v900-airp-bord-arri-do-i-need-to-fill-out-this-form", "If the process is not finished, the next move may be handling a form."),
        ],
        cross_class_exit=[
            edge("transport-destination", "Once you clear the checkpoint, the practical next need may be getting to the hotel or pickup."),
        ],
    ),
    practical(
        hub_id="viet-airport-visa",
        family_id="v500-airp-bord-arri-here-is-my-visa",
        coverage_moment="airport",
        summary="Use this when the visa or permission is the exact document the checkpoint is waiting for, not just general proof.",
        confirm_detail=[
            "Know whether you also need the passport, booking, or form on the next beat.",
            "If the officer points at a screen or paper, follow that cue instead of adding more spoken detail.",
        ],
        what_to_show=[
            "Show the visa page, printout, or phone confirmation before trying to explain it.",
            "Keep the passport beside it so the officer can match the documents without more back-and-forth.",
        ],
        local_reality=[
            "Keep it tied to the next checkpoint move so the line keeps moving instead of stalling on one document question.",
            "Good rails here matter more than fancy copy because the interaction is document-led and time-sensitive.",
        ],
        likely_reply=[
            edge("v500-airp-bord-arri-i-am-here-for-tourism", "Purpose-of-trip questions often follow once the visa is visible."),
            edge("v500-airp-bord-arri-i-will-stay-for-five-days", "Stay-length questions are another common immediate checkpoint branch."),
        ],
        repair_if_missed=[
            edge("repair-show-me", "If the officer wants a different page or proof, ask them to show the exact requirement."),
            edge("repair-write-down", "Written instructions help when the checkpoint language is moving too fast."),
        ],
        ask_next=[
            edge("v500-airp-bord-arri-here-is-my-passport", "The passport often stays tied to the visa handoff as the next practical step."),
            edge("v500-airp-bord-arri-can-i-show-it-on-my-phone", "If the proof is digital, be ready to pivot into the phone-display page."),
        ],
        cross_class_exit=[
            edge("v500-airp-bord-arri-where-is-the-atm", "Once you clear the checkpoint, the next arrival need may immediately become cash access."),
        ],
    ),
    practical(
        hub_id="viet-airport-atm",
        family_id="v500-airp-bord-arri-where-is-the-atm",
        coverage_moment="airport",
        summary="Ask for the ATM as an arrival utility question, not as part of a bigger speech about money problems.",
        confirm_detail=[
            "Be ready to clarify whether you need cash right now, a currency exchange, or a nearby bank machine.",
            "If the direction answer is vague, switch into a pointing or map-based follow-up immediately.",
        ],
        what_to_show=[
            "Point at the arrivals hall or a nearby sign if you want the closest machine, not a general area.",
            "Show cash or a payment screen only if the real problem is how you will pay next.",
        ],
        local_reality=[
            "Airport utility pages need strong direction and next-step rails because the answer is often physical movement, not more language.",
            "Once the cash question is answered, be ready to move straight into SIM, ride, or payment follow-ups.",
        ],
        likely_reply=[
            edge("v900-airp-bord-arri-where-is-the-information-desk", "If the staff cannot answer directly, they may redirect you to the information desk."),
            edge("v900-airp-bord-arri-where-is-the-currency-exchange", "A nearby exchange counter is a common alternate answer when the ATM is not convenient."),
        ],
        repair_if_missed=[
            edge("directions-map-pin", "If the spoken route is messy, move the answer onto a map immediately."),
            edge("repair-show-me", "A pointing or show-me repair is often faster than another verbal explanation."),
        ],
        ask_next=[
            edge("transport-fare", "Once you have cash, the next need may be settling the first ride fare."),
            edge("v500-phon-inte-powe-where-can-i-get-a-local-sim-card", "Arrival errands often chain directly from cash to SIM help."),
        ],
        cross_class_exit=[
            edge("money-how-much", "If the conversation becomes about costs instead of directions, jump into the price page."),
        ],
    ),
    practical(
        hub_id="viet-transport-meter",
        family_id="transport-meter",
        coverage_moment="transport",
        summary="Use this at the start of the ride so the pricing rule is set before the car gets far from pickup.",
        confirm_detail=[
            "If the driver pushes back, be ready to shift into total-price or app-price follow-ups instead of repeating yourself.",
            "Keep the ask short enough that it still works in a noisy curbside moment.",
        ],
        what_to_show=[
            "Point at the meter, dashboard, or app price so the pricing standard is visible.",
            "If the route is in the app, keep that screen open to avoid parallel arguments about destination and money.",
        ],
        local_reality=[
            "Meter pages matter because ride pricing problems escalate fast once the car is already moving.",
            "If the first meter request does not settle the ride, be ready to switch into fare, app-price, or stop-here follow-ups.",
        ],
        likely_reply=[
            edge("v900-tran-is-that-the-total-price", "If the driver quotes a flat amount instead, the next issue is whether that total is acceptable."),
            edge("transport-fare", "A meter refusal often forces the conversation back to an explicit fare quote."),
        ],
        repair_if_missed=[
            edge("repair-understand", "If the driver explains too quickly, reset before you accidentally agree."),
            edge("repair-write-down", "A written or shown number is safer than half-heard ride talk."),
        ],
        ask_next=[
            edge("transport-destination", "Once the price rule is clear, the destination returns as the main traveler task."),
            edge("transport-stop-here", "Later in the ride, the next practical branch is usually where to stop."),
        ],
        cross_class_exit=[
            edge("v900-tran-please-use-the-price-in-the-grab-app", "If the ride is app-based, pivot into the app-price page instead of arguing abstractly."),
        ],
    ),
    practical(
        hub_id="viet-food-need-table",
        family_id="food-need-table",
        coverage_moment="food",
        summary="Use this when seating is the real first blocker, before menu talk or dish questions even matter.",
        confirm_detail=[
            "Know whether you need one table now, a size change, or simply to be seated at all.",
            "If the host is juggling options, a short which-one or show-me follow-up will help more than extra detail.",
        ],
        what_to_show=[
            "Use your fingers to show party size while you speak.",
            "Point at an open table only if you need to confirm whether that specific spot is available.",
        ],
        local_reality=[
            "Seating pages are strongest when they hand off immediately into menu or constraint choices.",
            "Keep it focused on getting seated so the conversation can move quickly into the menu or first order step.",
        ],
        likely_reply=[
            edge("food-menu", "Once the seating problem is solved, the menu is usually the next staff move."),
        ],
        repair_if_missed=[
            edge("repair-show-me", "If the host is motioning or naming locations quickly, ask them to show you."),
            edge("repair-which-one", "When several tables or areas are in play, clarify the exact one."),
        ],
        ask_next=[
            edge("food-menu", "The next useful tap is usually opening the menu flow immediately."),
            edge("food-not-spicy", "If you already know the main constraint, move there once seating is handled."),
        ],
        cross_class_exit=[
            edge("food-pay-now", "If the place cannot seat you, the next practical move may be wrapping up a takeaway or quick purchase instead."),
        ],
    ),
    practical(
        hub_id="viet-food-pay-now",
        family_id="food-pay-now",
        coverage_moment="food",
        summary="Use this to close the meal cleanly once you are done, without reopening the whole ordering conversation.",
        confirm_detail=[
            "Be ready for the total, service charge, or receipt branch the moment staff bring the bill.",
            "If the number is unclear, move into price repair right away instead of nodding and hoping it is fine.",
        ],
        what_to_show=[
            "Point at the bill, table slip, or payment machine so the amount in question is visible.",
            "Show cash or card only after the total and extra fees are clear enough to trust.",
        ],
        local_reality=[
            "Payment pages work best when they flow into total, receipt, and included-fee checks without drama.",
            "Keep it brisk and practical, because most travelers want to settle the meal and move on.",
        ],
        likely_reply=[
            edge("money-final-price", "The first reply branch is often the total you are actually expected to pay."),
            edge("service-receipt", "A receipt or bill handoff often follows immediately once payment starts."),
        ],
        repair_if_missed=[
            edge("repair-number", "If only the amount is hard to catch, a number replay is enough."),
            edge("repair-write-down", "If the bill still feels murky, get the amount in writing or on the screen."),
        ],
        ask_next=[
            edge("money-service-included", "Service-charge questions often surface right before you hand over money."),
            edge("polite-thank-you", "Once payment is settled, the clean exit is usually gratitude and departure."),
        ],
        cross_class_exit=[
            edge("food-bottled-water", "If you only needed a drink or one item, the payment branch can loop back into that narrower ask."),
        ],
    ),
    practical(
        hub_id="viet-hotel-checkout-time",
        family_id="hotel-checkout-time",
        coverage_moment="hotel",
        summary="Ask this early so the last-day plan stays under your control instead of becoming a rushed desk problem.",
        confirm_detail=[
            "If timing sounds vague, lock down the exact hour before you build the rest of the day around it.",
            "Be ready to ask about late checkout or luggage storage if the normal time does not work for your trip.",
        ],
        what_to_show=[
            "Show the booking or departure plan only if you need the staff to see why timing matters.",
            "If you are comparing options, a phone calendar or flight screen can make the ask clearer.",
        ],
        local_reality=[
            "Checkout-time pages should push directly into late checkout or bag-storage branches.",
            "Timing mistakes at hotels turn into real travel costs fast, so keep the follow-up simple and immediate.",
        ],
        likely_reply=[
            edge("repair-time-exact", "If the answer sounds loose, the next move is asking for the exact hour."),
            edge("hotel-late-checkout", "A late-checkout possibility is one of the most common follow-up branches."),
        ],
        repair_if_missed=[
            edge("repair-write-down", "A written time is safer than trusting a half-heard number."),
            edge("repair-number", "If only the hour got lost, use the number replay instead of restarting the whole question."),
        ],
        ask_next=[
            edge("hotel-luggage", "If checkout comes before your ride, bag storage is often the next real need."),
            edge("hotel-late-checkout", "If the standard hour is too early, move immediately into the late-checkout request."),
        ],
        cross_class_exit=[
            edge("transport-destination", "Once the room timing is fixed, the next practical task may be the ride to your next stop."),
        ],
    ),
    practical(
        hub_id="viet-hotel-aircon-broken",
        family_id="hotel-aircon-broken",
        coverage_moment="hotel",
        summary="Use this when the problem is clearly the air conditioner, not just a general comfort complaint.",
        confirm_detail=[
            "Say whether the unit is dead, weak, or running without cooling if that changes the response you need.",
            "If the staff start troubleshooting too quickly, be ready to ask for a person, not another guess.",
        ],
        what_to_show=[
            "Show the room number and, if needed, a photo or the control panel so the failure looks real immediately.",
            "Point at the unit or thermostat if a staff member comes to the room and still seems unsure.",
        ],
        local_reality=[
            "Be ready to push into fix-it or room-change follow-ups if the desk does not solve it immediately.",
            "A broken AC can become a sleep and safety issue quickly, so the next step must stay obvious.",
        ],
        likely_reply=[
            edge("v500-hote-acco-can-someone-come-fix-it", "Staff often answer by offering to send someone up to inspect it."),
            edge("hotel-room-hot", "If the desk does not understand the hardware failure, the simpler room-hot complaint can still anchor the issue."),
        ],
        repair_if_missed=[
            edge("repair-understand", "If the explanation coming back is too fast or technical, reset the conversation first."),
            edge("repair-english-help", "Ask for English help if the fix discussion keeps slipping past you."),
        ],
        ask_next=[
            edge("v500-hote-acco-can-i-change-rooms", "If the fix is not immediate, room change is the strongest next branch."),
            edge("hotel-no-hot-water", "If the AC is not the only problem, say the next room issue clearly right away."),
        ],
        cross_class_exit=[
            edge("help-call-hotel", "If you are talking to another helper instead of desk staff, shift into the hotel-contact help page."),
        ],
    ),
    practical(
        hub_id="viet-phone-local-sim",
        family_id="v500-phon-inte-powe-where-can-i-get-a-local-sim-card",
        coverage_moment="phone",
        summary="Use this when the phone problem is connectivity itself and the practical fix is getting local data moving again.",
        confirm_detail=[
            "Be ready to clarify whether you need to buy a SIM, activate it, or simply find the counter.",
            "If the answer turns directional, switch fast into map or show-me support instead of repeating the SIM question.",
        ],
        what_to_show=[
            "Show the phone, empty SIM tray, or current signal screen if that makes the ask easier to understand.",
            "If you already have a carrier app or booking screen, keep it ready only as proof, not as the first explanation.",
        ],
        local_reality=[
            "SIM pages matter because they often unlock maps, rides, payment, and translation all at once.",
            "The page should jump quickly into directions, payment, or map-recovery rails instead of staying abstract.",
        ],
        likely_reply=[
            edge("directions-how-to-get", "The first useful answer is often simply where to go for the SIM counter."),
            edge("phone-charge-here", "If the phone is also dying, charging can become part of the same support moment."),
        ],
        repair_if_missed=[
            edge("repair-show-me", "If the directions are fuzzy, ask the helper to point or show the place."),
            edge("repair-write-down", "A written shop name or carrier name is easier to reuse later."),
        ],
        ask_next=[
            edge("v500-phon-inte-powe-my-map-is-not-working", "Once the SIM problem is named, map recovery is a natural next branch."),
            edge("money-find-atm", "If buying the SIM becomes a cash issue, pivot straight into the ATM page."),
        ],
        cross_class_exit=[
            edge("v500-airp-bord-arri-where-is-the-atm", "Arrival errands often chain SIM trouble directly into cash access."),
        ],
    ),
    practical(
        hub_id="viet-phone-map-not-working",
        family_id="v500-phon-inte-powe-my-map-is-not-working",
        coverage_moment="phone",
        summary="Use this when the phone failed at the exact moment you needed route certainty, not as a generic tech complaint.",
        confirm_detail=[
            "Know whether the real fix is data, battery, a screenshot, or someone manually showing the route.",
            "If the helper starts over-explaining, move the problem onto a map, screen, or written address instead.",
        ],
        what_to_show=[
            "Open the dead map, destination, or screenshot so the other person sees the problem immediately.",
            "If you still have the address somewhere, hold it up so the route can continue without the app.",
        ],
        local_reality=[
            "Map-failure pages are valuable because they bridge tech trouble straight into real movement again.",
            "Keep the page focused on getting moving again, not on generic device troubleshooting.",
        ],
        likely_reply=[
            edge("directions-map-pin", "Helpers often answer by showing the place on a map instead of fixing the app."),
            edge("repair-show-me", "A point-it-out response is often more useful than a technical explanation."),
        ],
        repair_if_missed=[
            edge("repair-write-down", "If the route is still unclear, get the address or landmark in writing."),
            edge("repair-english-help", "If the route language gets too complicated, ask for English help before you wander."),
        ],
        ask_next=[
            edge("transport-destination", "If the app is dead, the next practical move may be handing the destination to a driver."),
            edge("v500-phon-inte-powe-where-can-i-get-a-local-sim-card", "If the root problem is data, the SIM page is the next bounded fix."),
        ],
        cross_class_exit=[
            edge("directions-how-to-get", "If you can still travel on foot or by landmarks, shift into the directions page."),
        ],
    ),
    greetings(
        hub_id="viet-greeting-goodbye",
        family_id="polite-goodbye",
        coverage_moment="greeting",
        summary="Use this when the practical part is over and you want to leave the interaction cleanly instead of fading out awkwardly.",
        core_bullets=[
            "Say it once when you are actually leaving, not while the other person is still solving the task.",
        ],
        use_cases=[
            "leaving a hotel desk",
            "walking away from a small shop",
            "ending a short helpful exchange",
        ],
        say_next_summary="A goodbye only works if the real task is finished or you are clearly transitioning to the next move.",
        likely_reply=[
            edge("polite-acknowledge", "The most common response is a short acknowledgment that lets the moment close."),
            edge("polite-thank-you", "Some exits loop through a final thank-you before the interaction ends."),
        ],
        repair_if_missed=[
            edge("repair-understand", "If the other person keeps talking as you leave, switch to repair instead of repeating goodbye."),
        ],
        ask_next=[
            edge("hotel-checkout", "At a hotel, goodbye often sits right next to the actual checkout request."),
            edge("transport-destination", "If you are leaving one interaction to start the next leg, the destination page may be next."),
        ],
        cross_class_exit=[
            edge("help-left-something", "If you are already turning away and realize something is missing, pivot immediately into the recovery phrase."),
        ],
    ),
    repair(
        hub_id="viet-repair-meaning",
        family_id="repair-meaning",
        summary="Use this when one word or phrase is blocking the whole situation and you need the missing meaning before anything else.",
        show_write=[
            "Point at the word, screen, or sign so the other person knows exactly what needs explaining.",
            "If the explanation is still vague, move the answer onto the phone, map, or paper instead of repeating the same question.",
        ],
        number_check=[
            "If the confusing part is really a time, amount, or room number, switch into the number-specific repair instead.",
            "Do not stay on this page if the blocker is just speed; that is a slower or simpler-words problem instead.",
        ],
        courtesy=[
            "Once the meaning lands, say thanks and move back into the main task quickly so the interaction keeps moving.",
            "Keep the repair narrow: one unclear phrase, one clean explanation, then back to the traveler need.",
        ],
        likely_reply=[
            edge("repair-show-me", "A good response often involves pointing or showing, not a longer abstract definition."),
            edge("repair-write-down", "Writing the key word is often the fastest way to make the meaning stick."),
        ],
        repair_if_missed=[
            edge("repair-slower", "If the explanation is still too fast, ask them to slow down instead of staying on the same loop."),
            edge("repair-understand", "If the whole conversation slips again, reset with the broader understanding repair."),
        ],
        ask_next=[
            edge("repair-translate-this", "If one phrase is still opaque, translation support may be the next practical move."),
            edge("repair-spell-name", "If the blocker is a name or place, spelling is often the better follow-up than more meaning talk."),
        ],
        cross_class_exit=[
            edge("food-menu", "Menu pages are a common place where one unknown word blocks the whole decision."),
        ],
    ),
    repair(
        hub_id="viet-repair-show-me",
        family_id="repair-show-me",
        summary="Use this when the fastest repair is visual: point at it, show it, or put it on the map instead of saying it again.",
        show_write=[
            "This is strongest when the other person can point to the route, menu item, or screen immediately.",
            "If they still talk instead of showing, move into writing or phone-based repair next.",
        ],
        number_check=[
            "If the problem is only the time, gate, or amount, a number-specific repair may be cleaner than a broad show-me ask.",
            "For locations, maps and pins usually work better than hand gestures alone.",
        ],
        courtesy=[
            "Once they show you, acknowledge it and move forward instead of reopening the repair loop.",
            "Keep the ask short so it still works in a crowded station, restaurant, or street moment.",
        ],
        likely_reply=[
            edge("directions-map-pin", "Map-based pointing is one of the most useful replies to a show-me request."),
            edge("food-menu", "At restaurants, the concrete answer is often simply showing the menu or the item."),
        ],
        repair_if_missed=[
            edge("repair-write-down", "If pointing is still unclear, get the word or detail in writing."),
            edge("repair-understand", "If the conversation is still drifting, reset before trying a third repair style."),
        ],
        ask_next=[
            edge("directions-how-to-get", "Once the place is shown, the next move is often the actual route question."),
            edge("service-scan-docs", "For document tasks, showing the file often rolls into scanning or handling it."),
        ],
        cross_class_exit=[
            edge("v500-phon-inte-powe-my-map-is-not-working", "Map trouble is a common reason this visual repair page exists at all."),
        ],
        alternate_phrase_ids=["repair-5"],
    ),
    repair(
        hub_id="viet-repair-spell-name",
        family_id="repair-spell-name",
        summary="Use this when the traveler problem is a name you must capture exactly, not just understand roughly.",
        show_write=[
            "Ask for spelling when you need to reuse the name later for a hotel, route, contact, or booking.",
            "If spelling still feels shaky, move it onto the phone or paper so you can show it again later.",
        ],
        number_check=[
            "If the problem is a time or price, ask them to write or repeat the number.",
            "Use it for people, places, hotels, and company names that must match exactly.",
        ],
        courtesy=[
            "Once the name is clear, go back to the question you needed answered.",
            "Keep it narrow so the conversation stays on the one name that has to be right.",
        ],
        likely_reply=[
            edge("repair-write-down", "People often solve this by writing the name instead of spelling it cleanly out loud."),
            edge("repair-type-phone", "Typing it on the phone is another common way the repair lands."),
        ],
        repair_if_missed=[
            edge("repair-understand", "If the spelling attempt still fails, reset the broader conversation first."),
            edge("repair-slower", "A slower second try may be all you need if the letters came too fast."),
        ],
        ask_next=[
            edge("hotel-reservation", "Captured names often feed straight back into booking and front-desk tasks."),
            edge("transport-destination", "Spelled place names are often the bridge back into the destination page."),
        ],
        cross_class_exit=[
            edge("service-scan-docs", "If the name lives on a document, the next move may be scanning or copying it."),
        ],
    ),
    urgent(
        hub_id="viet-urgent-passport-missing",
        family_id="emergency-passport-gone",
        coverage_moment="emergency",
        summary="Use this when the passport is missing and the problem has already crossed from inconvenience into a real travel emergency.",
        detail_bullets=[
            "Be ready to say whether it is lost, stolen, or simply not with you at the checkpoint or hotel.",
            "If you know the last place you had it, keep that detail ready for the next step after the first alert lands.",
        ],
        local_reality=[
            "Passport-loss pages matter because they quickly branch into police, embassy, airline, and hotel help.",
            "The first phrase must stay blunt and high-signal so nearby helpers know this is not a small inconvenience.",
        ],
        likely_reply=[
            edge("emergency-police-report", "A police report is a common first official branch once the passport loss is clear."),
            edge("emergency-embassy", "Embassy help is another immediate path once the loss is confirmed."),
        ],
        repair_if_missed=[
            edge("repair-english-help", "If the urgency lands but the details do not, ask for English help fast."),
            edge("repair-write-down", "Written names, numbers, and locations often become necessary immediately."),
        ],
        ask_next=[
            edge("emergency-police-report", "If someone can help, the next practical action is often filing the report."),
            edge("emergency-embassy", "If official help is needed now, embassy contact becomes the next page."),
        ],
        escalate_to=[
            edge("emergency-tourist-police", "Tourist police can be the stronger escalation branch when theft or visitor help is involved."),
        ],
        cross_class_exit=[
            edge("help-call-hotel", "If the passport may be back at the room, hotel-contact help can still be the fastest next move."),
        ],
        more_polite_phrase_id="emergency-passport-gone-polite",
        alternate_phrase_ids=["emergency-passport-gone-polite"],
    ),
    urgent(
        hub_id="viet-urgent-police-report",
        family_id="emergency-police-report",
        coverage_moment="emergency",
        summary="Use this when the emergency now needs an official written record, not just vague help from bystanders or staff.",
        detail_bullets=[
            "Use it when a stolen item, missing document, or scam now needs a formal report.",
            "Be ready to add what is missing and where it happened once someone agrees to help you file it.",
        ],
        local_reality=[
            "Police-report pages are valuable because they bridge emergency language into the real paperwork path travelers need.",
            "Keep the tone procedural and action-first, because the goal is the report and the next official step.",
        ],
        likely_reply=[
            edge("emergency-tourist-police", "Helpers may redirect you to the tourist police or the right reporting channel."),
            edge("emergency-police-station", "The practical reply may be taking you to the station where the report can happen."),
        ],
        repair_if_missed=[
            edge("repair-write-down", "Written names, numbers, and timelines are often needed immediately for the report."),
            edge("repair-english-help", "If the reporting conversation goes beyond your language comfort, ask for English help early."),
        ],
        ask_next=[
            edge("emergency-passport-gone", "Missing-document reports often loop back into identifying exactly what is gone."),
            edge("emergency-wallet-stolen", "If the missing item is money or cards, the wallet-theft branch may be the next precise page."),
        ],
        escalate_to=[
            edge("emergency-embassy", "If the report is for a document crisis, embassy help can be the next stronger branch."),
        ],
        cross_class_exit=[
            edge("help-call-this-number", "If a nearby helper needs to call someone on your behalf, move into the phone-help page quickly."),
        ],
        clearer_phrase_id="emergency-police-report-clearer",
        alternate_phrase_ids=["emergency-police-report-clearer"],
    ),
    practical(
        hub_id="viet-service-scan-docs",
        family_id="service-scan-docs",
        coverage_moment="service",
        summary="Use this when the job is turning paper into a usable digital file, not just printing or copying for the counter.",
        confirm_detail=[
            "Know whether you need a scan only, a copy too, or the file emailed after it is captured.",
            "If the staff can scan but not send it, be ready to pivot into the email or print follow-up immediately.",
        ],
        what_to_show=[
            "Put the exact document on the counter or hold it open before you ask.",
            "If the file needs to go somewhere specific, keep the email address or phone ready on screen.",
        ],
        local_reality=[
            "Service-document pages feel real only when they chain into copy, email, print, and payment rails.",
            "Keep the follow-up task-focused so the staff understand the scan job, not just the document itself.",
        ],
        likely_reply=[
            edge("service-email-file", "The most common follow-up is how the scanned file will get back to you."),
            edge("service-copy-docs", "A service counter may also offer a copy-first path before or alongside the scan."),
        ],
        repair_if_missed=[
            edge("repair-show-me", "If the staff do not understand the task, point at the document and machine workflow directly."),
            edge("repair-write-down", "Written file names, email addresses, or counts can rescue the task quickly."),
        ],
        ask_next=[
            edge("service-email-file", "If the scan works, emailing it out is often the next actual step."),
            edge("service-print", "Sometimes the scan task immediately turns into a print or reprint need."),
        ],
        cross_class_exit=[
            edge("money-final-price", "Once the document task is defined, the next practical question is often the total price."),
        ],
        clearer_phrase_id="service-scan-docs-clearer",
        alternate_phrase_ids=["service-scan-docs-clearer"],
    ),
]


def enrich_hub_spec(hub):
    anchor_phrase_id = phrase_for_family(hub["familyId"])
    clearer_phrase_id = hub.get("clearerPhraseId") or maybe_phrase_for_family(hub["familyId"], "clearer")
    more_polite_phrase_id = hub.get("morePolitePhraseId") or maybe_phrase_for_family(hub["familyId"], "more-polite")
    alternate_phrase_ids = dedupe(
        (hub.get("alternatePhraseIds") or [])
        + [phrase_id for phrase_id in [clearer_phrase_id, more_polite_phrase_id] if phrase_id]
    )
    enriched = dict(hub)
    enriched["anchorPhraseId"] = anchor_phrase_id
    enriched["defaultPhraseId"] = anchor_phrase_id
    enriched["quickSayPhraseId"] = anchor_phrase_id
    enriched["clearerPhraseId"] = clearer_phrase_id
    enriched["morePolitePhraseId"] = more_polite_phrase_id
    enriched["alternatePhraseIds"] = alternate_phrase_ids
    for bucket_name, items in enriched["relationBuckets"].items():
        new_items = []
        for item in items:
            new_item = dict(item)
            if not new_item.get("targetPhraseId"):
                new_item["targetPhraseId"] = phrase_for_family(new_item["targetFamilyId"])
            new_items.append(new_item)
        enriched["relationBuckets"][bucket_name] = new_items
    return enriched


CLASS_ORDER = [
    "greetings-social",
    "urgent-help-medical",
    "repair-clarification",
    "practical-service-navigation",
]


def make_module(module_id, module_type, required, source_phrase_ids, source_family_ids, relation_refs, summary, bullets):
    return {
        "moduleId": module_id,
        "type": module_type,
        "required": required,
        "sourcePhraseIds": dedupe(source_phrase_ids),
        "sourceFamilyIds": dedupe(source_family_ids),
        "relationRefs": relation_refs,
        "content": {
            "summary": summary,
            "bullets": bullets,
        },
    }


def relation_microcopy(prefix, items):
    return [item["reason"] for item in items]


def urgent_core_bullet(hub):
    return {
        "emergency": "Say the emergency first and let the details follow once someone is helping.",
    }.get(hub.get("coverageMoment"), "Lead with the urgent phrase first and save extra detail for the next breath.")


def practical_core_bullet(hub):
    return {
        "transport": "Say it while the ride, stop, or price decision is still in front of both of you.",
        "food": "Use it before the order, table, or bill moment slides past you.",
        "money": "Keep the number, item, or screen visible while you ask.",
        "hotel": "Use it while the desk or room issue is still easy for staff to verify.",
        "airport": "Keep the document, checkpoint, or arrival screen visible while you say it.",
        "phone": "Show the phone, map, or signal problem while you ask.",
        "service": "Put the document or item on the counter before you ask.",
    }.get(hub.get("coverageMoment"), "Open with the task phrase while the key object, destination, or screen is already visible.")


def build_modules(hub):
    common_phrases = dedupe(
        [hub["anchorPhraseId"], hub["defaultPhraseId"], hub["quickSayPhraseId"], hub.get("clearerPhraseId"), hub.get("morePolitePhraseId")]
        + hub.get("alternatePhraseIds", [])
    )
    family = hub["familyId"]
    class_name = hub["phraseClass"]
    if class_name == "greetings-social":
        return [
            make_module(
                "core-phrase",
                "core-phrase",
                True,
                common_phrases,
                [family],
                [],
                hub["summary"],
                hub["coreBullets"],
            ),
            make_module(
                "social-use-case",
                "social-use-case",
                True,
                common_phrases,
                [family],
                [],
                "Keep the social moment short and situational.",
                hub["useCases"],
            ),
            make_module(
                "likely-reply",
                "likely-reply",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["likelyReply"]],
                ["likelyReply"],
                "Be ready for the immediate answer or social acknowledgment.",
                relation_microcopy("likelyReply", hub["relationBuckets"]["likelyReply"]),
            ),
            make_module(
                "say-next",
                "say-next",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["askNext"] + hub["relationBuckets"]["crossClassExit"]],
                ["askNext", "crossClassExit"],
                hub["sayNextSummary"],
                relation_microcopy("askNext", hub["relationBuckets"]["askNext"]) + relation_microcopy("crossClassExit", hub["relationBuckets"]["crossClassExit"]),
            ),
            make_module(
                "graceful-exit",
                "graceful-exit",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["repairIfMissed"]],
                ["repairIfMissed"],
                "If the conversation does not land cleanly, leave the social layer and repair it.",
                relation_microcopy("repairIfMissed", hub["relationBuckets"]["repairIfMissed"]),
            ),
        ]
    if class_name == "urgent-help-medical":
        return [
            make_module(
                "urgent-core",
                "urgent-core",
                True,
                common_phrases,
                [family],
                [],
                hub["summary"],
                [urgent_core_bullet(hub)],
            ),
            make_module(
                "risk-or-symptom-detail",
                "risk-or-symptom-detail",
                True,
                common_phrases,
                [family],
                [],
                "Add only the detail that changes the response.",
                hub["detailBullets"],
            ),
            make_module(
                "likely-reply",
                "likely-reply",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["likelyReply"]],
                ["likelyReply"],
                "Be ready for the helper's first practical response.",
                relation_microcopy("likelyReply", hub["relationBuckets"]["likelyReply"]),
            ),
            make_module(
                "immediate-next-step",
                "immediate-next-step",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["askNext"] + hub["relationBuckets"]["crossClassExit"]],
                ["askNext", "crossClassExit"],
                "Have the next actionable phrase ready once someone responds.",
                relation_microcopy("askNext", hub["relationBuckets"]["askNext"]) + relation_microcopy("crossClassExit", hub["relationBuckets"]["crossClassExit"]),
            ),
            make_module(
                "local-reality",
                "local-reality",
                True,
                common_phrases,
                [family],
                [],
                "These moments usually turn practical very quickly on the ground.",
                hub["localReality"],
            ),
            make_module(
                "repair-branch",
                "repair-branch",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["repairIfMissed"]],
                ["repairIfMissed"],
                "If they still look confused, clear it up fast.",
                relation_microcopy("repairIfMissed", hub["relationBuckets"]["repairIfMissed"]),
            ),
            make_module(
                "safety-escalation",
                "safety-escalation",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["escalateTo"]],
                ["escalateTo"],
                "If the first ask is not enough, escalate without delay.",
                relation_microcopy("escalateTo", hub["relationBuckets"]["escalateTo"]),
            ),
        ]
    if class_name == "repair-clarification":
        return [
            make_module(
                "repair-core",
                "repair-core",
                True,
                common_phrases,
                [family],
                [],
                hub["summary"],
                ["Use the smallest repair that actually fixes the conversation."],
            ),
            make_module(
                "show-or-write",
                "show-or-write",
                True,
                common_phrases,
                [family],
                [],
                "Visual or written backup often solves the problem faster than a third spoken try.",
                hub["showWrite"],
            ),
            make_module(
                "number-check",
                "number-check",
                True,
                common_phrases,
                [family],
                [],
                "Numbers, names, and exact details often need their own repair branch once the main issue is exposed.",
                hub["numberCheck"],
            ),
            make_module(
                "likely-response",
                "likely-response",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["likelyReply"]],
                ["likelyReply"],
                "These are the most common ways the conversation may move after the repair starts working.",
                relation_microcopy("likelyReply", hub["relationBuckets"]["likelyReply"]),
            ),
            make_module(
                "next-try",
                "next-try",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["askNext"] + hub["relationBuckets"]["crossClassExit"]],
                ["askNext", "crossClassExit"],
                "Once the current repair does its job, move to the next useful branch or back to the original task.",
                relation_microcopy("askNext", hub["relationBuckets"]["askNext"]) + relation_microcopy("crossClassExit", hub["relationBuckets"]["crossClassExit"]),
            ),
            make_module(
                "courtesy-close",
                "courtesy-close",
                True,
                common_phrases,
                [family],
                [],
                "Close the repair loop quickly so the interaction can keep moving.",
                hub["courtesy"],
            ),
        ]
    if class_name == "practical-service-navigation":
        return [
            make_module(
                "task-core",
                "task-core",
                True,
                common_phrases,
                [family],
                [],
                hub["summary"],
                [practical_core_bullet(hub)],
            ),
            make_module(
                "operator-question",
                "operator-question",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["likelyReply"]],
                ["likelyReply"],
                "These are the common follow-up questions or confirmations that usually come back next.",
                relation_microcopy("likelyReply", hub["relationBuckets"]["likelyReply"]),
            ),
            make_module(
                "confirm-detail",
                "confirm-detail",
                True,
                common_phrases,
                [family],
                [],
                "Have the one detail ready that keeps the task from stalling.",
                hub["confirmDetail"],
            ),
            make_module(
                "what-to-show",
                "what-to-show",
                True,
                common_phrases,
                [family],
                [],
                "A map, ticket, document, or screen often carries more weight than extra speech.",
                hub["whatToShow"],
            ),
            make_module(
                "local-reality",
                "local-reality",
                True,
                common_phrases,
                [family],
                [],
                "On-the-ground service and navigation moments usually hinge on one practical detail.",
                hub["localReality"],
            ),
            make_module(
                "next-step",
                "next-step",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["askNext"] + hub["relationBuckets"]["crossClassExit"]],
                ["askNext", "crossClassExit"],
                "Keep the next usable traveler move one tap away.",
                relation_microcopy("askNext", hub["relationBuckets"]["askNext"]) + relation_microcopy("crossClassExit", hub["relationBuckets"]["crossClassExit"]),
            ),
            make_module(
                "fallback",
                "fallback",
                True,
                [hub["defaultPhraseId"]],
                [item["targetFamilyId"] for item in hub["relationBuckets"]["repairIfMissed"]],
                ["repairIfMissed"],
                "If the first try is not landing, clear up the missing detail in the simplest way.",
                relation_microcopy("repairIfMissed", hub["relationBuckets"]["repairIfMissed"]),
            ),
        ]
    raise ValueError(f"unknown class: {class_name}")


RELATION_TYPE_BY_BUCKET = {
    "likelyReply": "likely_answer_to",
    "repairIfMissed": "repair_for",
    "askNext": "next_step_after",
    "escalateTo": "escalation_for",
    "crossClassExit": "see_also",
}


MODULE_BUCKETS = {
    "likely-reply": ["likelyReply"],
    "likely-response": ["likelyReply"],
    "operator-question": ["likelyReply"],
    "say-next": ["askNext", "crossClassExit"],
    "next-try": ["askNext", "crossClassExit"],
    "immediate-next-step": ["askNext", "crossClassExit"],
    "next-step": ["askNext", "crossClassExit"],
    "graceful-exit": ["repairIfMissed"],
    "repair-branch": ["repairIfMissed"],
    "fallback": ["repairIfMissed"],
    "safety-escalation": ["escalateTo"],
}


RELATION_ONLY_FAMILY_REDIRECTS = {
    "health-doctor": "emergency-hospital",
    "help-call-hotel": "hotel-reservation",
    "directions-right-route": "directions-map-pin",
    "repair-translate-this": "repair-meaning",
    "emergency-embassy": "emergency-passport-gone",
    "emergency-manager-now": "emergency-police-report",
    "emergency-call-help": "emergency-ambulance",
    "emergency-get-away": "emergency-following-me",
    "emergency-police": "emergency-police-report",
    "v900-tran-is-that-the-total-price": "money-final-price",
    "money-service-included": "money-final-price",
    "service-receipt": "service-scan-docs",
    "v500-hote-acco-can-someone-come-fix-it": "hotel-aircon-broken",
    "hotel-no-hot-water": "hotel-room-hot",
    "v500-hote-acco-can-i-change-rooms": "hotel-room-hot",
    "v500-airp-bord-arri-i-am-here-for-tourism": "v500-airp-bord-arri-here-is-my-visa",
    "v500-airp-bord-arri-i-will-stay-for-five-days": "v500-airp-bord-arri-here-is-my-visa",
    "hotel-late-checkout": "hotel-checkout-time",
    "emergency-tourist-police": "emergency-police-report",
    "v500-heal-phar-how-do-i-take-this": "health-pharmacy",
    "v900-heal-phar-please-write-the-instructions": "repair-write-down",
    "health-allergy": "health-pharmacy",
    "service-water": "food-bottled-water",
    "v500-unde-repa-can-you-write-the-price": "repair-write-down",
    "money-total": "money-final-price",
    "money-what-fee": "money-final-price",
    "b2-money-itemized-bill": "money-final-price",
    "v500-hote-acco-here-is-my-passport-for-check-in": "hotel-check-in",
    "hotel-booking-wrong": "hotel-reservation",
    "hotel-room-not-ready": "hotel-check-in",
    "v500-hote-acco-do-you-need-a-deposit": "hotel-check-in",
    "hotel-quiet-room": "hotel-room-hot",
    "v900-airp-bord-arri-do-i-need-to-fill-out-this-form": "v500-airp-bord-arri-here-is-my-visa",
    "v500-airp-bord-arri-can-i-show-it-on-my-phone": "v500-airp-bord-arri-here-is-my-passport",
    "v900-airp-bord-arri-where-is-the-information-desk": "v500-airp-bord-arri-here-is-my-passport",
    "v900-airp-bord-arri-where-is-the-currency-exchange": "v500-airp-bord-arri-where-is-the-atm",
    "v900-tran-please-use-the-price-in-the-grab-app": "transport-fare",
    "repair-which-one": "repair-show-me",
    "repair-time-exact": "repair-number",
    "hotel-luggage": "hotel-check-in",
    "phone-charge-here": "v500-phon-inte-powe-my-map-is-not-working",
    "money-find-atm": "v500-airp-bord-arri-where-is-the-atm",
    "hotel-checkout": "hotel-checkout-time",
    "help-left-something": "emergency-passport-gone",
    "repair-type-phone": "repair-spell-name",
    "emergency-police-station": "emergency-police-report",
    "emergency-wallet-stolen": "emergency-police-report",
    "help-call-this-number": "emergency-police-report",
    "service-copy-docs": "service-scan-docs",
}


CLUSTER_BUCKET_OVERRIDES = {
    "viet-greeting-thank-you": {
        "crossClassExit": [],
    },
    "viet-greeting-acknowledge": {
        "likelyReply": [
            (
                "social-how-are-you",
                "A polite acknowledgment often gets followed by one more easy social question before the real task starts.",
            ),
        ],
    },
    "viet-urgent-ambulance": {
        "crossClassExit": [],
    },
    "viet-medical-trouble-breathing": {
        "likelyReply": [
            (
                "emergency-hospital",
                "A helper may steer you straight to the nearest hospital once the breathing problem is clear.",
            ),
        ],
        "askNext": [
            (
                "health-doctor",
                "If the ambulance is not already moving, asking for a doctor or urgent medical help may be the next workable branch.",
            ),
        ],
        "escalateTo": [
            (
                "emergency-ambulance",
                "Do not stay in a pharmacy-only flow if breathing is getting harder; escalate to ambulance help immediately.",
            ),
        ],
        "crossClassExit": [],
    },
    "viet-repair-english-help": {
        "repairIfMissed": [
            (
                "repair-understand",
                "If partial English starts but still breaks down, reset the repair clearly instead of guessing.",
            ),
        ],
        "askNext": [
            (
                "repair-show-me",
                "If words are still failing, move straight to pointing or having them show you the thing in question.",
            ),
            (
                "directions-map-pin",
                "A map pin or photo can still carry the task when shared language is thin.",
            ),
        ],
    },
}


FAMILY_SUMMARY_OVERRIDES = {
    "emergency-ambulance": "Call this when urgent medical transport is needed right away.",
    "v900-heal-phar-i-have-trouble-breathing": "Say this when breathing trouble is the emergency and help needs to speed up now.",
    "v500-hote-acco-can-someone-come-fix-it": "Use this when you need hotel staff to come fix the problem.",
    "v500-hote-acco-can-i-change-rooms": "Use this when the room problem is bad enough that you need another room.",
    "repair-slower": "Use this when you need the other person to slow down, not change the subject.",
}


def preferred_row_for_family(family_id):
    for row in family_rows.get(family_id, []):
        if row["variant_role"] == "say-first" and row["status"] == "approved":
            return row
    for row in family_rows.get(family_id, []):
        if row["status"] == "approved":
            return row
    return family_rows[family_id][0]


def normalized_family_summary(family_id):
    if family_id in FAMILY_SUMMARY_OVERRIDES:
        return FAMILY_SUMMARY_OVERRIDES[family_id]
    row = preferred_row_for_family(family_id)
    summary = (row.get("family_summary") or "").strip()
    if not summary.startswith("Ask this when you need"):
        return summary
    context = (row.get("context") or "").strip()
    if context:
        return context if context.endswith(".") else f"{context}."
    english = (row.get("english_text") or row.get("family_title") or "").strip().rstrip(".?!")
    if not english:
        return summary
    stem = english[:1].lower() + english[1:]
    verb = "ask" if "?" in (row.get("english_text") or "") else "say"
    return f"Use this when you need to {verb}: {stem}."


def apply_family_summary_normalization(family_ids):
    for family_id in family_ids:
        if family_id not in family_rows:
            continue
        updated_summary = normalized_family_summary(family_id)
        for row in family_rows[family_id]:
            row["family_summary"] = updated_summary


def relation_cluster_id(family_id):
    return f"viet-rel-{family_id}"


def quoted_follow_up_reason(english_text):
    cleaned = (english_text or "").strip()
    if not cleaned:
        return "If you still need more, ask the next question clearly."
    if cleaned.endswith("?"):
        return f'If you still need more, ask "{cleaned}" next.'
    return f'If you still need more, say "{cleaned}" next.'


def normalized_context_sentence(context):
    cleaned = (context or "").strip()
    if not cleaned:
        return None
    if cleaned.endswith("."):
        return cleaned
    return f"{cleaned}."


def repair_understand_reason_for_family(family_id):
    row = preferred_row_for_family(family_id)
    english = (row.get("english_text") or row.get("family_title") or "").strip()
    if not english:
        return "If that still does not land, say you do not understand."
    if english.endswith("?"):
        return f'If asking "{english}" still does not land, say you do not understand.'
    return f'If saying "{english}" still does not land, say you do not understand.'


def relation_only_handoff_reason(redirect_family_id):
    row = preferred_row_for_family(redirect_family_id)
    context = normalized_context_sentence(row.get("context"))
    if context:
        return context
    english = (row.get("english_text") or row.get("family_title") or "").strip()
    return quoted_follow_up_reason(english)


def relation_only_family_id_for_topic(topic):
    normalized_topic = (topic or "").strip().rstrip(".?!").lower()
    if not normalized_topic:
        return None
    for family_id, rows_for_family in family_rows.items():
        for row in rows_for_family:
            for candidate in [row.get("family_title"), row.get("english_text")]:
                normalized_candidate = (candidate or "").strip().rstrip(".?!").lower()
                if normalized_candidate and normalized_candidate == normalized_topic:
                    return family_id
    return None


def relation_only_handoff_reason_from_topic(topic):
    family_id = relation_only_family_id_for_topic(topic)
    if family_id:
        return relation_only_handoff_reason(family_id)
    return quoted_follow_up_reason(topic)


def relation_only_cluster(family_id, redirect_family_id, reference_cluster):
    anchor_phrase_id = phrase_for_family(family_id)
    clearer_phrase_id = maybe_phrase_for_family(family_id, "clearer")
    more_polite_phrase_id = maybe_phrase_for_family(family_id, "more-polite")
    relation_buckets = {bucket_name: [] for bucket_name in RELATION_TYPE_BY_BUCKET}
    if redirect_family_id and redirect_family_id != family_id:
        relation_buckets["askNext"].append(
            {
                "targetFamilyId": redirect_family_id,
                "targetPhraseId": phrase_for_family(redirect_family_id),
                "reason": relation_only_handoff_reason(redirect_family_id),
            }
        )
    if family_id != "repair-understand":
        relation_buckets["repairIfMissed"].append(
            {
                "targetFamilyId": "repair-understand",
                "targetPhraseId": phrase_for_family("repair-understand"),
                "reason": repair_understand_reason_for_family(family_id),
            }
        )
    return {
        "clusterId": relation_cluster_id(family_id),
        "coverageMoment": reference_cluster.get("coverageMoment", "support"),
        "scenarioId": scenario_id(family_id),
        "familyId": family_id,
        "familyTitle": family_title(family_id),
        "familySummary": family_summary(family_id),
        "anchorPhraseId": anchor_phrase_id,
        "shortestFormPhraseId": anchor_phrase_id,
        "clearerFormPhraseId": clearer_phrase_id,
        "morePoliteFormPhraseId": more_polite_phrase_id,
        "youMayHearSignals": [],
        "possibleTravelerResponses": [],
        "familyRelations": [],
        "phraseClass": reference_cluster.get("phraseClass", "practical-service-navigation"),
        "answerPageReady": False,
        "relationBuckets": relation_buckets,
    }


def normalize_relation_items(source_family_id, items):
    normalized = []
    seen = set()
    for item in items:
        updated = dict(item)
        if not updated.get("targetPhraseId"):
            updated["targetPhraseId"] = phrase_for_family(updated["targetFamilyId"])
        if updated["targetFamilyId"] == source_family_id:
            continue
        key = (updated["targetFamilyId"], updated["targetPhraseId"])
        if key in seen:
            continue
        seen.add(key)
        normalized.append(updated)
    return normalized


def refresh_cluster_derived_fields(cluster):
    relation_buckets = {}
    for bucket_name in RELATION_TYPE_BY_BUCKET:
        relation_buckets[bucket_name] = normalize_relation_items(
            cluster["familyId"],
            cluster.get("relationBuckets", {}).get(bucket_name, []),
        )
    cluster["relationBuckets"] = relation_buckets
    cluster["scenarioId"] = scenario_id(cluster["familyId"])
    cluster["familyTitle"] = family_title(cluster["familyId"])
    cluster["familySummary"] = family_summary(cluster["familyId"])
    cluster.pop("accessTier", None)
    cluster["youMayHearSignals"] = [
        {
            "signalText": item["reason"],
            "sourcePhraseId": cluster["anchorPhraseId"],
            "advisoryOnly": True,
        }
        for item in relation_buckets.get("likelyReply", [])
    ]
    cluster["possibleTravelerResponses"] = [
        {
            "kind": bucket_name,
            "familyId": item["targetFamilyId"],
            "phraseId": item["targetPhraseId"],
            "note": item["reason"],
        }
        for bucket_name in ["likelyReply", "askNext"]
        for item in relation_buckets.get(bucket_name, [])
    ]
    cluster["familyRelations"] = [
        {
            "relationType": RELATION_TYPE_BY_BUCKET[bucket_name],
            "targetFamilyId": item["targetFamilyId"],
            "reason": item["reason"],
        }
        for bucket_name in RELATION_TYPE_BY_BUCKET
        for item in relation_buckets.get(bucket_name, [])
    ]
    return cluster


def sync_answer_hub_relation_modules(hub, cluster):
    for module in hub.get("modules", []):
        bucket_names = MODULE_BUCKETS.get(module["moduleId"])
        if not bucket_names:
            continue
        active_bucket_names = [
            bucket_name
            for bucket_name in bucket_names
            if cluster.get("relationBuckets", {}).get(bucket_name)
        ]
        module["sourceFamilyIds"] = dedupe(
            [
                item["targetFamilyId"]
                for bucket_name in active_bucket_names
                for item in cluster.get("relationBuckets", {}).get(bucket_name, [])
            ]
        )
        module["relationRefs"] = active_bucket_names
        module["content"]["bullets"] = [
            bullet
            for bucket_name in active_bucket_names
            for bullet in relation_microcopy(bucket_name, cluster.get("relationBuckets", {}).get(bucket_name, []))
        ]


def social_use_case_bullet(text):
    stripped = (text or "").strip().rstrip(".")
    if not stripped:
        return text
    lower = stripped.lower()
    while lower.startswith("use it ") and "use it " in lower[7:]:
        stripped = stripped[lower.find("use it ", 7) :].strip().rstrip(".")
        lower = stripped.lower()
    if lower.startswith("use it "):
        stripped = stripped[7:].strip()
        lower = stripped.lower()
        if lower.startswith("in "):
            stripped = stripped[3:].strip()
            lower = stripped.lower()
        while lower.startswith("during "):
            stripped = stripped[7:].strip()
            lower = stripped.lower()
        if lower.startswith("as a "):
            stripped = stripped[5:].strip()
            lower = stripped.lower()
        elif lower.startswith("as an "):
            stripped = stripped[6:].strip()
            lower = stripped.lower()
        elif lower.startswith("as "):
            stripped = stripped[3:].strip()
            lower = stripped.lower()
    overrides = {
        "shop counter": "Use it when you first reach a shop counter.",
        "ride pickup": "Use it when a driver arrives for pickup.",
        "hotel desk": "Use it when you first step up to the hotel desk.",
        "after someone gives directions": "Use it right after someone gives directions.",
        "after counter help": "Use it once someone has helped at the counter.",
        "after a small favor": "Use it after someone does a small favor for you.",
        "street vendors": "Use it when a street vendor keeps pressing an offer.",
        "unwanted upsells": "Use it when someone keeps pushing an upsell you do not want.",
        "offers you do not want to accept": "Use it when someone offers something you do not want.",
        "casual counter chat": "Use it when casual counter chat turns personal.",
        "friendly host small talk": "Use it when a host starts friendly small talk.",
        "brief warm-up before a recommendation request": "Use it as a quick warm-up before asking for a recommendation.",
        "quick warm-up before asking for a recommendation": "Use it as a quick warm-up before asking for a recommendation.",
        "restaurant staff": "Use it when restaurant staff seem open to giving a local tip.",
        "hotel front desk": "Use it when the hotel front desk is the best place to ask for a local tip.",
        "friendly shopkeeper": "Use it when a friendly shopkeeper seems open to recommending a place.",
        "leaving a hotel desk": "Use it when you are leaving the hotel desk.",
        "walking away from a small shop": "Use it when you are walking away from a small shop.",
        "ending a short helpful exchange": "Use it when a short helpful exchange is ending.",
    }
    if lower in overrides:
        return overrides[lower]
    if stripped.startswith(("right after ", "once ")):
        return f"Use it {stripped}."
    if stripped.startswith(("after ", "before ", "while ", "when ")):
        return f"Use it {stripped}."
    if stripped.startswith("brief "):
        return f"Use it as a {stripped}."
    if stripped.startswith("quick warm-up"):
        return f"Use it as a {stripped}."
    if "small talk" in lower:
        return f"Use it during {stripped}."
    return f"Use it in {stripped}."


def polish_answer_hub_copy(hub, cluster):
    coverage_moment = cluster.get("coverageMoment")
    social_use_case_summary = {
        "viet-greeting-hello": "Use this to open politely, then ask the question.",
        "viet-greeting-thank-you": "Use this to close a helpful moment cleanly before moving on.",
        "viet-greeting-acknowledge": "Use this as a quick respectful bridge into the next question.",
        "viet-greeting-no-thanks": "Use this to decline briefly and move on without sounding sharp.",
        "viet-social-how-are-you": "Use this for a brief friendly check-in, then move on.",
        "viet-social-recommend": "Use this when the conversation is warm enough to ask for a local suggestion.",
        "viet-greeting-goodbye": "Use this when the practical part is over and you are ready to leave cleanly.",
    }.get(hub.get("hubId"), "Use this briefly, then move on.")
    confirm_detail_summary = {
        "transport": "Keep the fare, stop, or destination detail ready before the ride moves on.",
        "navigation": "Keep the destination, entrance, or landmark detail ready before the route gets muddy again.",
        "food": "Keep the dish, table, or spice detail ready before the order locks in.",
        "money": "Keep the item, fee, or total detail ready before the number changes again.",
        "hotel": "Keep the room, booking, or timing detail ready before the desk resets the conversation.",
        "airport": "Keep the document, stay, or checkpoint detail ready before the line moves on.",
        "phone": "Keep the phone, signal, or map detail ready before the helper guesses wrong.",
        "service": "Keep the document, file, or delivery detail ready before the counter moves to the next step.",
    }.get(coverage_moment, "Keep the one detail ready that will unblock the task.")
    what_to_show_summary = {
        "transport": "Show the map, stop, or price screen directly so the driver sees the issue fast.",
        "navigation": "Show the map pin, address, or landmark directly so the route stays concrete.",
        "food": "Show the menu, dish, or table cue directly so the staff see what you mean.",
        "money": "Show the item, bill, or calculator directly so the number stays tied to one thing.",
        "hotel": "Show the room, control, or booking detail directly so staff see the problem fast.",
        "airport": "Show the passport, visa, form, or booking screen directly so the checkpoint question stays clear.",
        "phone": "Show the phone, map, or signal problem directly so the helper can see it instead of guessing.",
        "service": "Show the document, file, or counter item directly so the task is obvious at once.",
    }.get(coverage_moment, "Show the key thing directly so the other person does not have to guess.")
    local_reality_summary = {
        "transport": "Ride problems usually hinge on one concrete stop, fare, or pickup detail.",
        "navigation": "Direction problems usually hinge on one landmark, entrance, or turn you can act on immediately.",
        "food": "Meal moments move fast, so one missing dish, table, or bill detail changes the whole interaction.",
        "money": "Money moments usually turn on one number, fee, or payment method.",
        "hotel": "Hotel fixes land faster when one room, booking, or timing detail is pinned down.",
        "airport": "Airport help is usually about one document, checkpoint, or next counter, not a long explanation.",
        "phone": "Phone help only matters if it gets maps, signal, or payment working again.",
        "service": "Counter help usually turns on one file, item, or pickup detail.",
    }.get(coverage_moment, "One concrete detail usually decides whether this traveler moment moves or stalls.")
    next_step_summary = {
        "transport": "Have the next ride move ready before the driver or dispatcher changes the situation.",
        "navigation": "Have the next turn, entrance, or ride handoff ready before the route slips again.",
        "food": "Have the next meal move ready before the table, menu, or bill moment slides away.",
        "money": "Have the next money move ready before the number changes again.",
        "hotel": "Have the next hotel move ready before the desk sends you back into the same loop.",
        "airport": "Have the next checkpoint move ready before the line moves on.",
        "phone": "Have the next phone-help move ready before the app or signal problem shifts again.",
        "service": "Have the next counter move ready before the task turns into price, delivery, or another document step.",
    }.get(coverage_moment, "Have the next traveler move ready before the situation shifts again.")
    next_try_summary = {
        "viet-repair-understand": "Once they understand you, ask the question again.",
        "viet-repair-slower": "Once they slow down, ask the question again.",
        "viet-repair-repeat": "Once they repeat it clearly, ask the question again.",
        "viet-repair-write-down": "Once it is written down, use that detail to keep the task moving.",
        "viet-repair-number": "Once the number is clear, ask about the time, price, or booking again.",
        "viet-repair-english-help": "Once English helps, ask the question again.",
        "viet-repair-meaning": "Once the word is clear, ask the question again.",
        "viet-repair-show-me": "Once they show you the place or item, continue with the next practical question.",
        "viet-repair-spell-name": "Once the name is clear, ask about the place or booking again.",
    }.get(hub.get("hubId"))
    summary_rewrites = {
        "Use one short hello to open the interaction politely before moving into the real task.": "Use one short hello to open politely before the question or request.",
        "A hello is only useful if it quickly hands off into the real task.": "A hello should hand off quickly into the question or request.",
        "If the conversation slips away, exit the social layer and repair it.": "If the exchange gets hard to follow, say you do not understand and reset it.",
        "If the exchange gets hard to follow, switch to a repair phrase.": "If the exchange gets hard to follow, say you do not understand and reset it.",
        "If the conversation does not land cleanly, leave the social layer and repair it.": "If leaving gets awkward or confusing, clear it up before you walk away.",
        "If leaving gets awkward or confusing, switch to a repair phrase.": "If leaving gets awkward or confusing, clear it up before you walk away.",
        "This is a soft respectful acknowledgment that buys you a second before the real request.": "This is a soft respectful acknowledgment that buys you a second before the next question.",
        "A soft acknowledgment should lead into the real request or a repair branch, not sit on its own.": "A soft acknowledgment should lead into the next question or a quick reset if you get lost.",
        "A soft acknowledgment should lead into the next question or a repair phrase.": "A soft acknowledgment should lead into the next question or a quick reset if you get lost.",
        "This is useful only for light warmth after a greeting, not as a replacement for the real traveler ask.": "Use this only for light warmth after a greeting, not in rushed or high-friction moments.",
        "Keep the small-talk moment brief, then shift into the useful question you actually need answered.": "Keep the small-talk moment brief, then ask the next useful question.",
        "This is the fast path when the real need is reaching the nearest hospital rather than asking for general medical advice.": "This is the fast path when you need the nearest hospital, not general medical advice.",
        "A goodbye only works if the real task is finished or you are clearly transitioning to the next move.": "Use goodbye once the exchange is wrapping up or you are moving to the next stop.",
        "If the responder does not catch the problem cleanly, repair fast.": "If they still look confused, clear it up fast.",
        "Once the current repair does its job, move to the next useful branch or back to the original task.": "Once repair works, ask the question you were trying to ask.",
        "If the task still stalls, move straight into the repair branch instead of looping.": "If the first try is not landing, clear up the missing detail in the simplest way.",
        "Use this once the reservation is established and you want the desk to move from searching into actually giving you the room.": "Use this once the reservation is established and you want the desk to move from searching into assigning the room.",
        "This is the calm document handoff phrase for checkpoints where the passport itself is the real answer.": "Use this calm document handoff when the passport alone answers the checkpoint question.",
        "Use this when seating is the real first blocker, before menu talk or dish questions even matter.": "Use this when the first problem is getting a table, before menu or dish questions matter.",
        "Use this to test whether English can simplify the next minute; if not, pivot fast to writing or showing.": "Try this when a little English might unblock the moment; if not, switch to writing or showing.",
        "If the first try still is not working, switch to the clearest repair option.": "If the first try is not landing, clear up the missing detail in the simplest way.",
        "If the first try still is not working, switch to the clearest way to fix the misunderstanding.": "If the first try is not landing, clear up the missing detail in the simplest way.",
        "If the first try still is not working, use the clearest repair that fits the moment.": "If the first try is not landing, clear up the missing detail in the simplest way.",
    }
    bullet_rewrites = {
        "A short acknowledgment is the most common answer before the real request starts.": "A short acknowledgment is the most common answer before the practical question starts.",
        "A polite acknowledgment often gets followed by one more easy social question before the real task starts.": "A polite acknowledgment often gets followed by one more easy social question before the practical question starts.",
        "If the other person keeps talking after hello, jump into a repair phrase instead of repeating the opener.": "If they keep talking after hello and you lose the thread, say you do not understand instead of repeating hello.",
        "If the reply keeps going, use a repair phrase instead of staying stuck in the thank-you moment.": "If the reply keeps going and you lose the thread, say you do not understand instead of repeating thank you.",
        "If small talk is done, pivot into the practical route question you actually need.": "If small talk is done, pivot into the route question.",
        "Once you find a workable method, move on and keep the conversation focused on the real task.": "Once you find a workable method, move on and keep the conversation focused on the next practical question.",
        "If checkout comes before your ride, bag storage is often the next real need.": "If checkout comes before your ride, bag storage is often the next practical need.",
        "Once repair works, you can return to the actual route or service question.": "Once repair works, ask the route or service question again.",
        "Once the pace drops, return to the actual ride or route request.": "Once the pace drops, return to the ride or route request.",
        "After the repeated line lands, jump back into the actual route or service task.": "After the repeated line lands, jump back into the route or service question.",
        "If the pace improves but one detail still fails, jump to repeat or number repair.": "If the pace improves but one detail still fails, ask them to repeat it or say the number again.",
        "Prices, dates, and gate numbers often need a second dedicated number repair even after the speaker slows down.": "Prices, dates, and gate numbers often need you to ask for the number again even after the speaker slows down.",
        "If the repeated line is mostly clear except for the number, move to the number repair branch immediately.": "If the repeated line is mostly clear except for the number, ask them to say the number again right away.",
        "A number repair often resolves into confirming the final total or exact amount.": "Once you catch the number, confirm the final total or exact amount.",
        "The real friction is usually price, file delivery, or page count.": "The usual friction is price, file delivery, or page count.",
        "The goal is to lock the real number before you agree or hand over money.": "The goal is to lock the final number before you agree or hand over money.",
        "Reservation pages live or die on the next-step rails: check in, fix the booking, or hand over proof.": "Reservation problems usually turn straight into check-in, booking fixes, or proof-of-booking questions.",
        "Check-in pages work best when they bridge straight into room details, deposit questions, or booking mismatch fixes.": "Check-in questions usually lead straight into room details, deposit questions, or booking fixes.",
        "Airport document pages must stay object-first and fast, because the counter decides the rhythm.": "At airport counters, showing the document fast works better than adding a long explanation.",
        "The page only works if it chains into the next checkpoint question instead of dying after one document line.": "After showing the passport, the next question is usually the next checkpoint step or document check.",
        "Good rails here matter more than fancy copy because the interaction is document-led and time-sensitive.": "The interaction is document-led and time-sensitive, so the next checkpoint question matters more than extra explanation.",
        "Airport utility pages need strong direction and next-step rails because the answer is often physical movement, not more language.": "Airport utility questions usually turn into physical movement, not more talk.",
        "Meter pages matter because ride pricing problems escalate fast once the car is already moving.": "Meter problems escalate fast once the car is already moving.",
        "Seating pages are strongest when they hand off immediately into menu or constraint choices.": "After you ask for a table, the next move is usually the menu or a food constraint.",
        "Payment pages work best when they flow into total, receipt, and included-fee checks without drama.": "After you say you want to pay, the next questions are usually the total, receipt, or included fees.",
        "Checkout-time pages should push directly into late checkout or bag-storage branches.": "Checkout-time questions usually turn straight into late checkout or bag storage.",
        "SIM pages matter because they often unlock maps, rides, payment, and translation all at once.": "Getting a SIM often unlocks maps, rides, payment, and translation all at once.",
        "The page should jump quickly into directions, payment, or map-recovery rails instead of staying abstract.": "Once the SIM problem is named, the next help is usually directions, payment, or getting maps working again.",
        "Map-failure pages are valuable because they bridge tech trouble straight into real movement again.": "Map failures matter because they block movement, not just the phone.",
        "Keep the page focused on getting moving again, not on generic device troubleshooting.": "Keep the focus on getting moving again, not on generic device troubleshooting.",
        "Menu pages are a common place where one unknown word blocks the whole decision.": "Menus are a common place where one unknown word blocks the whole decision.",
        "Once the place is shown, the next move is often the actual route question.": "Once the place is shown, the next move is often the route question itself.",
        "Passport-loss pages matter because they quickly branch into police, embassy, airline, and hotel help.": "Passport loss quickly turns into police, embassy, airline, and hotel help.",
        "Police-report pages are valuable because they bridge emergency language into the real paperwork path travelers need.": "Police reports turn emergency language into the paperwork step that follows.",
        "Keep the tone procedural and action-first, because the goal is the report and the next official step.": "Keep the tone procedural and action-first so you can get the report and move to the next official step.",
        "Service-document pages feel real only when they chain into copy, email, print, and payment rails.": "Scan jobs usually turn straight into copying, emailing, printing, or paying.",
        "If the scan works, emailing it out is often the next actual step.": "If the scan works, emailing it out is often the next practical step.",
        "At a hotel, goodbye often sits right next to the actual checkout request.": "At a hotel, goodbye often sits right next to the checkout request.",
        "If the menu has no clear prices, pivot into the price-check page instead of guessing.": "If the menu has no clear prices, ask the price before guessing.",
        "If the stop turns into a full order, bounce back to the menu page quickly.": "If the stop turns into a full order, go straight to the menu question.",
        "If the booking is not matching, surface the booking-problem page right away.": "If the booking does not match, say that problem immediately.",
        "Sometimes the reservation exists but the real next issue is room readiness.": "Sometimes the reservation exists, but the next issue is room readiness.",
        "If you are away from the desk and need someone else to intervene, move to the hotel-contact help page.": "If you are away from the desk and need someone else to intervene, ask a helper to call the hotel.",
        "Once the room is real, the next practical timing question is often checkout.": "Once the room is confirmed, the next practical timing question is often checkout.",
        "If the desk pushes price or deposit talk, move straight into the final-money page.": "If the desk pushes price or deposit talk, ask for the final total right away.",
        "If you are talking to another helper instead of desk staff, shift into the hotel-contact help page.": "If you are talking to another helper instead of desk staff, ask them to call the hotel.",
        "If buying the SIM becomes a cash issue, pivot straight into the ATM page.": "If buying the SIM becomes a cash issue, ask where the nearest ATM is.",
        "If the root problem is data, the SIM page is the next bounded fix.": "If the root problem is data, getting a SIM is the next bounded fix.",
        "If you can still travel on foot or by landmarks, shift into the directions page.": "If you can still move on foot or by landmarks, ask for directions next.",
        "If you are leaving one interaction to start the next leg, the destination page may be next.": "If you are leaving one interaction to start the next leg, ask where you need to go next.",
        "Map trouble is a common reason this visual repair page exists at all.": "Map trouble is a common reason to ask someone to show you the place.",
        "Map trouble is a common reason this visual repair phrase matters at all.": "Map trouble is a common reason to ask someone to show you the place.",
        "You may need to pivot immediately into the hospital destination phrase.": "You may need to follow up by asking for the nearest hospital.",
        "Once the name is clear, repeat the practical next ask instead of staying on the repair page.": "Once the name is clear, ask the question again.",
        "Once the menu is open, a spice or ingredient constraint is often the real next move.": "Once the menu is open, a spice or ingredient constraint is often the next move.",
        "If the proof is digital, be ready to pivot into the phone-display page.": "If the proof is digital, be ready to show it on the phone screen.",
        "If the conversation becomes about costs instead of directions, jump into the price page.": "If the conversation becomes about costs instead of directions, ask the price directly.",
        "If the ride is app-based, pivot into the app-price page instead of arguing abstractly.": "If the ride is app-based, show or ask about the app price instead of arguing abstractly.",
        "Do not stay on this page if the blocker is just speed; that is a slower or simpler-words problem instead.": "If the problem is only speed, ask for slower speech or simpler words instead.",
        "Spelled place names are often the bridge back into the destination page.": "Spelled place names are often the bridge back into the destination question.",
        "If official help is needed now, embassy contact becomes the next page.": "If official help is needed now, embassy contact becomes the next practical move.",
        "If the missing item is money or cards, the wallet-theft branch may be the next precise page.": "If the missing item is money or cards, the wallet-theft branch may be the next precise move.",
        "If a nearby helper needs to call someone on your behalf, move into the phone-help page quickly.": "If a nearby helper needs to call someone on your behalf, ask for phone help quickly.",
        "If the root problem is data, getting a SIM is the next bounded fix.": "If the root problem is data, getting a SIM is the next practical fix.",
        "If you are already turning away and realize something is missing, pivot immediately into the recovery phrase.": "If you are already turning away and realize something is missing, say it right away.",
        "If you are leaving one interaction to start the next leg, the destination question may be next.": "If you are leaving one interaction to start the next leg, ask where you need to go next.",
        "Do not stay on this phrase if the blocker is just speed; switch to slower speech or simpler words instead.": "If the problem is only speed, ask for slower speech or simpler words instead.",
        "Spelled place names are often the bridge back into the destination question.": "Once the place name is clear, go back to asking where it is.",
        "Once the name is clear, repeat the practical next ask instead of staying in repair mode.": "Once the name is clear, ask the question again.",
        "If you are already turning away and realize something is missing, say the recovery phrase right away.": "If you are already turning away and realize something is missing, say it right away.",
        "If this phrase lands but the moment keeps moving, continue into the fuller Where is the ATM page next.": "If this phrase lands but the moment keeps moving, ask where the nearest ATM is next.",
        "Once repair works, go back to the route or service question you were trying to ask.": "Once repair works, ask the route or service question again.",
        "This is also the common bridge back into a pharmacy or medical ask.": "This can also lead back to asking for a pharmacy or other medical help.",
        "Do not stay here too long if the answer is no; change methods immediately.": "If the answer is no, switch quickly to writing, pointing, or showing.",
        "If the driver starts explaining too much, reset with a direct understanding repair.": "If the driver starts explaining too much, say you do not understand yet and reset the question.",
        "If the booking is found, the natural reply branch is moving straight into check-in.": "If the booking is found, staff usually move straight into check-in.",
        "Desk staff often pivot immediately to ID or supporting proof.": "Desk staff often ask for ID or supporting proof right away.",
        "If instructions come back too fast, use a repair phrase right away.": "If instructions come back too fast, ask them to slow down right away.",
        "If someone starts giving quick instructions, use a repair phrase immediately.": "If someone starts giving quick instructions, ask them to slow down right away.",
        "If the response comes back too quickly, use a repair phrase immediately.": "If the response comes back too quickly, ask them to slow down right away.",
        "Page counts, pickup times, and fees often need a number repair branch.": "Page counts, pickup times, and fees often need the number said or written again.",
        "Once the word is clear, go back to the blocked question.": "Once the word is clear, ask the question again.",
        "Once the name is clear, go back to the place or booking question.": "Once the name is clear, ask about the place or booking again.",
        "Once the name is clear, go back to the question you needed answered.": "Once the name is clear, ask the question again.",
        "If the staff can scan but not send it, be ready to pivot into the email or print follow-up immediately.": "If the staff can scan but not send it, ask right away about email or printing.",
        "If the desk is confused, do not repeat the whole ask; switch to the exact missing detail instead.": "If the desk looks confused, give the missing name, date, or number instead of repeating everything.",
        "Do not use this for times or amounts; switch to the number repair when digits are the real blocker.": "If the problem is a time or price, ask them to write or repeat the number.",
    }
    for module in hub.get("modules", []):
        if module["moduleId"] == "social-use-case":
            module["content"]["summary"] = social_use_case_summary
            module["content"]["bullets"] = [social_use_case_bullet(text) for text in module["content"].get("bullets", [])]
        if module["moduleId"] == "operator-question":
            module["content"]["summary"] = "Listen for the next practical question or confirmation so you can answer without starting over."
        if module["moduleId"] == "confirm-detail":
            module["content"]["summary"] = confirm_detail_summary
        if module["moduleId"] == "what-to-show":
            module["content"]["summary"] = what_to_show_summary
        if module["moduleId"] == "local-reality":
            module["content"]["summary"] = local_reality_summary
        if module["moduleId"] == "next-step":
            module["content"]["summary"] = next_step_summary
        if module["moduleId"] == "next-try" and next_try_summary:
            module["content"]["summary"] = next_try_summary
        summary = module["content"].get("summary")
        if summary in summary_rewrites:
            module["content"]["summary"] = summary_rewrites[summary]
        module["content"]["bullets"] = [
            bullet_rewrites.get(bullet, bullet)
            for bullet in module["content"].get("bullets", [])
        ]


def rewrite_nested_text(value, rewrites):
    if isinstance(value, dict):
        return {key: rewrite_nested_text(item, rewrites) for key, item in value.items()}
    if isinstance(value, list):
        return [rewrite_nested_text(item, rewrites) for item in value]
    if isinstance(value, str):
        if value.startswith("If this phrase lands but the moment keeps moving, continue into the fuller ") and value.endswith(" page next."):
            topic = value[len("If this phrase lands but the moment keeps moving, continue into the fuller ") : -len(" page next.")]
            return relation_only_handoff_reason_from_topic(topic)
        if value.startswith("If this phrase lands but the moment keeps moving, continue with the fuller ") and value.endswith(" version next."):
            topic = value[len("If this phrase lands but the moment keeps moving, continue with the fuller ") : -len(" version next.")]
            return relation_only_handoff_reason_from_topic(topic)
        if value.startswith("If this phrase helps and you need the follow-up, use the fuller ") and value.endswith(" phrase next."):
            topic = value[len("If this phrase helps and you need the follow-up, use the fuller ") : -len(" phrase next.")]
            return relation_only_handoff_reason_from_topic(topic)
        if value.startswith("If this helps but you still need the follow-up, try ") and value.endswith(" next."):
            topic = value[len("If this helps but you still need the follow-up, try ") : -len(" next.")]
            return relation_only_handoff_reason_from_topic(topic)
        if value.startswith("If this helps but you still need more, move into ") and value.endswith("."):
            topic = value[len("If this helps but you still need more, move into ") : -1]
            return relation_only_handoff_reason_from_topic(topic)
        if value.startswith("If this helps but you still need more, the next step may be ") and value.endswith("."):
            topic = value[len("If this helps but you still need more, the next step may be ") : -1]
            return relation_only_handoff_reason_from_topic(topic)
        return rewrites.get(value, value)
    return value


new_hub_specs = [enrich_hub_spec(hub) for hub in NEW_HUBS]
new_hub_ids = {hub["hubId"] for hub in new_hub_specs}
new_hub_families = {hub["familyId"] for hub in new_hub_specs}

existing_hubs = [hub for hub in answer_sample["hubs"] if hub["hubId"] not in new_hub_ids]
existing_hub_ids = {hub["hubId"] for hub in existing_hubs}
for hub in new_hub_specs:
    if hub["hubId"] in existing_hub_ids:
        raise ValueError(f"duplicate hub id: {hub['hubId']}")


answer_sample["sourceOfTruth"]["membershipTokenFormat"] = (
    "<hubId>:anchor | <hubId>:variant:clearer | <hubId>:variant:more-polite | <hubId>:variant:also-common | "
    "<hubId>:support:likelyReply | <hubId>:support:repairIfMissed | <hubId>:support:askNext | "
    "<hubId>:support:crossClassExit | <hubId>:support:escalateTo"
)
answer_sample["sourceOfTruth"]["supportMarkerKinds"] = [
    "support:likelyReply",
    "support:repairIfMissed",
    "support:askNext",
    "support:crossClassExit",
    "support:escalateTo",
]
answer_sample["contentRules"] = dedupe(
    answer_sample["contentRules"]
    + [
        "answer-page-sample support markers may trace linked support rows in phrase-source.csv, but only as lightweight notes tokens.",
    ]
)


clusters_by_family = {cluster["familyId"]: cluster for cluster in relation_sample["clusters"]}
existing_cluster_order = [cluster["familyId"] for cluster in relation_sample["clusters"]]


for hub in new_hub_specs:
    cluster = clusters_by_family.get(hub["familyId"], {})
    cluster.update(
        {
            "clusterId": hub["hubId"],
            "coverageMoment": hub["coverageMoment"],
            "scenarioId": scenario_id(hub["familyId"]),
            "familyId": hub["familyId"],
            "familyTitle": family_title(hub["familyId"]),
            "familySummary": family_summary(hub["familyId"]),
            "anchorPhraseId": hub["anchorPhraseId"],
            "shortestFormPhraseId": hub["quickSayPhraseId"],
            "clearerFormPhraseId": hub.get("clearerPhraseId"),
            "morePoliteFormPhraseId": hub.get("morePolitePhraseId"),
            "phraseClass": hub["phraseClass"],
            "answerPageReady": True,
            "relationBuckets": {
                bucket_name: [
                    {
                        "targetFamilyId": item["targetFamilyId"],
                        "targetPhraseId": item["targetPhraseId"],
                        "reason": item["reason"],
                    }
                    for item in items
                ]
                for bucket_name, items in hub["relationBuckets"].items()
            },
        }
    )
    clusters_by_family[hub["familyId"]] = cluster


answer_cluster_order = [
    cluster["familyId"]
    for cluster in relation_sample["clusters"]
    if cluster.get("answerPageReady")
]
for hub in new_hub_specs:
    if hub["familyId"] not in answer_cluster_order:
        answer_cluster_order.append(hub["familyId"])

linked_non_answer_families = []
for family_id in answer_cluster_order:
    cluster = clusters_by_family[family_id]
    for bucket_name in RELATION_TYPE_BY_BUCKET:
        for item in cluster.get("relationBuckets", {}).get(bucket_name, []):
            target_family_id = item["targetFamilyId"]
            if (
                target_family_id not in answer_cluster_order
                and target_family_id not in linked_non_answer_families
            ):
                linked_non_answer_families.append(target_family_id)

external_target_families_in_order = [
    cluster["familyId"]
    for cluster in relation_sample["clusters"]
    if not cluster.get("answerPageReady") and cluster["familyId"] in linked_non_answer_families
]
for family_id in linked_non_answer_families:
    if family_id not in external_target_families_in_order:
        external_target_families_in_order.append(family_id)

scoped_family_ids = set(answer_cluster_order) | set(external_target_families_in_order)
apply_family_summary_normalization(scoped_family_ids)

for family_id in external_target_families_in_order:
    redirect_family_id = RELATION_ONLY_FAMILY_REDIRECTS[family_id]
    reference_cluster = clusters_by_family[redirect_family_id]
    clusters_by_family[family_id] = relation_only_cluster(
        family_id,
        redirect_family_id,
        reference_cluster,
    )

clusters_by_id = {cluster["clusterId"]: cluster for cluster in clusters_by_family.values()}
for cluster_id, bucket_overrides in CLUSTER_BUCKET_OVERRIDES.items():
    cluster = clusters_by_id[cluster_id]
    for bucket_name, entries in bucket_overrides.items():
        cluster["relationBuckets"][bucket_name] = [
            {
                "targetFamilyId": target_family_id,
                "targetPhraseId": phrase_for_family(target_family_id),
                "reason": reason,
            }
            for target_family_id, reason in entries
        ]

full_cluster_order = answer_cluster_order + [
    family_id
    for family_id in external_target_families_in_order
    if family_id not in answer_cluster_order
]
relation_sample["clusters"] = [
    refresh_cluster_derived_fields(clusters_by_family[family_id])
    for family_id in full_cluster_order
]
relation_text_rewrites = {
    "If the menu has no clear prices, pivot into the price-check page instead of guessing.": "If the menu has no clear prices, ask the price before guessing.",
    "If the stop turns into a full order, bounce back to the menu page quickly.": "If the stop turns into a full order, go straight to the menu question.",
    "If buying the SIM becomes a cash issue, pivot straight into the ATM page.": "If buying the SIM becomes a cash issue, ask where the nearest ATM is.",
    "If the root problem is data, the SIM page is the next bounded fix.": "If the root problem is data, getting a SIM is the next practical fix.",
    "If you can still travel on foot or by landmarks, shift into the directions page.": "If you can still move on foot or by landmarks, ask for directions next.",
    "If you are leaving one interaction to start the next leg, the destination page may be next.": "If you are leaving one interaction to start the next leg, ask where you need to go next.",
    "If you are leaving one interaction to start the next leg, the destination question may be next.": "If you are leaving one interaction to start the next leg, ask where you need to go next.",
    "If you are already turning away and realize something is missing, pivot immediately into the recovery phrase.": "If you are already turning away and realize something is missing, say it right away.",
    "If you are already turning away and realize something is missing, say the recovery phrase right away.": "If you are already turning away and realize something is missing, say it right away.",
    "Map trouble is a common reason this visual repair page exists at all.": "Map trouble is a common reason to ask someone to show you the place.",
    "Map trouble is a common reason this visual repair phrase matters at all.": "Map trouble is a common reason to ask someone to show you the place.",
    "Spelled place names are often the bridge back into the destination page.": "Once the place name is clear, go back to asking where it is.",
    "Once the name is clear, repeat the practical next ask instead of staying on the repair page.": "Once the name is clear, ask the question again.",
    "Once the name is clear, repeat the practical next ask instead of staying in repair mode.": "Once the name is clear, ask the question again.",
    "You may need to pivot immediately into the hospital destination phrase.": "You may need to follow up by asking for the nearest hospital.",
    "Once repair works, go back to the route or service question you were trying to ask.": "Once repair works, ask the route or service question again.",
    "This is also the common bridge back into a pharmacy or medical ask.": "This can also lead back to asking for a pharmacy or other medical help.",
    "If this still does not land cleanly, reset with a direct understanding repair.": "If you are still lost, say you do not understand.",
    "If the driver starts explaining too much, reset with a direct understanding repair.": "If the driver starts explaining too much, say you do not understand yet and reset the question.",
    "If a nearby helper needs to call someone on your behalf, move into the phone-help page quickly.": "If a nearby helper needs to call someone on your behalf, ask for phone help quickly.",
    "If this phrase lands but the moment keeps moving, continue into the fuller Where is the ATM page next.": "If this phrase lands but the moment keeps moving, ask where the nearest ATM is next.",
    "If the booking is found, the natural reply branch is moving straight into check-in.": "If the booking is found, staff usually move straight into check-in.",
    "Desk staff often pivot immediately to ID or supporting proof.": "Desk staff often ask for ID or supporting proof right away.",
    "Do not stay on this phrase if the blocker is just speed; switch to slower speech or simpler words instead.": "If the problem is only speed, ask for slower speech or simpler words instead.",
    "If the other person keeps talking after hello, jump into a repair phrase instead of repeating the opener.": "If they keep talking after hello and you lose the thread, say you do not understand instead of repeating hello.",
    "If the reply keeps going, use a repair phrase instead of staying stuck in the thank-you moment.": "If the reply keeps going and you lose the thread, say you do not understand instead of repeating thank you.",
    "If instructions come back too fast, use a repair phrase right away.": "If instructions come back too fast, ask them to slow down right away.",
    "If someone starts giving quick instructions, use a repair phrase immediately.": "If someone starts giving quick instructions, ask them to slow down right away.",
    "If the response comes back too quickly, use a repair phrase immediately.": "If the response comes back too quickly, ask them to slow down right away.",
    "Once the word is clear, go back to the blocked question.": "Once the word is clear, ask the question again.",
    "Once the word is clear, ask the main question again.": "Once the word is clear, ask the question again.",
    "Once the name is clear, go back to the place or booking question.": "Once the name is clear, ask about the place or booking again.",
    "Once the name is clear, go back to the question you needed answered.": "Once the name is clear, ask the question again.",
    "Once the name is clear, ask the main question again.": "Once the name is clear, ask the question again.",
    "If the staff can scan but not send it, be ready to pivot into the email or print follow-up immediately.": "If the staff can scan but not send it, ask right away about email or printing.",
    "If this still is not clear, say you do not understand and start again.": "If you are still lost, say you do not understand.",
    "If this is still unclear, say you do not understand yet and ask again more simply.": "If you are still lost, say you do not understand.",
    "If this is still unclear, say you still do not understand.": "If you are still lost, say you do not understand.",
    "Page counts, pickup times, and fees often need a number repair branch.": "Page counts, pickup times, and fees often need the number said or written again.",
    "A number repair often resolves into confirming the final total or exact amount.": "Once you catch the number, confirm the final total or exact amount.",
    "This is a common hotel, taxi, and café recovery phrase.": "This is a common hotel, taxi, and café fallback phrase.",
}
relation_sample["clusters"] = rewrite_nested_text(relation_sample["clusters"], relation_text_rewrites)
clusters_by_family = {cluster["familyId"]: cluster for cluster in relation_sample["clusters"]}
relation_only_cluster_count = len(relation_sample["clusters"]) - len(answer_cluster_order)
relation_sample["clusterCount"] = len(relation_sample["clusters"])
relation_sample["purpose"] = (
    "Additive relation-ready handoff for phrase-detail, listing-page, and answer-page work across 50 answer-page-ready Viet hubs "
    "plus supporting relation-only clusters that keep linked phrase navigation inside the authored relation sample, "
    "without replacing the current scenario -> family -> phrase-row model."
)
relation_sample["answerPageCoverage"] = {
    "sampleId": "viet-answer-page-sample-v1",
    "hubCount": len(existing_hubs) + len(new_hub_specs),
    "relationOnlyClusterCount": relation_only_cluster_count,
    "totalRelationClusterCount": len(relation_sample["clusters"]),
    "phraseClassCount": 4,
    "phraseClasses": CLASS_ORDER,
    "relationBucketFields": [
        "likelyReply",
        "repairIfMissed",
        "askNext",
        "escalateTo",
        "crossClassExit",
    ],
    "supportMarkerKinds": [
        "support:likelyReply",
        "support:repairIfMissed",
        "support:askNext",
        "support:crossClassExit",
        "support:escalateTo",
    ],
}
relation_sample["sourceOfTruth"]["precedenceRules"] = dedupe(
    relation_sample["sourceOfTruth"].get("precedenceRules", [])
    + [
        "For answer-page-ready hubs, answer-page-sample support markers may trace linked support rows in phrase-source.csv without changing phrase wording truth.",
        "Relation-only supporting clusters may deepen the phrase graph without changing the answer-page hub count.",
    ]
)


new_answer_hubs = []
for hub in new_hub_specs:
    new_answer_hubs.append(
        {
            "hubId": hub["hubId"],
            "scenarioId": scenario_id(hub["familyId"]),
            "familyId": hub["familyId"],
            "familyTitle": family_title(hub["familyId"]),
            "phraseClass": hub["phraseClass"],
            "moduleMixId": hub["moduleMixId"],
            "relationClusterId": hub["hubId"],
            "anchorPhraseId": hub["anchorPhraseId"],
            "defaultPhraseId": hub["defaultPhraseId"],
            "quickSayPhraseId": hub["quickSayPhraseId"],
            "clearerPhraseId": hub.get("clearerPhraseId"),
            "morePolitePhraseId": hub.get("morePolitePhraseId"),
            "alternatePhraseIds": hub.get("alternatePhraseIds", []),
            "relationBuckets": list(hub["relationBuckets"].keys()),
            "modules": build_modules(hub),
        }
    )


answer_sample["hubs"] = existing_hubs + new_answer_hubs
answer_sample["hubCount"] = len(answer_sample["hubs"])
answer_sample["phraseClassCount"] = len(CLASS_ORDER)
for hub in answer_sample["hubs"]:
    sync_answer_hub_relation_modules(hub, clusters_by_family[hub["familyId"]])
    polish_answer_hub_copy(hub, clusters_by_family[hub["familyId"]])
    hub["relationBuckets"] = [
        bucket_name
        for bucket_name in RELATION_TYPE_BY_BUCKET
        if clusters_by_family[hub["familyId"]].get("relationBuckets", {}).get(bucket_name)
    ]


def variant_token_kind(phrase_id):
    role = row_for_phrase(phrase_id)["variant_role"]
    return {
        "clearer": "variant:clearer",
        "more-polite": "variant:more-polite",
        "also-common": "variant:also-common",
    }.get(role)


for row in rows:
    row["notes"] = strip_managed_note_tokens(row.get("notes") or "")


for cluster in relation_sample["clusters"]:
    row_for_phrase(cluster["anchorPhraseId"])["notes"] = add_note_token(
        row_for_phrase(cluster["anchorPhraseId"])["notes"],
        f"relation-sample={cluster['clusterId']}:anchor",
    )
    for phrase_id in dedupe(
        [
            row["phrase_id"]
            for row in family_rows.get(cluster["familyId"], [])
            if row["status"] == "approved" and variant_token_kind(row["phrase_id"])
        ]
    ):
        if not phrase_id:
            continue
        token_kind = variant_token_kind(phrase_id)
        if token_kind:
            row_for_phrase(phrase_id)["notes"] = add_note_token(
                row_for_phrase(phrase_id)["notes"],
                f"relation-sample={cluster['clusterId']}:{token_kind}",
            )


for hub in answer_sample["hubs"]:
    row_for_phrase(hub["anchorPhraseId"])["notes"] = add_note_token(
        row_for_phrase(hub["anchorPhraseId"])["notes"],
        f"answer-page-sample={hub['hubId']}:anchor",
    )
    for phrase_id in dedupe(
        [hub.get("clearerPhraseId"), hub.get("morePolitePhraseId")] + hub.get("alternatePhraseIds", [])
    ):
        if not phrase_id:
            continue
        token_kind = variant_token_kind(phrase_id)
        if token_kind:
            row_for_phrase(phrase_id)["notes"] = add_note_token(
                row_for_phrase(phrase_id)["notes"],
                f"answer-page-sample={hub['hubId']}:{token_kind}",
            )

    cluster = next(cluster for cluster in relation_sample["clusters"] if cluster["clusterId"] == hub["relationClusterId"])
    for bucket_name, items in cluster.get("relationBuckets", {}).items():
        for item in items:
            target_phrase_id = item.get("targetPhraseId")
            if not target_phrase_id:
                continue
            row_for_phrase(target_phrase_id)["notes"] = add_note_token(
                row_for_phrase(target_phrase_id)["notes"],
                f"answer-page-sample={hub['hubId']}:support:{bucket_name}",
            )


final_answer_marked_rows = {
    row["phrase_id"]
    for row in rows
    if "answer-page-sample=" in (row.get("notes") or "")
}
support_marked_rows = {
    row["phrase_id"]
    for row in rows
    if ":support:" in (row.get("notes") or "")
}
newly_marked_rows_count = len(final_answer_marked_rows) - BASELINE_ANSWER_MARKED_ROW_COUNT

if answer_sample["hubCount"] < 48:
    raise SystemExit(f"hub count too low: {answer_sample['hubCount']}")
if newly_marked_rows_count < 80:
    raise SystemExit(f"newly marked answer-page rows too low: {newly_marked_rows_count}")

answer_sample["sourceOfTruth"]["supportingRowCount"] = len(support_marked_rows)
relation_sample["answerPageCoverage"]["supportingRowCount"] = len(support_marked_rows)
answer_sample["sourceOfTruth"].pop("newlyMarkedRowCountThisPass", None)
relation_sample["answerPageCoverage"].pop("newlyMarkedRowCountThisPass", None)


with REL_PATH.open("w", encoding="utf-8", newline="\n") as handle:
    json.dump(relation_sample, handle, ensure_ascii=False, indent=2)
    handle.write("\n")

with ANS_PATH.open("w", encoding="utf-8", newline="\n") as handle:
    json.dump(answer_sample, handle, ensure_ascii=False, indent=2)
    handle.write("\n")

with CSV_PATH.open("w", encoding="utf-8-sig", newline="") as handle:
    writer = csv.DictWriter(handle, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(rows)


print(
    json.dumps(
        {
            "answerHubCount": answer_sample["hubCount"],
            "relationClusterCount": relation_sample["clusterCount"],
            "totalAnswerMarkedRows": len(final_answer_marked_rows),
            "supportMarkedRows": len(support_marked_rows),
            "newlyMarkedRows": newly_marked_rows_count,
            "newHubIds": [hub["hubId"] for hub in new_answer_hubs],
        },
        ensure_ascii=False,
        indent=2,
    )
)
