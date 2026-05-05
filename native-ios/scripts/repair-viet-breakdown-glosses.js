#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const nativeRoot = path.resolve(__dirname, "..");
const repoRoot = path.resolve(nativeRoot, "..");
const tierOnePagesRoot = path.join(repoRoot, "content-draft", "viet", "canonical-pages", "tier-one");
const catalogPromotedPagesRoot = path.join(repoRoot, "content-draft", "viet", "canonical-pages", "catalog-promoted");
const cityLibraryPath = path.join(repoRoot, "content-draft", "viet", "city-library", "v1.json");
const authoredResourcePath = path.join(nativeRoot, "Resources", "viet-authored-listing-pages.json");
const audioManifestPath = path.join(nativeRoot, "Resources", "viet-audio-manifest.json");
const practiceExpansionRoot = path.join(
  repoRoot,
  "content-draft",
  "viet",
  "practice-expansion",
  "TASK-VIET-CONTENT-PRACTICE-EXPANSION-001"
);
const practiceManifestPath = path.join(practiceExpansionRoot, "manifest.json");

const exactGlosses = new Map(Object.entries({
  "a": "polite yes / opener",
  "alo": "phone hello",
  "anh": "older man",
  "anh chi": "sir or ma'am",
  "anh/chi": "sir or ma'am",
  "an toan": "safe",
  "ban": "you",
  "ban co the": "can you",
  "ban da": "you already",
  "bang ma qr": "by QR code",
  "bang the": "by card",
  "bang tieng anh": "in English",
  "bang van ban": "in writing",
  "bao cao": "report",
  "bao cao y": "medical report",
  "bao cao y te": "medical report",
  "bao lau": "how long",
  "bao nhieu": "how much",
  "bao ve": "security",
  "bac xiu": "sweet milk coffee",
  "bat dau": "begin / start",
  "bay gio": "now",
  "bay gio no": "it now",
  "bep": "kitchen",
  "bien nhan bao": "receipt for insurance",
  "bien nhan bao hiem": "receipt for insurance",
  "bi mat": "lost",
  "bot": "reduce / lower",
  "buc anh": "picture",
  "bua sang": "breakfast",
  "bua trua": "lunch",
  "buu dien": "post office",
  "ca phe": "coffee",
  "ca phe da": "iced coffee",
  "ca phe den": "black coffee",
  "ca phe sua": "milk coffee",
  "cai nay": "this one",
  "cam on": "thank you",
  "can": "need",
  "canh sat": "police",
  "canh sat du lich": "tourist police",
  "cao hon": "higher",
  "chao": "greet / hello",
  "chi": "older woman",
  "chi cho toi": "show me",
  "cho": "give / let",
  "cho biet": "tell / let know",
  "cho hoi": "excuse me / may I ask",
  "cho khach san": "for the hotel",
  "cho nguoi quan ly": "for the manager",
  "cho toi": "for me / please",
  "cho toi biet": "please tell me",
  "dua cho toi": "give me",
  "cho toi xem": "show me / let me see",
  "cho toi ra": "let me out",
  "cho xem": "show / let see",
  "chong nang": "sunscreen",
  "chua": "pagoda",
  "chua duoc nau": "undercooked",
  "chuyen bay": "flight",
  "chuyen xe buyt": "bus",
  "co": "have / yes",
  "co an toan": "is it safe?",
  "co bao gom": "is it included?",
  "co ban": "do you sell",
  "co bi tre": "is it delayed?",
  "co chua": "does it contain?",
  "co duoc": "can it be?",
  "co hoat dong": "does it work?",
  "co mo": "is it open?",
  "co san": "available",
  "co the": "can",
  "co the don": "can clean",
  "co the tra lai": "can return",
  "co thit": "has meat",
  "co vi hu": "tastes spoiled",
  "co o day": "is here",
  "con": "still / also",
  "cong an": "police",
  "cua toi": "my / mine",
  "cung voi thuc an": "with food",
  "da": "respectful opener",
  "da bi": "was / got",
  "da xay ra": "happened",
  "dai su quan": "embassy",
  "danh van": "spell",
  "danh van ten": "spell the name",
  "day": "here / this",
  "de": "to / so that",
  "de du lich": "for tourism",
  "den": "to / arrive at",
  "di": "go",
  "di bo": "walk",
  "di chuyen": "move",
  "di den": "go to",
  "di dau": "where are you going",
  "di ngu": "go to sleep",
  "di thang": "go straight",
  "diem gap": "meeting point",
  "dia chi": "address",
  "dien thoai": "phone",
  "dung": "correct",
  "dung o": "stop at",
  "duoc": "possible / okay",
  "duoc khong": "is it possible?",
  "duong tau ha noi": "Hanoi Train Street",
  "duong nay di": "this way, please",
  "duong nay": "this route",
  "duong pho": "the street",
  "em": "younger person",
  "gan": "near",
  "gan day": "near here",
  "gan nhat": "nearest",
  "gia": "price",
  "giam gia": "discount / lower price",
  "giay": "paper / document",
  "giay ve sinh": "toilet paper",
  "giay thong hanh": "travel document",
  "giup": "help",
  "giup toi": "help me",
  "go dia chi": "type the address",
  "go no": "type it",
  "goi": "call",
  "goi bac si": "call a doctor",
  "goi bao ve": "call security",
  "goi xe cuu thuong": "call an ambulance",
  "gui": "send / store",
  "gui cho toi": "send me",
  "gui email": "email",
  "gui hanh ly": "store luggage",
  "gui tin nhan": "send a message",
  "hai": "two",
  "hanh ly": "baggage",
  "hay": "please do",
  "hoa don": "bill / receipt",
  "ho chieu": "passport",
  "ho chieu cua toi": "my passport",
  "hoat dong": "working",
  "hom nay": "today",
  "hom nay co mo cua": "open today",
  "it cay": "less spicy",
  "khach san": "hotel",
  "khan giay": "tissues",
  "khong": "no / not",
  "khong an toan": "not safe",
  "khong duong": "no sugar",
  "khong sao": "it is okay",
  "khan cap": "urgent / emergency",
  "khoang": "about",
  "khoang muoi": "about ten",
  "khu don": "pickup area",
  "lam on": "please",
  "lien he": "contact",
  "lien he voi": "contact",
  "luc": "at the time",
  "may lanh": "air conditioning",
  "may lanh co": "the air conditioner",
  "mat": "lost",
  "mat hang": "item",
  "mat khau": "password",
  "mi": "noodles",
  "mot": "one / a",
  "mot buc anh": "a picture",
  "mot cai khac": "another one",
  "mot chut": "a little",
  "mot ly": "one cup",
  "mot mat hang": "one item",
  "mot ngay": "one day",
  "nam phut": "five minutes",
  "mot phong": "one room",
  "mua": "buy",
  "mua sim": "buy a SIM",
  "muon": "want",
  "nha ga": "station / terminal",
  "nha hang": "restaurant",
  "nha thuoc": "pharmacy",
  "nha ve sinh": "bathroom",
  "nhan phong": "check in",
  "nhan duoc": "receive",
  "nhan tin": "text message",
  "nhap canh": "immigration",
  "nhieu": "much / many",
  "no": "it",
  "noi": "say / speak",
  "noi chuyen": "speak / talk",
  "noi chuyen voi": "speak with",
  "noi lai": "say again",
  "nuoc": "water",
  "nuoc mam": "fish sauce",
  "nuoc suoi": "bottled water",
  "o": "at / in",
  "o dau": "where?",
  "o day": "here",
  "ben": "side",
  "ben trai": "left side",
  "ben phai": "right side",
  "phai": "right / correct",
  "phai khong": "is that right?",
  "trai": "left",
  "phi": "fee",
  "phong": "room",
  "phong cach xa": "room away from",
  "phong tam": "bathroom",
  "phong yen tinh": "quiet room",
  "qua": "too / very",
  "re phai": "turn right",
  "re trai": "turn left",
  "roi": "already / enough",
  "sac": "charge",
  "sai": "wrong",
  "sao": "why / how",
  "sao bay gio": "why now",
  "sim": "SIM card",
  "tam": "for now",
  "tai xe": "driver",
  "taxi": "taxi",
  "ten": "name",
  "tien le": "change / small bills",
  "the": "can / able to",
  "the hanh ly": "baggage tag",
  "the nhan duoc": "can receive",
  "the su dung": "can use",
  "the tin dung": "credit card",
  "the tim thay": "can find",
  "thi thuc": "visa",
  "thit": "meat",
  "them mot dem": "one more night",
  "thoi gian": "time",
  "thuoc": "medicine",
  "tien": "money",
  "tien mat": "cash",
  "tieng anh": "English",
  "tim": "find",
  "tim thay": "find",
  "toi": "I / me",
  "toi da": "I already / I did",
  "toi den day": "I am here",
  "toi dang": "I am",
  "toi bi": "I have / got",
  "toi can": "I need",
  "toi co": "I have",
  "toi co the": "can I",
  "toi khong": "I do not",
  "toi muon": "I want",
  "toi nghi": "I think",
  "toi se": "I will",
  "toi tra": "I pay",
  "tra lai": "return / give back",
  "tra phong": "check out",
  "truoc khi di ngu": "before bed",
  "trong": "inside / in",
  "truong hop": "case / situation",
  "tu tu": "slowly",
  "no cach day": "it is from here",
  "ung dung": "app",
  "ung dung dich": "translation app",
  "ung dung dich thuat": "translation app",
  "ve": "ticket",
  "ve ho chieu": "about the passport",
  "viet": "write",
  "viet xuong": "write down",
  "voi": "with / to",
  "wifi": "Wi-Fi",
  "wi fi": "Wi-Fi",
  "xe": "vehicle",
  "xe buyt": "bus",
  "xe cuu thuong": "ambulance",
  "xin": "please / ask",
  "xin chao": "hello",
  "xin loi": "excuse me / sorry",
  "xin vui long": "please",
  "y te": "medical",
  "yen tinh": "quiet",
  "nguoi quan ly": "manager",
  "cua minh": "my / mine",
  "chung ta": "we",
  "nen dung no": "should take it",
  "trinh dieu khien": "driver",
  "vui long": "please",
  "lai nam ngay": "five days",
  "bi hong": "is damaged",
  "nham tui": "wrong bag",
  "dich vu don": "pickup service",
  "loi trong bieu": "mistake on the form",
  "toi hieu": "I understand",
  "thay no cam on ban": "found it, thank you",
  "giup do": "help",
  "tai nan": "accident",
  "dong y voi": "agree with",
  "muon bat ky rac roi nao": "any trouble",
  "la mot tro lua dao": "a scam",
  "the an mon nay vi bi": "cannot eat this because",
  "cai banh mi": "bánh mì",
  "to pho": "bowl of phở",
  "dung co da": "no ice",
  "do trong thuc": "something in the food",
  "hong": "spoiled / damaged",
  "the an sua": "cannot eat dairy",
  "the an gluten": "cannot eat gluten",
  "doi rat lau": "waiting a long time",
  "nhung gi ho dang co": "what they are having",
  "on roi cam on ban": "okay now, thank you",
  "ngot lam on": "MSG, please",
  "dung co rom": "no straw",
  "cho mot qua dua tuoi": "fresh coconut",
  "cho mot ly ca phe nong": "hot coffee",
  "cho mot ly": "one cup",
  "cai nua": "one more",
  "ly nuoc mia": "sugarcane juice",
  "cho nuoc sot vao ben canh": "sauce on the side",
  "tot": "good",
  "chin ky": "cooked through",
  "cho hai trong": "two of these",
  "thai": "pregnant",
  "buon non": "nauseous",
  "sot": "fever",
  "hen suyen": "asthma",
  "dau nguc": "chest pain",
  "tieu duong": "diabetes",
  "tieu chay": "diarrhea",
  "ngo doc thuc pham": "food poisoning",
  "dau hong": "sore throat",
  "cao huyet ap": "high blood pressure",
  "tho": "breathing",
  "o tay": "arm",
  "thuong o chan": "foot injury",
  "nay moi ngay": "this every day",
  "con trung can": "insect bite",
  "toi hieu huong dan": "I understand the instructions",
  "toi de nhan": "for check-in",
  "the ngu duoc vi qua on ao": "too noisy to sleep",
  "tot cam on": "good, thank you",
  "long": "polite request",
  "bi thieu": "missing",
  "mot phong tam": "a bathroom",
  "bay nhieu thoi": "this much only",
  "da bi tu choi": "was declined",
  "thay doi la": "the change is",
  "tinh sai so": "charged wrong amount",
  "ba": "elderly woman",
  "chu": "uncle-age man",
  "ong": "elderly man",
  "buoi chieu": "afternoon",
  "buoi sang": "morning",
  "y": "okay / idea",
  "tiec": "regret / apology",
  "lac voi dai su quan": "contacted the embassy",
  "nhung gi da xay ra": "what happened",
  "se lay no": "will take it",
  "qua lon": "too big",
  "qua nho": "too small",
  "mot mon qua": "a gift",
  "xet xung quanh": "look around",
  "doi voi toi": "for me",
  "the tim thay huong dan vien": "cannot find the guide",
  "tham quan": "a tour",
  "duoc gap": "to meet",
  "sai ngay": "wrong date",
  "ban sau nhe": "see you then",
  "hai nguoi": "two people",
  "trong xe": "in the car",
  "toan trong ung dung roi": "paid in the app already",
  "thue mot chiec": "rent one",
  "nang": "Da Nang",
  "la noi toi muon noi": "the place I meant",
  "xac": "correct",
  "da hieu": "understood",
  "lo nhung gi ban noi": "missed what you said",
  "gio toi da": "now I have",
  "tieng viet": "Vietnamese",
  "la y toi": "what I meant",
  "su hieu lam": "misunderstanding",
  "thang": "straight",
  "tang": "floor",
  "ai do co": "can someone",
  "ai do da": "someone did",
  "ap luc nuoc": "water pressure",
  "bac si dang": "the doctor is",
  "ban co bia": "do you have beer",
  "ban co cai": "do you have this",
  "ban co chap": "do you accept",
  "ban co doc": "can you read",
  "ban co kich": "do you have a size",
  "ban co mu": "do you have a helmet",
  "ban co nuoc": "do you have",
  "ban de xuat": "do you recommend",
  "ban la tai": "are you the driver",
  "ban o day": "you are staying here",
  "bay gio thi": "now it is",
  "bay gio toi": "now I",
  "bua sang luc": "breakfast is at",
  "cham them nuoc": "refill water",
  "chieu nay ban": "this afternoon",
  "chi tren ban": "point on the map",
  "chinh xac la": "exactly",
  "cho xin 1": "one ticket, please",
  "cho xin mot": "one, please",
  "chung ta co": "can we",
  "chuyen tau cuoi": "last boat / train",
  "chuyen tham quan": "the tour",
  "da co mot": "there has been a",
  "dich vu da": "service already",
  "do co phai": "is that",
  "do la loi": "that exit",
  "do la tat": "that is all",
  "doi lai muon": "move it later",
  "du lieu cua": "my data",
  "dung theo doi": "stop following",
  "duoc roi bay": "okay, now",
  "duoc roi toi": "okay, I will",
  "food allergies": "food allergies",
  "heo": "pork",
  "hom nay ban": "today, can you",
  "hom nay co": "is it open today",
  "hom nay troi": "today's weather",
  "internet rat": "internet is very",
  "lay lam": "feel regret",
  "lan tiep theo": "the next one",
  "lam the nao": "how to",
  "len": "get in / board",
  "loi vao nam": "the entrance is",
  "mon an nao": "which dish",
  "moi lan bao": "how many each time",
  "moi thu deu": "everything is",
  "nguoi lai xe": "the driver",
  "nguoi nay dang": "this person is",
  "no bat dau": "it starts",
  "no co dong": "is it closed",
  "no se co": "it will cost",
  "noi nay dong": "this place closes",
  "phai": "right",
  "price": "price",
  "rat vui": "very happy",
  "re": "turn",
  "san": "ready",
  "so xe": "car number",
  "so xe khac": "car number is different",
  "khac han": "different",
  "tai": "driver",
  "tan": "front desk",
  "the nay da": "is this already",
  "toi cam thay": "I feel",
  "toi chi co": "I only have",
  "toi de quen": "I left behind",
  "toi dua nham": "I gave by mistake",
  "toi gap nhom": "I meet the group",
  "toi hieu mot": "I understand",
  "toi kho": "I have trouble",
  "toi ky": "I sign",
  "toi len nham": "I got on the wrong",
  "toi nen dung": "I should take",
  "toi nen xuong": "I should get off",
  "toi rat xin": "I am very sorry",
  "toi yeu cau": "I asked for",
  "tong cong": "total",
  "trai": "left",
  "troi lanh": "cold",
  "tuyet voi gap": "great, see",
  "viec sua chua": "the repair",
  "voi hoa sen": "the shower",
  "voi sen chi": "the shower only",
  "xe buyt nao": "which bus",
  "xe nay co": "does this vehicle",
  "y anh/chi la": "which one do you mean",
  "y ban la": "do you mean",
}));

const weakGlossPatterns = [
  /\bdetail$/i,
  /^starts?\s+(?:the\s+)?phrase\b/i,
  /^finishes?\b/i,
  /^sets up\b/i,
  /^part of\b/i,
  /^proper name\b/i,
  /^proper name or place\b/i,
  /^place name\b/i,
  /^name starter\b/i,
  /^street name\b/i,
  /^market name\b/i,
  /^driver word$/i,
  /^phrase piece$/i,
  /^names\b/i,
  /^key word$/i,
  /^phrase ending$/i,
  /^question ending$/i,
  /^word$/i,
  /^action$/i,
  /^context word$/i,
  /^meaning to keep$/i,
  /^meaningful phrase part$/i,
  /^extra detail$/i,
  /^specific detail$/i,
  /^name or place detail$/i,
  /^(first|second|middle|final) name part$/i,
  /^soft reassurance$/i,
];

function normalize(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "d")
    .toLowerCase()
    .replace(/[^a-z0-9/]+/g, " ")
    .trim()
    .replace(/\s+/g, " ");
}

function audioTextKey(value) {
  return String(value ?? "").normalize("NFC").replace(/\s+/g, " ").trim().toLowerCase();
}

let exactAudioKeysByText = null;
function exactAudioKeyForText(text) {
  if (exactAudioKeysByText === null) {
    exactAudioKeysByText = { exact: new Map(), normalized: new Map() };
    if (fs.existsSync(audioManifestPath)) {
      const manifest = JSON.parse(fs.readFileSync(audioManifestPath, "utf8"));
      for (const [audioKey, entry] of Object.entries(manifest)) {
        if (!entry?.text) continue;
        const exact = audioTextKey(entry.text);
        if (exact && !exactAudioKeysByText.exact.has(exact)) {
          exactAudioKeysByText.exact.set(exact, audioKey);
        }
        const normalized = normalize(entry.text);
        if (normalized && !exactAudioKeysByText.normalized.has(normalized)) {
          exactAudioKeysByText.normalized.set(normalized, audioKey);
        }
      }
    }
  }
  return exactAudioKeysByText.exact.get(audioTextKey(text))
    ?? exactAudioKeysByText.normalized.get(normalize(text));
}

function weakGloss(value) {
  const text = String(value ?? "").trim();
  return weakGlossPatterns.some((pattern) => pattern.test(text));
}

function cleanEnglish(value) {
  return String(value ?? "")
    .replace(/\s*\.\.\.$/, "")
    .replace(/[?!.\s]+$/g, "")
    .trim();
}

function lowerFirst(value) {
  const text = cleanEnglish(value);
  if (!text) return text;
  if (/^(Wi-Fi|SIM|ATM|QR|US|Hanoi|Ho Chi Minh|Da Nang|Hue|Hoi An|Dong|Ben|Binh|An |District)/.test(text)) {
    return text;
  }
  return text[0].toLowerCase() + text.slice(1);
}

function stripDetail(value) {
  return cleanEnglish(String(value ?? "")
    .replace(/\s+detail$/i, "")
    .replace(/^finishes?\s+/i, "")
    .replace(/^starts?\s+(?:the\s+)?phrase$/i, "")
    .replace(/^sets up (?:the|a) (?:request|question)$/i, "")
    .replace(/^driver word$/i, "")
    .replace(/^part of the reply$/i, "")
    .replace(/^part of .+$/i, "")
    .replace(/^names (?:the situation|what you are looking for)$/i, "")
    .replace(/^(?:proper name(?: or place)?|place name|name starter|street name|market name)$/i, "")
    .replace(/^phrase piece$/i, ""));
}

function fallbackFromVietnamese(vietnamese) {
  const raw = String(vietnamese ?? "").trim().toLowerCase();
  if (raw === "bàn") return "table";
  if (raw === "bạn") return "you";
  if (raw === "còn trống") return "still available / open";
  if (raw === "này") return "this";
  if (raw === "có") return "have / yes";
  if (raw === "cô") return "aunt-age woman / respectful female address";
  if (raw === "chưa") return "not yet";
  if (raw === "chùa") return "pagoda";
  if (raw === "vé") return "ticket";
  if (raw === "vệ") return "hygiene";
  if (raw === "giấy vệ sinh") return "toilet paper";
  if (raw === "đá") return "ice / iced";
  if (raw === "đã") return "already";
  if (raw === "dạ") return "respectful opener";
  if (raw === "quầy") return "counter";
  if (raw === "quay") return "come back";
  if (raw === "lắm") return "very";
  if (raw === "làm") return "do / make";
  if (raw === "tới") return "arrive / reach";
  if (raw === "đưa") return "show / hand";
  if (raw === "mạng") return "network / connection";
  if (raw === "mất") return "takes / loses";
  if (raw === "năm") return "five";
  if (raw === "hộ") return "passport helper";
  if (raw === "yếu") return "weak";
  if (raw === "khoảng") return "about";
  if (raw === "tầng") return "floor";

  const key = normalize(vietnamese);
  if (exactGlosses.has(key)) return exactGlosses.get(key);
  if (key.startsWith("xin vui long") || key.startsWith("vui long") || key.startsWith("lam on")) return "please";
  if (key.startsWith("toi da bi")) return "I was / I got";
  if (key.startsWith("toi da")) return "I already / I did";
  if (key.startsWith("toi dang")) return "I am";
  if (key.startsWith("toi nghi")) return "I think";
  if (key.startsWith("toi se")) return "I will";
  if (key.startsWith("toi can")) return "I need";
  if (key.startsWith("toi muon")) return "I want";
  if (key.startsWith("toi khong")) return "I do not";
  if (key.startsWith("toi co the")) return "can I";
  if (key.startsWith("toi co")) return "I have";
  if (key.startsWith("toi bi")) return "I have / got";
  if (key.startsWith("ban co the")) return "can you";
  if (key.startsWith("ban da")) return "you already";
  if (key.startsWith("co phai")) return "is it / is this";
  if (key.startsWith("co the")) return "can";
  if (key.startsWith("co ")) return "is there / does it have";
  if (key.startsWith("xin ")) return "please / ask";
  if (key.startsWith("hay ")) return "please do";
  if (key.startsWith("cho toi")) return "for me / please";
  if (key.startsWith("dua cho toi")) return "give me";
  if (key.startsWith("noi chuyen voi")) return "speak with";
  if (key.startsWith("viet ")) return "write";
  if (key.startsWith("go ")) return "type";
  if (key.startsWith("goi ")) return "call";
  if (key.startsWith("gui ")) return "send / store";
  if (key.startsWith("di ")) return "go";
  if (key.startsWith("dung o")) return "stop at";
  return "";
}

function extractEntityFromEnglish(englishTitle) {
  const title = cleanEnglish(englishTitle);
  const patterns = [
    /^Where is (.+)$/i,
    /^Go to (.+)$/i,
    /^Stop at (.+)$/i,
    /^Take me to (.+)$/i,
    /^I want to go to (.+)$/i,
    /^Is it (?:near|next to|across from|on the corner of) (.+)$/i,
    /^Is this (?:the right|the correct) (.+)$/i,
    /^Which (.+) should I use$/i,
  ];
  for (const pattern of patterns) {
    const match = title.match(pattern);
    if (match?.[1]) return cleanEnglish(match[1]);
  }
  return "";
}

function objectFromEnglish(base) {
  let text = stripDetail(base);
  const directPatterns = [
    /^can you show me (.+)$/i,
    /^show me (.+)$/i,
    /^can you give me (.+)$/i,
    /^give me (.+)$/i,
    /^i would like (.+)$/i,
    /^i'd like (.+)$/i,
    /^i need (.+)$/i,
    /^i want (.+)$/i,
    /^do you have (.+)$/i,
    /^does this contain (.+)$/i,
    /^does this have (.+)$/i,
    /^is there (.+)$/i,
    /^buy (.+)$/i,
    /^have (.+)$/i,
    /^get (.+)$/i,
    /^order (.+)$/i,
    /^print (.+)$/i,
    /^type (.+)$/i,
    /^email (.+)$/i,
    /^send (.+)$/i,
    /^call (.+)$/i,
    /^contact (.+)$/i,
    /^report (.+)$/i,
    /^pay by (.+)$/i,
    /^pay .+ by (.+)$/i,
    /^use (.+)$/i,
    /^activate (.+)$/i,
    /^install (.+)$/i,
    /^restart (.+)$/i,
    /^wrap (.+)$/i,
    /^wash (.+)$/i,
    /^dry (.+)$/i,
    /^clean (.+)$/i,
    /^leave (.+)$/i,
    /^store (.+)$/i,
    /^arrange (.+)$/i,
    /^make it (.+)$/i,
    /^put it (.+)$/i,
  ];
  for (const pattern of directPatterns) {
    const match = text.match(pattern);
    if (match?.[1]) {
      text = match[1];
      break;
    }
  }
  return lowerFirst(text);
}

function isLowercaseVietnameseParticle(vietnamese, value) {
  const text = String(vietnamese ?? "").trim();
  return normalize(text) === value && text[0] === text[0]?.toLowerCase();
}

function inferFromEnglishAndToken(vietnamese, oldGloss, pageEnglish) {
  const key = normalize(vietnamese);
  const base = stripDetail(oldGloss);
  const lowerBase = base.toLowerCase();

  const vietnameseFallback = fallbackFromVietnamese(vietnamese);
  if (vietnameseFallback) return vietnameseFallback;

  if (key === "tai" && lowerBase.includes("driver")) return "driver";
  if (key === "xe" && String(vietnamese ?? "").trim().toLowerCase() === "xế") return "driver";
  if (key === "pass") return "password";
  if (key === "bat") return "start";
  if (key === "dau" && normalize(pageEnglish).includes("start")) return "start";
  if (key === "diem") return "point";
  if (key === "mat" && normalize(pageEnglish).includes("item")) return "item";
  if (key === "di" && isLowercaseVietnameseParticle(vietnamese, "di")) return "soft command ending";
  if (key === "ngu") return "sleep";
  if (key === "hieu") return "understand";
  if (key === "thuat" && normalize(pageEnglish).includes("translation app")) return "translation app";
  if (key === "te" && normalize(pageEnglish).includes("medical report")) return "medical";
  if (key === "hiem" && normalize(pageEnglish).includes("insurance")) return "insurance";

  if (key.includes("bang the")) return "by card";
  if (key === "bac" && lowerBase.includes("bac xiu")) return "sweet milk";
  if (key === "xiu" && lowerBase.includes("bac xiu")) return "coffee style";
  if (key.includes("ma qr")) return "by QR code";
  if (key.includes("tieng anh")) return "in English";
  if (key.includes("van ban")) return "in writing";
  if (key.includes("duoc khong")) return "is it possible?";
  if (key.includes("khong")) return "yes/no question";
  if (key.includes("o dau")) return "where?";
  if (key.includes("cho toi xem")) return "show me / let me see";
  if (key.includes("xem")) return "show / see";
  if (key.includes("goi")) return "call";
  if (key.includes("gui email")) return "email";
  if (key.includes("gui tin nhan")) return "send a message";
  if (key.includes("gui")) return "send / store";
  if (key.includes("tra lai")) return "return / give back";
  if (key.includes("hoan tien")) return "refund";
  if (key.includes("lien he")) return "contact";
  if (key.includes("bao cao")) return "report";
  if (key.includes("dat")) return "book / reserve";
  if (key.includes("mua")) return "buy";
  if (key.includes("thanh toan") || key.includes("tra")) return "pay";
  if (key.includes("cho toi") && lowerBase.includes("for me")) return "for me";
  if (key.includes("cho toi")) return "for me / please";
  if (key.includes("mot ")) return objectFromEnglish(base);
  if (key.includes("buc anh")) return "a picture";
  if (key.includes("anh") && lowerBase.includes("picture")) return "a picture";
  if (key.includes("dia chi")) return "address";
  if (key.includes("hoa don")) return lowerBase.includes("receipt") ? "receipt" : "bill";
  if (key.includes("bien nhan")) return "receipt";
  if (key.includes("ho chieu")) return "passport";
  if (key.includes("hanh ly")) return "luggage";
  if (key.includes("phong")) return "room";
  if (key.includes("cua so")) return "window";
  if (key.includes("bao hiem")) return "insurance";
  if (key.includes("an toan")) return "safe";
  if (key.includes("thuc an")) return "food";
  if (key.includes("thit")) return "meat";
  if (key.includes("dau phong")) return "peanuts";
  if (key.includes("tom")) return "shrimp";
  if (key.includes("hai san")) return "seafood";
  if (key.includes("thuoc")) return "medicine";
  if (key.includes("sim")) return "SIM card";
  if (key.includes("wifi") || key.includes("wi fi")) return "Wi-Fi";
  if (key.includes("ma")) return "code";
  if (key.includes("phi")) return "fee";
  if (key.includes("gia")) return "price";
  if (key.includes("ve")) return "ticket";
  if (key.includes("tai xe")) return "driver";
  if (key.includes("khach san")) return "hotel";
  if (key.includes("san bay")) return "airport";
  if (key.includes("nha ve sinh")) return "bathroom";
  if (key.includes("nha thuoc")) return "pharmacy";
  if (key.includes("benh vien")) return "hospital";
  if (key.includes("dai su quan")) return "embassy";
  if (key.includes("ban do")) return "map";
  if (key.includes("dien thoai")) return "phone";
  if (key.includes("ung dung")) return "app";
  if (key.includes("dung o")) return "stop at";
  if (key.includes("di den")) return "go to";
  if (key === "di") return "go";
  if (key.includes("gan")) return "near";

  const entity = extractEntityFromEnglish(pageEnglish);
  if (entity && /^[\p{Lu}Đ]/u.test(String(vietnamese).trim())) {
    return entity;
  }

  const object = objectFromEnglish(base);
  if (object && !weakGloss(object) && object.split(/\s+/).length <= 5 && normalize(object) !== normalize(pageEnglish)) {
    return object;
  }
  if (!base || weakGloss(base)) {
    return "meaningful phrase part";
  }
  const fallback = lowerFirst(base);
  if (normalize(fallback) === normalize(pageEnglish)) {
    return "meaningful phrase part";
  }
  return fallback;
}

const forcedAdjacentMergeKeys = new Set([
  "bac xiu",
  "bao cao y te",
  "bat dau",
  "bien nhan bao hiem",
  "chung ta",
  "diem gap",
  "duong nay di",
  "duong nay",
  "ho chieu",
  "khoang muoi",
  "khan cap",
  "mat hang",
  "nam phut",
  "tai xe",
  "truoc khi di ngu",
  "ung dung dich thuat",
]);

function mergeTokenPair(left, right, english) {
  const vietnamese = `${tokenVietnamese(left)} ${tokenVietnamese(right)}`.replace(/\s+/g, " ").trim();
  const exactAudioKey = exactAudioKeyForText(vietnamese);
  if (Array.isArray(left)) {
    left[0] = vietnamese;
    left[1] = english;
  } else {
    left.vietnamese = vietnamese;
    left.english = english;
    if (exactAudioKey) {
      left.audioKey = exactAudioKey;
    } else {
      delete left.audioKey;
    }
  }
  return left;
}

function mergeKnownAdjacentChunks(tokens, stats) {
  const merged = [];
  let changed = false;
  for (const token of tokens) {
    const previous = merged[merged.length - 1];
    const combinedKey = previous ? normalize(`${tokenVietnamese(previous)} ${tokenVietnamese(token)}`) : "";
    const combinedGloss = exactGlosses.get(combinedKey);
    const shouldMerge = combinedGloss && (
      forcedAdjacentMergeKeys.has(combinedKey)
      || weakGloss(tokenEnglish(previous))
      || weakGloss(tokenEnglish(token))
      || normalize(tokenEnglish(previous)) === normalize(tokenEnglish(token))
    );
    if (previous && shouldMerge) {
      merged[merged.length - 1] = mergeTokenPair(previous, token, combinedGloss);
      stats.merged += 1;
      changed = true;
    } else {
      merged.push(token);
    }
  }
  return { tokens: merged, changed };
}

function collectJSONFiles(dir) {
  if (!fs.existsSync(dir)) return [];
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...collectJSONFiles(fullPath));
    } else if (entry.isFile() && entry.name.endsWith(".json")) {
      files.push(fullPath);
    }
  }
  return files;
}

function practiceSourceFiles() {
  if (!fs.existsSync(practiceManifestPath)) return [];
  const manifest = JSON.parse(fs.readFileSync(practiceManifestPath, "utf8"));
  return (manifest.sourceShards ?? []).map((item) => path.join(practiceExpansionRoot, item));
}

function allSourceFiles() {
  return [
    ...collectJSONFiles(tierOnePagesRoot),
    ...collectJSONFiles(catalogPromotedPagesRoot),
    cityLibraryPath,
    ...practiceSourceFiles(),
    authoredResourcePath,
  ].filter((filePath) => fs.existsSync(filePath));
}

function addGloss(glossary, vietnamese, english) {
  const key = normalize(vietnamese);
  const value = cleanEnglish(english);
  if (!key || !value || weakGloss(value) || normalize(value) === "full phrase") return;
  if (!glossary.has(key)) glossary.set(key, value);
}

function buildGlossary(files) {
  const glossary = new Map(exactGlosses);
  if (fs.existsSync(cityLibraryPath)) {
    const city = JSON.parse(fs.readFileSync(cityLibraryPath, "utf8"));
    for (const phrase of city.phrases ?? []) {
      for (const [vietnamese, english] of phrase.chunks ?? []) {
        addGloss(glossary, vietnamese, english);
      }
    }
  }
  for (const filePath of files) {
    const json = JSON.parse(fs.readFileSync(filePath, "utf8"));
    const pages = Array.isArray(json.pages) ? json.pages : [json];
    for (const page of pages) {
      for (const token of page.chunks ?? []) {
        addGloss(glossary, tokenVietnamese(token), tokenEnglish(token));
      }
      for (const section of page.sections ?? []) {
        for (const token of section.breakdown ?? []) {
          addGloss(glossary, tokenVietnamese(token), tokenEnglish(token));
        }
      }
    }
  }
  return glossary;
}

function englishTitleForPage(page) {
  return page.englishTitle ?? page.englishText ?? page.summary ?? "";
}

function fullPhraseGloss(page) {
  const gloss = cleanEnglish(englishTitleForPage(page));
  return gloss || "phrase meaning";
}

function tokenVietnamese(token) {
  return Array.isArray(token) ? token[0] : token.vietnamese;
}

function tokenEnglish(token) {
  return Array.isArray(token) ? token[1] : token.english;
}

function setTokenVietnamese(token, vietnamese) {
  if (Array.isArray(token)) {
    token[0] = vietnamese;
  } else {
    token.vietnamese = vietnamese;
  }
}

function setTokenEnglish(token, english) {
  if (Array.isArray(token)) {
    token[1] = english;
  } else {
    token.english = english;
  }
}

function inferGloss(token, page, glossary) {
  const vietnamese = tokenVietnamese(token) ?? "";
  const key = normalize(vietnamese);
  const oldGloss = tokenEnglish(token) ?? "";
  const pageEnglish = englishTitleForPage(page);
  const rawFallback = fallbackFromVietnamese(vietnamese);
  if (rawFallback) return rawFallback;
  if (exactGlosses.has(key)) return exactGlosses.get(key);
  if (glossary.has(key)) return glossary.get(key);
  return inferFromEnglishAndToken(vietnamese, oldGloss, pageEnglish);
}

function isFullPhraseToken(page, token) {
  if (page.kind === "place") return false;
  const vietnamese = tokenVietnamese(token);
  const english = tokenEnglish(token);
  return normalize(vietnamese) === normalize(page.title ?? page.targetText)
    || normalize(english) === "full phrase";
}

function hasNonFinalFullPhraseToken(page, tokens) {
  if (page.kind === "place" || tokens.length < 2) return false;
  const titleKey = normalize(page.title ?? page.targetText);
  return tokens
    .slice(0, -1)
    .some((token) => titleKey && normalize(tokenVietnamese(token)) === titleKey);
}

function hasNonFinalWholeEnglishGloss(page, tokens) {
  if (tokens.length < 2) return false;
  const titleKey = normalize(englishTitleForPage(page));
  return tokens
    .slice(0, -1)
    .some((token) => titleKey && normalize(tokenEnglish(token)) === titleKey);
}

function hasWeakNonFinalGloss(tokens) {
  return tokens
    .slice(0, -1)
    .some((token) => weakGloss(tokenEnglish(token)));
}

function replacementForDuplicateFullPhraseBreakdown(page, tokens) {
  const title = String(page.title ?? page.targetText ?? "").trim();
  const key = normalize(title);
  if (key === "toi hieu mot chut") {
    const fullAudioKey = tokens.find((token) => normalize(tokenVietnamese(token)) === key && token.audioKey)?.audioKey
      ?? exactAudioKeyForText(title);
    const full = { id: "chunk-3", vietnamese: title, english: fullPhraseGloss(page) };
    if (fullAudioKey) full.audioKey = fullAudioKey;
    return [
      { id: "chunk-1", vietnamese: "Tôi hiểu", english: "I understand" },
      { id: "chunk-2", vietnamese: "một chút", english: "a little" },
      full,
    ];
  }
  if (key === "dua ho chieu ra") {
    const fullAudioKey = tokens.find((token) => normalize(tokenVietnamese(token)) === key && token.audioKey)?.audioKey
      ?? exactAudioKeyForText(title);
    const full = { id: "chunk-4", vietnamese: title, english: fullPhraseGloss(page) };
    if (fullAudioKey) full.audioKey = fullAudioKey;
    return [
      { id: "chunk-1", vietnamese: "Đưa", english: "show / hand" },
      { id: "chunk-2", vietnamese: "hộ chiếu", english: "passport" },
      { id: "chunk-3", vietnamese: "ra", english: "out / forward" },
      full,
    ];
  }
  if (key === "mat khoang nam phut") {
    const fullAudioKey = tokens.find((token) => normalize(tokenVietnamese(token)) === key && token.audioKey)?.audioKey
      ?? exactAudioKeyForText(title);
    const full = { id: "chunk-4", vietnamese: title, english: fullPhraseGloss(page) };
    if (fullAudioKey) full.audioKey = fullAudioKey;
    return [
      { id: "chunk-1", vietnamese: "Mất", english: "takes" },
      { id: "chunk-2", vietnamese: "khoảng", english: "about" },
      { id: "chunk-3", vietnamese: "năm phút", english: "five minutes" },
      full,
    ];
  }
  if (key === "lay lam tiec") {
    const fullAudioKey = tokens.find((token) => normalize(tokenVietnamese(token)) === key && token.audioKey)?.audioKey
      ?? exactAudioKeyForText(title);
    const full = { id: "chunk-3", vietnamese: title, english: fullPhraseGloss(page) };
    if (fullAudioKey) full.audioKey = fullAudioKey;
    return [
      { id: "chunk-1", vietnamese: "Lấy làm", english: "feel regret" },
      { id: "chunk-2", vietnamese: "tiếc", english: "regret / sorry" },
      full,
    ];
  }
  if (key === "so xe khac han") {
    const fullAudioKey = tokens.find((token) => normalize(tokenVietnamese(token)) === key && token.audioKey)?.audioKey
      ?? exactAudioKeyForText(title);
    const full = { id: "chunk-3", vietnamese: title, english: fullPhraseGloss(page) };
    if (fullAudioKey) full.audioKey = fullAudioKey;
    return [
      { id: "chunk-1", vietnamese: "Số xe", english: "car number" },
      { id: "chunk-2", vietnamese: "khác hẳn", english: "different" },
      full,
    ];
  }
  if (key === "y anh/chi la cai nao") {
    const fullAudioKey = tokens.find((token) => normalize(tokenVietnamese(token)) === key && token.audioKey)?.audioKey
      ?? exactAudioKeyForText(title);
    const full = { id: "chunk-3", vietnamese: title, english: fullPhraseGloss(page) };
    if (fullAudioKey) full.audioKey = fullAudioKey;
    return [
      { id: "chunk-1", vietnamese: "Ý anh/chị", english: "your meaning" },
      { id: "chunk-2", vietnamese: "là cái nào", english: "is which one?" },
      full,
    ];
  }
  if (key === "noi nao it dong duc hon") {
    const fullAudioKey = tokens.find((token) => normalize(tokenVietnamese(token)) === key && token.audioKey)?.audioKey
      ?? exactAudioKeyForText(title);
    const full = { id: "chunk-3", vietnamese: title, english: fullPhraseGloss(page) };
    if (fullAudioKey) full.audioKey = fullAudioKey;
    return [
      { id: "chunk-1", vietnamese: "Nơi nào", english: "which place" },
      { id: "chunk-2", vietnamese: "ít đông đúc hơn", english: "less crowded" },
      full,
    ];
  }
  if (key !== "re trai" && key !== "re phai") return null;
  const fullAudioKey = tokens.find((token) => normalize(tokenVietnamese(token)) === key && token.audioKey)?.audioKey
    ?? exactAudioKeyForText(title);
  const sideText = key === "re trai" ? "trái" : "phải";
  const sideGloss = key === "re trai" ? "left" : "right";
  const full = { id: "chunk-3", vietnamese: title, english: fullPhraseGloss(page) };
  if (fullAudioKey) full.audioKey = fullAudioKey;
  return [
    { id: "chunk-1", vietnamese: "Rẽ", english: "turn" },
    { id: "chunk-2", vietnamese: sideText, english: sideGloss },
    full,
  ];
}

function repairBreakdown(page, section, glossary, stats) {
  let tokens = section.breakdown ?? [];
  if (!Array.isArray(tokens) || tokens.length === 0) return false;

  let changed = false;
  const knownMerge = mergeKnownAdjacentChunks(tokens, stats);
  if (knownMerge.changed) {
    tokens = knownMerge.tokens;
    section.breakdown = tokens;
    changed = true;
  }

  const duplicateFullPhraseReplacement = replacementForDuplicateFullPhraseBreakdown(page, tokens);
  if (
    duplicateFullPhraseReplacement
    && (tokens.filter((token) => isFullPhraseToken(page, token)).length > 1
      || hasNonFinalFullPhraseToken(page, tokens)
      || hasNonFinalWholeEnglishGloss(page, tokens)
      || hasWeakNonFinalGloss(tokens))
  ) {
    tokens = duplicateFullPhraseReplacement;
    section.breakdown = tokens;
    changed = true;
    stats.repaired += 1;
  }

  for (const token of tokens) {
    const vietnamese = tokenVietnamese(token);
    const english = tokenEnglish(token);
    const isFullPhrase = isFullPhraseToken(page, token);
    if (isFullPhrase) {
      const replacement = fullPhraseGloss(page);
      if (english !== replacement) {
        setTokenEnglish(token, replacement);
        changed = true;
        stats.repaired += 1;
      }
      continue;
    }
    if (normalize(vietnamese) === "di" && normalize(english) === "soft command ending") continue;

    const hasAuthoritativeGloss = exactGlosses.has(normalize(vietnamese));
    if (!hasAuthoritativeGloss && !weakGloss(english) && normalize(english) !== normalize(englishTitleForPage(page))) continue;
    const replacement = inferGloss(token, page, glossary);
    if (replacement && replacement !== english) {
      setTokenEnglish(token, replacement);
      changed = true;
      stats.repaired += 1;
    }
  }

  const seenLabelsByToken = new Set();
  for (const token of tokens) {
    if (isFullPhraseToken(page, token)) continue;
    const vietnameseKey = normalize(tokenVietnamese(token));
    const englishKey = normalize(tokenEnglish(token));
    const pairKey = `${vietnameseKey}:${englishKey}`;
    if (vietnameseKey === "di" && englishKey === "go" && seenLabelsByToken.has(pairKey)) {
      setTokenEnglish(token, "soft command ending");
      changed = true;
      stats.repaired += 1;
    }
    seenLabelsByToken.add(pairKey);
  }

  const merged = [];
  for (const token of tokens) {
    const previous = merged[merged.length - 1];
    const vietnamese = tokenVietnamese(token);
    const english = tokenEnglish(token);
    const isFullPhrase = isFullPhraseToken(page, token);
    if (
      previous
      && !isFullPhrase
      && normalize(tokenEnglish(previous)) === normalize(english)
      && normalize(tokenEnglish(previous)) !== "full phrase"
    ) {
      setTokenVietnamese(previous, `${tokenVietnamese(previous)} ${vietnamese}`.replace(/\s+/g, " ").trim());
      if (!Array.isArray(previous)) previous.id = previous.id ?? token.id;
      stats.merged += 1;
      changed = true;
    } else {
      merged.push(token);
    }
  }

  for (const token of merged) {
    const vietnamese = tokenVietnamese(token);
    const english = tokenEnglish(token);
    const isFullPhrase = isFullPhraseToken(page, token);
    if (isFullPhrase) continue;
    if (normalize(vietnamese) === "di" && normalize(english) === "soft command ending") continue;
    const hasAuthoritativeGloss = exactGlosses.has(normalize(vietnamese));
    if (!hasAuthoritativeGloss && !weakGloss(english) && normalize(english) !== normalize(englishTitleForPage(page))) continue;
    const replacement = inferGloss(token, page, glossary);
    if (replacement && replacement !== english) {
      setTokenEnglish(token, replacement);
      changed = true;
      stats.repaired += 1;
    }
  }

  if (merged.length !== tokens.length) {
    section.breakdown = merged.map((token, index) => {
      if (Array.isArray(token)) return token;
      return {
        ...token,
        id: token.id?.startsWith("chunk-") ? `chunk-${index + 1}` : token.id,
      };
    });
  }
  return changed;
}

function romanizedTitle(value) {
  return String(value ?? "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "D")
    .split(/\s+/)
    .filter(Boolean)
    .map((word) => {
      if (/^[A-Z0-9]+$/.test(word)) return word;
      return word.charAt(0).toUpperCase() + word.slice(1);
    })
    .join(" ");
}

function removeEnglishTypeWords(english, patterns) {
  let label = cleanEnglish(english);
  for (const pattern of patterns) {
    label = label
      .replace(pattern, " ")
      .replace(/\s+/g, " ")
      .trim();
  }
  return label;
}

function cityRecognitionLabel(page, fallback = "local name") {
  const pageKind = page.pageKind ?? page.cityMetadata?.pageKind ?? "";
  if (pageKind === "restaurant") return "restaurant name";
  if (pageKind === "dish") return "dish name";
  return fallback;
}

function cityRecognitionEndingLabel(page) {
  const pageKind = page.pageKind ?? page.cityMetadata?.pageKind ?? "";
  if (pageKind === "restaurant") return "restaurant name";
  if (pageKind === "dish") return "dish name";
  return "local name";
}

function placeNameRemainderLabel(restVietnamese, english, typePatterns, page) {
  const fromEnglish = removeEnglishTypeWords(english, typePatterns);
  if (fromEnglish && normalize(fromEnglish) !== normalize(english) && !weakGloss(fromEnglish)) {
    return cityRecognitionLabel(page);
  }
  return cityRecognitionLabel(page);
}

const cityPlacePrefixRules = [
  [/^(phố đi bộ)\s+(.+)$/iu, "walking street", [/\bWalking Street\b/gi, /\bStreet\b/gi]],
  [/^(phố cổ)\s+(.+)$/iu, "old quarter", [/\bOld Quarter\b/gi, /\bOld Town\b/gi]],
  [/^(chợ đêm)\s+(.+)$/iu, "night market", [/\bNight Market\b/gi, /\bMarket\b/gi]],
  [/^(chợ hoa)\s+(.+)$/iu, "flower market", [/\bFlower Market\b/gi, /\bMarket\b/gi]],
  [/^(làng dừa)\s+(.+)$/iu, "coconut village", [/\bCoconut Village\b/gi, /\bVillage\b/gi]],
  [/^(làng gốm)\s+(.+)$/iu, "pottery village", [/\bPottery Village\b/gi, /\bVillage\b/gi]],
  [/^(làng mộc)\s+(.+)$/iu, "carpentry village", [/\bCarpentry Village\b/gi, /\bVillage\b/gi]],
  [/^(làng rau)\s+(.+)$/iu, "vegetable village", [/\bVegetable Village\b/gi, /\bVillage\b/gi]],
  [/^(làng đá)\s+(.+)$/iu, "stone village", [/\bStone Carving Village\b/gi, /\bStone Village\b/gi, /\bVillage\b/gi]],
  [/^(rừng dừa)\s+(.+)$/iu, "coconut forest", [/\bCoconut Forest\b/gi, /\bForest\b/gi]],
  [/^(bưu điện)\s+(.+)$/iu, "post office", [/\bPost Office\b/gi]],
  [/^(bảo tàng)\s+(.+)$/iu, "museum", [/^Museum of\s+/i, /\bMuseum\b/gi]],
  [/^(nhà thờ)\s+(.+)$/iu, "cathedral / church", [/\bCathedral\b/gi, /\bChurch\b/gi]],
  [/^(nhà hát)\s+(.+)$/iu, "theatre / opera house", [/\bOpera House\b/gi, /\bTheatre\b/gi, /\bTheater\b/gi]],
  [/^(nhà tù)\s+(.+)$/iu, "prison", [/\bPrison\b/gi]],
  [/^(nhà cổ)\s+(.+)$/iu, "old house", [/\bOld House\b/gi, /\bHouse\b/gi]],
  [/^(quảng trường)\s+(.+)$/iu, "square", [/\bSquare\b/gi]],
  [/^(thánh địa)\s+(.+)$/iu, "sanctuary", [/\bSanctuary\b/gi]],
  [/^(hội quán)\s+(.+)$/iu, "assembly hall", [/\bAssembly Hall\b/gi]],
  [/^(sân bay)\s+(.+)$/iu, "airport", [/\bAirport\b/gi]],
  [/^(công viên)\s+(.+)$/iu, "park", [/\bPark\b/gi]],
  [/^(đường)\s+(.+)$/iu, "street", [/\bStreet\b/gi, /\bRoad\b/gi]],
  [/^(chợ)\s+(.+)$/iu, "market", [/\bMarket\b/gi]],
  [/^(cầu)\s+(.+)$/iu, "bridge", [/\bBridge\b/gi]],
  [/^(sông)\s+(.+)$/iu, "river", [/\bRiver\b/gi]],
  [/^(chùa)\s+(.+)$/iu, "pagoda", [/\bPagoda\b/gi]],
  [/^(biển)\s+(.+)$/iu, "beach", [/\bBeach\b/gi]],
  [/^(ga)\s+(.+)$/iu, "station", [/\bRailway Station\b/gi, /\bTrain Station\b/gi, /\bStation\b/gi]],
  [/^(bán đảo)\s+(.+)$/iu, "peninsula", [/\bPeninsula\b/gi]],
  [/^(cảng)\s+(.+)$/iu, "port", [/\bPort\b/gi]],
  [/^(đỉnh)\s+(.+)$/iu, "peak", [/\bPeak\b/gi]],
  [/^(đảo)\s+(.+)$/iu, "island", [/\bIsland\b/gi]],
  [/^(miếu)\s+(.+)$/iu, "temple", [/\bTemple\b/gi]],
  [/^(đền)\s+(.+)$/iu, "temple", [/\bTemple\b/gi]],
  [/^(tòa nhà)\s+(.+)$/iu, "tower / building", [/\bTower\b/gi, /\bBuilding\b/gi]],
  [/^(dinh)\s+(.+)$/iu, "palace", [/\bPalace\b/gi]],
  [/^(lăng)\s+(.+)$/iu, "mausoleum", [/\bMausoleum\b/gi]],
  [/^(hồ)\s+(.+)$/iu, "lake", [/\bLake\b/gi]],
  [/^(quán cà phê|cà phê)\s+(.+)$/iu, "cafe", [/\bCafe\b/gi, /\bCoffee\b/gi]],
  [/^(bến)\s+(.+)$/iu, "wharf / pier", [/\bWharf\b/gi, /\bPier\b/gi]],
  [/^(quận)\s+(.+)$/iu, "district", [/\bDistrict\b/gi]],
  [/^(rạn)\s+(.+)$/iu, "reef", [/\bReef\b/gi]],
  [/^(cù lao)\s+(.+)$/iu, "islands", [/\bIslands\b/gi, /\bIsland\b/gi]],
];

const cityPlaceExactSplits = new Map(Object.entries({
  "pho duong tau ha noi": [
    ["Phố đường tàu", "train street"],
    ["Hà Nội", "Hanoi"],
  ],
  "ba na hills": [
    ["Bà Nà", "local name"],
    ["Hills", "English word in the name"],
  ],
  "ngu hanh son": [
    ["Ngũ Hành", "local name"],
    ["Sơn", "mountain name"],
  ],
  "nen da nang": [
    ["Nén", "restaurant name"],
    ["Đà Nẵng", "Da Nang"],
  ],
}));

function splitFallbackPlaceName(vietnamese, english, page) {
  const viWords = String(vietnamese ?? "").split(/\s+/).filter(Boolean);
  const enWords = cleanEnglish(english).split(/\s+/).filter(Boolean);
  if (viWords.length <= 1) {
    return [[vietnamese, cleanEnglish(english) || romanizedTitle(vietnamese)]];
  }

  const firstCount = Math.max(1, Math.ceil(viWords.length / 2));
  const viFirst = viWords.slice(0, firstCount).join(" ");
  const viSecond = viWords.slice(firstCount).join(" ");
  const enFirstCount = Math.max(1, Math.min(enWords.length - 1, firstCount));
  const enFirst = enWords.slice(0, enFirstCount).join(" ");
  const enSecond = enWords.slice(enFirstCount).join(" ");

  return [
    [viFirst, cityRecognitionLabel(page, "local name")],
    [viSecond, cityRecognitionEndingLabel(page)],
  ];
}

function cityPlaceChunks(page) {
  const vietnamese = cleanEnglish(page.targetText);
  const english = cleanEnglish(page.englishText);
  const exact = cityPlaceExactSplits.get(normalize(vietnamese));
  if (exact) return exact;
  for (const [pattern, typeLabel, englishTypePatterns] of cityPlacePrefixRules) {
    const match = vietnamese.match(pattern);
    if (!match) continue;
    const prefix = match[1].trim();
    const rest = match[2].trim();
    if (!rest) break;
    return [
      [prefix, typeLabel],
      [rest, placeNameRemainderLabel(rest, english, englishTypePatterns, page)],
    ];
  }
  return splitFallbackPlaceName(vietnamese, english, page);
}

function repairPage(page, glossary, stats) {
  let changed = false;
  if (page.cityMetadata?.pageKind) {
    return false;
  }
  if (
    page.kind === "place"
    && Array.isArray(page.chunks)
    && page.targetText
    && page.englishText
  ) {
    const nextChunks = cityPlaceChunks(page);
    if (JSON.stringify(page.chunks) !== JSON.stringify(nextChunks)) {
      page.chunks = nextChunks;
      changed = true;
      stats.repaired += 1;
    }
    for (const section of page.sections ?? []) {
      if (repairBreakdown(page, section, glossary, stats)) changed = true;
    }
    return changed;
  }
  if (Array.isArray(page.chunks)) {
    const section = { breakdown: page.chunks };
    if (repairBreakdown(page, section, glossary, stats)) {
      page.chunks = section.breakdown;
      changed = true;
    }
  }
  for (const section of page.sections ?? []) {
    if (repairBreakdown(page, section, glossary, stats)) changed = true;
  }
  return changed;
}

function repairFile(filePath, glossary, stats, dryRun) {
  const before = fs.readFileSync(filePath, "utf8");
  const json = JSON.parse(before);
  let changed = false;
  if (Array.isArray(json.pages)) {
    for (const page of json.pages) {
      if (repairPage(page, glossary, stats)) changed = true;
    }
  } else if (repairPage(json, glossary, stats)) {
    changed = true;
  }
  if (!changed) return;
  stats.files += 1;
  stats.changedFilePaths.push(path.relative(repoRoot, filePath));
  if (!dryRun) {
    fs.writeFileSync(filePath, `${JSON.stringify(json, null, 2)}\n`);
  }
}

function main() {
  const dryRun = process.argv.includes("--check") || process.argv.includes("--dry-run");
  const files = allSourceFiles();
  const glossary = buildGlossary(files);
  const stats = { files: 0, repaired: 0, merged: 0, changedFilePaths: [] };
  for (const filePath of files) {
    repairFile(filePath, glossary, stats, dryRun);
  }
  console.log(JSON.stringify({
    ok: true,
    dryRun,
    scannedFiles: files.length,
    changedFiles: stats.files,
    changedFilePaths: stats.changedFilePaths.slice(0, 25),
    repairedBreakdownLabels: stats.repaired,
    mergedDuplicateBreakdownCards: stats.merged,
  }, null, 2));
}

main();
