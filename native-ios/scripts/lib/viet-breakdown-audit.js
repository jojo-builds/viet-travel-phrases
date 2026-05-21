const fs = require("fs");
const path = require("path");

const DEFAULT_AUDIT_RELATIVE_ROOT = path.join("content-draft", "viet", "breakdown-audit");
const DEFAULT_LEDGER_RELATIVE_ROOT = path.join(DEFAULT_AUDIT_RELATIVE_ROOT, "pages");

const PLACEHOLDER_GLOSSES = new Set([
  "action",
  "context word",
  "detail",
  "extra detail",
  "first name part",
  "key word",
  "main phrase piece",
  "meaning to keep",
  "meaningful phrase part",
  "name or place detail",
  "phrase ending",
  "phrase piece",
  "place / service",
  "place name",
  "question ending",
  "question marker",
  "give / provide",
  "street / sugar",
  "water / country",
  "specific detail",
  "the action",
  "the main place or thing",
  "word",
  "attraction name",
  "english word in the attraction name",
]);

const MALFORMED_LEGACY_CHUNKS = new Set([
  "gui email cho = email",
  "gui email bao = email",
  "cao cho toi = for me / please",
]);

const ALLOWED_SELF_GLOSS_TOKENS = new Set([
  "aa",
  "camera",
  "email",
  "esim",
  "faifo coffee",
  "gigabyte",
  "gluten",
  "grab",
  "internet",
  "kg",
  "landmark 81",
  "les jardins de la carambole",
  "penicillin",
  "photocopy",
  "reaching out tea house",
  "scan",
  "size",
  "taxi",
  "wi-fi",
]);

const FORBIDDEN_SPLIT_SEQUENCES = [
  {
    vietnamese: "sô cô la",
    pieces: ["sô", "cô", "la"],
    expectedGloss: "chocolate",
  },
  {
    vietnamese: "Việt Nam",
    pieces: ["Việt", "Nam"],
    expectedGloss: "Vietnam / Vietnamese",
  },
  {
    vietnamese: "cảnh sát",
    pieces: ["cảnh", "sát"],
    expectedGloss: "police",
  },
  {
    vietnamese: "đồn cảnh sát",
    pieces: ["đồn", "cảnh", "sát"],
    expectedGloss: "police station",
  },
  {
    vietnamese: "nhập cảnh",
    pieces: ["nhập", "cảnh"],
    expectedGloss: "immigration / enter the country",
  },
  {
    vietnamese: "đậu phộng",
    pieces: ["đậu", "phộng"],
    expectedGloss: "peanuts",
  },
  {
    vietnamese: "tiêu chảy",
    pieces: ["tiêu", "chảy"],
    expectedGloss: "diarrhea",
  },
  {
    vietnamese: "say xe",
    pieces: ["say", "xe"],
    expectedGloss: "motion sickness / carsick",
  },
  {
    vietnamese: "bạc xỉu",
    pieces: ["bạc", "xỉu"],
    expectedGloss: "bạc xỉu coffee",
  },
  {
    vietnamese: "bưu điện",
    pieces: ["bưu", "điện"],
    expectedGloss: "post office",
  },
  {
    vietnamese: "máy bay",
    pieces: ["máy", "bay"],
    expectedGloss: "plane",
  },
  {
    vietnamese: "được phép",
    pieces: ["được", "phép"],
    expectedGloss: "allowed / permitted",
  },
  {
    vietnamese: "thẻ phòng",
    pieces: ["thẻ", "phòng"],
    expectedGloss: "room key card",
  },
  {
    vietnamese: "xe buýt",
    pieces: ["xe", "buýt"],
    expectedGloss: "bus",
  },
  {
    vietnamese: "xe máy",
    pieces: ["xe", "máy"],
    expectedGloss: "motorbike",
  },
  {
    vietnamese: "nước hoa",
    pieces: ["nước", "hoa"],
    expectedGloss: "perfume",
  },
  {
    vietnamese: "cảm thấy",
    pieces: ["cảm", "thấy"],
    expectedGloss: "feel",
  },
  {
    vietnamese: "chóng mặt",
    pieces: ["chóng", "mặt"],
    expectedGloss: "dizzy",
  },
  {
    vietnamese: "không an toàn",
    pieces: ["không", "an toàn"],
    expectedGloss: "unsafe / not safe",
  },
  {
    vietnamese: "Cho hỏi",
    pieces: ["Cho", "hỏi"],
    expectedGloss: "excuse me / may I ask",
  },
  {
    vietnamese: "Có bán",
    pieces: ["Có", "bán"],
    expectedGloss: "do you sell",
  },
  {
    vietnamese: "đặt tour",
    pieces: ["đặt", "tour"],
    expectedGloss: "book a tour",
  },
  {
    vietnamese: "giảm giá",
    pieces: ["giảm", "giá"],
    expectedGloss: "discount / lower price",
  },
  {
    vietnamese: "Khu đón",
    pieces: ["Khu", "đón"],
    expectedGloss: "pickup area",
  },
  {
    vietnamese: "lạc đường",
    pieces: ["lạc", "đường"],
    expectedGloss: "lost",
  },
  {
    vietnamese: "nói lại",
    pieces: ["nói", "lại"],
    expectedGloss: "say again / repeat",
  },
  {
    vietnamese: "yên tĩnh",
    pieces: ["yên", "tĩnh"],
    expectedGloss: "quiet",
  },
  {
    vietnamese: "cho biết",
    pieces: ["cho", "biết"],
    expectedGloss: "says / tells",
  },
  {
    vietnamese: "có ở đây",
    pieces: ["có", "ở", "đây"],
    expectedGloss: "is here",
  },
  {
    vietnamese: "di chuyển",
    pieces: ["di", "chuyển"],
    expectedGloss: "move",
  },
  {
    vietnamese: "thị thực",
    pieces: ["thị", "thực"],
    expectedGloss: "visa",
  },
  {
    vietnamese: "đồng ý",
    pieces: ["đồng", "ý"],
    expectedGloss: "agree",
  },
  {
    vietnamese: "phát ban",
    pieces: ["phát", "ban"],
    expectedGloss: "rash",
  },
  {
    vietnamese: "giúp đỡ",
    pieces: ["giúp", "đỡ"],
    expectedGloss: "help",
  },
  {
    vietnamese: "tạm thời",
    pieces: ["tạm", "thời"],
    expectedGloss: "temporary",
  },
  {
    vietnamese: "đặt chỗ",
    pieces: ["đặt", "chỗ"],
    expectedGloss: "make a reservation",
  },
  {
    vietnamese: "một mình",
    pieces: ["một", "mình"],
    expectedGloss: "alone",
  },
  {
    vietnamese: "băng qua",
    pieces: ["băng", "qua"],
    expectedGloss: "cross",
  },
  {
    vietnamese: "mức giá",
    pieces: ["mức", "giá"],
    expectedGloss: "price",
  },
  {
    vietnamese: "đại sứ quán",
    pieces: ["đại", "sứ", "quán"],
    expectedGloss: "embassy",
  },
  {
    vietnamese: "giấy thông hành",
    pieces: ["giấy", "thông", "hành"],
    expectedGloss: "travel document",
  },
  {
    vietnamese: "trường hợp khẩn cấp",
    pieces: ["trường", "hợp", "khẩn", "cấp"],
    expectedGloss: "emergency",
  },
  {
    vietnamese: "trường hợp khẩn cấp",
    pieces: ["trường", "hợp", "khẩn cấp"],
    expectedGloss: "emergency",
  },
  {
    vietnamese: "xe cứu thương",
    pieces: ["xe", "cứu", "thương"],
    expectedGloss: "ambulance",
  },
  {
    vietnamese: "vé xe buýt",
    pieces: ["vé", "xe", "buýt"],
    expectedGloss: "bus ticket",
  },
  {
    vietnamese: "thuốc giảm đau",
    pieces: ["thuốc", "giảm", "đau"],
    expectedGloss: "pain medicine",
  },
  {
    vietnamese: "nước hoa khô",
    pieces: ["nước", "hoa", "khô"],
    expectedGloss: "solid perfume",
  },
  {
    vietnamese: "bãi gửi xe máy",
    pieces: ["bãi", "gửi", "xe", "máy"],
    expectedGloss: "motorbike parking lot",
  },
  {
    vietnamese: "thiệp bưu điện",
    pieces: ["thiệp", "bưu", "điện"],
    expectedGloss: "postcard",
  },
  {
    vietnamese: "thuốc say xe",
    pieces: ["thuốc", "say", "xe"],
    expectedGloss: "motion-sickness medicine",
  },
  {
    vietnamese: "viết xuống",
    pieces: ["viết", "xuống"],
    expectedGloss: "write down",
  },
  {
    vietnamese: "bắt đầu",
    pieces: ["bắt", "đầu"],
    expectedGloss: "start / begin",
  },
  {
    vietnamese: "thế nào",
    pieces: ["thế", "nào"],
    expectedGloss: "how",
  },
  {
    vietnamese: "khó thở",
    pieces: ["khó", "thở"],
    expectedGloss: "trouble breathing",
  },
  {
    vietnamese: "côn trùng",
    pieces: ["côn", "trùng"],
    expectedGloss: "insect / insects",
  },
  {
    vietnamese: "dừng lại",
    pieces: ["dừng", "lại"],
    expectedGloss: "stop",
  },
  {
    vietnamese: "một chiều",
    pieces: ["một", "chiều"],
    expectedGloss: "one-way",
  },
  {
    vietnamese: "chúng tôi",
    pieces: ["chúng", "tôi"],
    expectedGloss: "we / us",
  },
  {
    vietnamese: "tương tác thuốc",
    pieces: ["tương", "tác", "thuốc"],
    expectedGloss: "drug interactions",
  },
  {
    vietnamese: "căn phòng",
    pieces: ["căn", "phòng"],
    expectedGloss: "room",
  },
  {
    vietnamese: "ga trải giường",
    pieces: ["ga", "trải", "giường"],
    expectedGloss: "bed sheets",
  },
  {
    vietnamese: "danh sách chờ",
    pieces: ["danh", "sách", "chờ"],
    expectedGloss: "waiting list",
  },
  {
    vietnamese: "băng bó",
    pieces: ["băng", "bó"],
    expectedGloss: "bandages",
  },
  {
    vietnamese: "mã xác minh",
    pieces: ["mã", "xác", "minh"],
    expectedGloss: "verification code",
  },
  {
    vietnamese: "muối bù nước",
    pieces: ["muối", "bù", "nước"],
    expectedGloss: "rehydration salts",
  },
  {
    vietnamese: "điểm tập trung",
    pieces: ["điểm", "tập", "trung"],
    expectedGloss: "meeting point",
  },
  {
    vietnamese: "áp lực nước",
    pieces: ["áp", "lực", "nước"],
    expectedGloss: "water pressure",
  },
  {
    vietnamese: "thời gian lưu trú",
    pieces: ["thời", "gian", "lưu", "trú"],
    expectedGloss: "stay duration",
  },
  {
    vietnamese: "đau họng",
    pieces: ["đau", "họng"],
    expectedGloss: "sore throat",
  },
  {
    vietnamese: "đau lưng",
    pieces: ["đau", "lưng"],
    expectedGloss: "back pain",
  },
  {
    vietnamese: "đau mắt",
    pieces: ["đau", "mắt"],
    expectedGloss: "eye pain",
  },
  {
    vietnamese: "đau răng",
    pieces: ["đau", "răng"],
    expectedGloss: "toothache",
  },
  {
    vietnamese: "đau vai",
    pieces: ["đau", "vai"],
    expectedGloss: "shoulder pain",
  },
  {
    vietnamese: "đau cổ",
    pieces: ["đau", "cổ"],
    expectedGloss: "neck pain",
  },
  {
    vietnamese: "bỏng nắng",
    pieces: ["bỏng", "nắng"],
    expectedGloss: "sunburn",
  },
  {
    vietnamese: "chuột rút",
    pieces: ["chuột", "rút"],
    expectedGloss: "cramp",
  },
  {
    vietnamese: "mẩn đỏ",
    pieces: ["mẩn", "đỏ"],
    expectedGloss: "red rash",
  },
  {
    vietnamese: "cáp sạc",
    pieces: ["cáp", "sạc"],
    expectedGloss: "charging cable",
  },
  {
    vietnamese: "cáp treo",
    pieces: ["cáp", "treo"],
    expectedGloss: "cable car",
  },
  {
    vietnamese: "cố gắng",
    pieces: ["cố", "gắng"],
    expectedGloss: "try / make an effort",
  },
  {
    vietnamese: "tổng cộng",
    pieces: ["tổng", "cộng"],
    expectedGloss: "total",
  },
  {
    vietnamese: "đánh dấu",
    pieces: ["đánh", "dấu"],
    expectedGloss: "mark",
  },
  {
    vietnamese: "dời lại",
    pieces: ["dời", "lại"],
    expectedGloss: "move later / postpone",
  },
  {
    vietnamese: "đường dây",
    pieces: ["đường", "dây"],
    expectedGloss: "line",
  },
  {
    vietnamese: "mọi thứ",
    pieces: ["mọi", "thứ"],
    expectedGloss: "everything",
  },
  {
    vietnamese: "liên tục",
    pieces: ["liên", "tục"],
    expectedGloss: "continuously / keeps",
  },
  {
    vietnamese: "số tròn",
    pieces: ["số", "tròn"],
    expectedGloss: "round number",
  },
  {
    vietnamese: "bưu thiếp",
    pieces: ["bưu", "thiếp"],
    expectedGloss: "postcard",
  },
  {
    vietnamese: "Cổ vật",
    pieces: ["Cổ", "vật"],
    expectedGloss: "antiquities",
  },
  {
    vietnamese: "Cung đình",
    pieces: ["Cung", "đình"],
    expectedGloss: "royal court",
  },
  {
    vietnamese: "màn hình",
    pieces: ["màn", "hình"],
    expectedGloss: "screen",
  },
  {
    vietnamese: "giải thích",
    pieces: ["giải", "thích"],
    expectedGloss: "explain",
  },
  {
    vietnamese: "hiểu lầm",
    pieces: ["hiểu", "lầm"],
    expectedGloss: "misunderstanding",
  },
  {
    vietnamese: "nổi tiếng",
    pieces: ["nổi", "tiếng"],
    expectedGloss: "famous / popular",
  },
  {
    vietnamese: "sinh viên",
    pieces: ["sinh", "viên"],
    expectedGloss: "student",
  },
  {
    vietnamese: "dịch thuật",
    pieces: ["dịch", "thuật"],
    expectedGloss: "translation",
  },
  {
    vietnamese: "thời tiết",
    pieces: ["thời", "tiết"],
    expectedGloss: "weather",
  },
  {
    vietnamese: "lưu trú",
    pieces: ["lưu", "trú"],
    expectedGloss: "stay / lodging",
  },
  {
    vietnamese: "tương tự",
    pieces: ["tương", "tự"],
    expectedGloss: "same / similar",
  },
  {
    vietnamese: "bến thuyền",
    pieces: ["bến", "thuyền"],
    expectedGloss: "boat pier",
  },
  {
    vietnamese: "bữa trưa",
    pieces: ["bữa", "trưa"],
    expectedGloss: "lunch",
  },
  {
    vietnamese: "giường phụ",
    pieces: ["giường", "phụ"],
    expectedGloss: "extra bed",
  },
  {
    vietnamese: "chuyển khoản",
    pieces: ["chuyển", "khoản"],
    expectedGloss: "bank transfer",
  },
  {
    vietnamese: "khoản phí",
    pieces: ["khoản", "phí"],
    expectedGloss: "fee",
  },
  {
    vietnamese: "xem xét",
    pieces: ["xem", "xét"],
    expectedGloss: "look around / consider",
  },
  {
    vietnamese: "xe cấp cứu",
    pieces: ["xe", "cấp", "cứu"],
    expectedGloss: "ambulance",
  },
  {
    vietnamese: "cấp cứu",
    pieces: ["cấp", "cứu"],
    expectedGloss: "emergency aid",
  },
  {
    vietnamese: "chỉ đường",
    pieces: ["chỉ", "đường"],
    expectedGloss: "give directions",
  },
  {
    vietnamese: "chuyến tham quan",
    pieces: ["chuyến", "tham", "quan"],
    expectedGloss: "tour",
  },
  {
    vietnamese: "tham quan",
    pieces: ["tham", "quan"],
    expectedGloss: "tour / visit",
  },
  {
    vietnamese: "giặt đồ",
    pieces: ["giặt", "đồ"],
    expectedGloss: "laundry / wash clothes",
  },
  {
    vietnamese: "hải quan",
    pieces: ["hải", "quan"],
    expectedGloss: "customs",
  },
  {
    vietnamese: "hướng dẫn viên du lịch",
    pieces: ["hướng", "dẫn", "viên", "du", "lịch"],
    expectedGloss: "tour guide",
  },
  {
    vietnamese: "bàn hướng dẫn",
    pieces: ["bàn", "hướng", "dẫn"],
    expectedGloss: "information desk",
  },
  {
    vietnamese: "hướng dẫn",
    pieces: ["hướng", "dẫn"],
    expectedGloss: "instructions / guide",
  },
  {
    vietnamese: "mở khóa cửa",
    pieces: ["mở", "khóa", "cửa"],
    expectedGloss: "unlock the door",
  },
  {
    vietnamese: "khóa cửa",
    pieces: ["khóa", "cửa"],
    expectedGloss: "door lock",
  },
  {
    vietnamese: "món ăn",
    pieces: ["món", "ăn"],
    expectedGloss: "dish / food",
  },
  {
    vietnamese: "người lái xe",
    pieces: ["người", "lái", "xe"],
    expectedGloss: "driver",
  },
  {
    vietnamese: "nước tương",
    pieces: ["nước", "tương"],
    expectedGloss: "soy sauce",
  },
  {
    vietnamese: "tiếng Việt",
    pieces: ["tiếng", "Việt"],
    expectedGloss: "Vietnamese language",
  },
  {
    vietnamese: "tin nhắn văn bản",
    pieces: ["tin", "nhắn", "văn", "bản"],
    expectedGloss: "text message",
  },
  {
    vietnamese: "tin nhắn xác nhận",
    pieces: ["tin", "nhắn", "xác", "nhận"],
    expectedGloss: "confirmation message",
  },
  {
    vietnamese: "tin nhắn",
    pieces: ["tin", "nhắn"],
    expectedGloss: "message / text message",
  },
  {
    vietnamese: "vòi sen",
    pieces: ["vòi", "sen"],
    expectedGloss: "shower",
  },
  {
    vietnamese: "chính thức",
    pieces: ["chính", "thức"],
    expectedGloss: "official",
  },
  {
    vietnamese: "đóng cửa",
    pieces: ["đóng", "cửa"],
    expectedGloss: "close / closed / closing",
  },
  {
    vietnamese: "cửa hàng",
    pieces: ["cửa", "hàng"],
    expectedGloss: "store / shop",
  },
  {
    vietnamese: "cửa hàng tiện lợi",
    pieces: ["cửa", "hàng", "tiện", "lợi"],
    expectedGloss: "convenience store",
  },
  {
    vietnamese: "cửa hàng điện thoại",
    pieces: ["cửa", "hàng", "điện", "thoại"],
    expectedGloss: "phone store",
  },
  {
    vietnamese: "để tôi yên",
    pieces: ["để", "tôi", "yên"],
    expectedGloss: "leave me alone",
  },
  {
    vietnamese: "thức ăn",
    pieces: ["thức", "ăn"],
    expectedGloss: "food",
  },
  {
    vietnamese: "đóng gói",
    pieces: ["đóng", "gói"],
    expectedGloss: "pack / package",
  },
  {
    vietnamese: "cửa sổ",
    pieces: ["cửa", "sổ"],
    expectedGloss: "window",
  },
  {
    vietnamese: "cửa sổ",
    pieces: ["đóng cửa", "sổ"],
    expectedGloss: "window",
  },
  {
    vietnamese: "cửa sổ",
    pieces: ["mở cửa", "sổ"],
    expectedGloss: "window",
  },
  {
    vietnamese: "để lại",
    pieces: ["để", "lại"],
    expectedGloss: "leave",
  },
  {
    vietnamese: "đánh thức",
    pieces: ["đánh", "thức"],
    expectedGloss: "wake up",
  },
  {
    vietnamese: "đóng chai",
    pieces: ["đóng", "chai"],
    expectedGloss: "bottled / sealed in a bottle",
  },
  {
    vietnamese: "nước uống đóng chai",
    pieces: ["nước", "uống", "đóng", "chai"],
    expectedGloss: "bottled drinking water",
  },
  {
    vietnamese: "mở cửa",
    pieces: ["mở", "cửa"],
    expectedGloss: "open / opening",
  },
  {
    vietnamese: "mở cửa phòng",
    pieces: ["mở", "cửa", "phòng"],
    expectedGloss: "open the room door",
  },
  {
    vietnamese: "thứ Hai",
    pieces: ["thứ", "Hai"],
    expectedGloss: "Monday",
  },
  {
    vietnamese: "để quên",
    pieces: ["để", "quên"],
    expectedGloss: "left behind / forgot",
  },
  {
    vietnamese: "cửa ra",
    pieces: ["cửa", "ra"],
    expectedGloss: "exit",
  },
  {
    vietnamese: "vé vào cửa",
    pieces: ["vé", "vào", "cửa"],
    expectedGloss: "entrance ticket",
  },
  {
    vietnamese: "trung tâm thương mại",
    pieces: ["trung", "tâm", "thương", "mại"],
    expectedGloss: "shopping mall",
  },
  {
    vietnamese: "thuốc chống muỗi",
    pieces: ["thuốc", "chống", "muỗi"],
    expectedGloss: "mosquito repellent",
  },
  {
    vietnamese: "thuốc sát trùng",
    pieces: ["thuốc", "sát", "trùng"],
    expectedGloss: "antiseptic",
  },
  {
    vietnamese: "phí dịch vụ",
    pieces: ["phí", "dịch", "vụ"],
    expectedGloss: "service charge",
  },
  {
    vietnamese: "Tỷ giá hối đoái",
    pieces: ["Tỷ", "giá", "hối đoái"],
    expectedGloss: "exchange rate",
  },
  {
    vietnamese: "bến tàu",
    pieces: ["bến", "tàu"],
    expectedGloss: "boat pier / station",
  },
  {
    vietnamese: "bến xe",
    pieces: ["bến", "xe"],
    expectedGloss: "bus station",
  },
  {
    vietnamese: "bộ sạc",
    pieces: ["bộ", "sạc"],
    expectedGloss: "charger",
  },
  {
    vietnamese: "buổi chiều",
    pieces: ["buổi", "chiều"],
    expectedGloss: "afternoon",
  },
  {
    vietnamese: "buổi sáng",
    pieces: ["buổi", "sáng"],
    expectedGloss: "morning",
  },
  {
    vietnamese: "đau bụng",
    pieces: ["đau", "bụng"],
    expectedGloss: "stomachache",
  },
  {
    vietnamese: "đổi size",
    pieces: ["đổi", "size"],
    expectedGloss: "change size",
  },
  {
    vietnamese: "đổi tiền",
    pieces: ["đổi", "tiền"],
    expectedGloss: "exchange money",
  },
  {
    vietnamese: "giá tốt",
    pieces: ["giá", "tốt"],
    expectedGloss: "good price",
  },
  {
    vietnamese: "lên xe",
    pieces: ["lên", "xe"],
    expectedGloss: "get in / board the vehicle",
  },
  {
    vietnamese: "mang đi",
    pieces: ["mang", "đi"],
    expectedGloss: "to go / take away",
  },
  {
    vietnamese: "ngày mai",
    pieces: ["ngày", "mai"],
    expectedGloss: "tomorrow",
  },
  {
    vietnamese: "nói chậm",
    pieces: ["nói", "chậm"],
    expectedGloss: "speak slowly",
  },
  {
    vietnamese: "rút tiền",
    pieces: ["rút", "tiền"],
    expectedGloss: "withdraw cash",
  },
  {
    vietnamese: "siêu thị",
    pieces: ["siêu", "thị"],
    expectedGloss: "supermarket",
  },
  {
    vietnamese: "thử đồ",
    pieces: ["thử", "đồ"],
    expectedGloss: "try on clothes",
  },
  {
    vietnamese: "xuống xe",
    pieces: ["xuống", "xe"],
    expectedGloss: "get off the vehicle",
  },
];

function normalizeDisplayText(text) {
  return String(text ?? "")
    .normalize("NFC")
    .trim()
    .replace(/\s+/g, " ");
}

function normalizeComparisonText(text) {
  return normalizeDisplayText(text).toLocaleLowerCase("vi");
}

function normalizeSequencePieceText(text) {
  return normalizeComparisonText(text).replace(/[?!.,;:]+$/g, "").trim();
}

function normalizeSelfGlossText(text) {
  return normalizeSequencePieceText(text);
}

function normalizeVietnameseKey(text) {
  return normalizeComparisonText(text)
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/[^\p{L}\p{N}/?]+/gu, " ")
    .trim()
    .replace(/\s+/g, " ");
}

function wordCount(text) {
  return normalizeDisplayText(text).split(/\s+/).filter(Boolean).length;
}

function isPlaceholderGloss(gloss) {
  const normalized = normalizeDisplayText(gloss).toLocaleLowerCase("vi");
  if (PLACEHOLDER_GLOSSES.has(normalized)) {
    return true;
  }

  return /\bword\b/.test(normalized)
    && !/^this word$/.test(normalized)
    && !/^the word$/.test(normalized)
    && !/^word by word$/.test(normalized);
}

function walkJSONFiles(dir) {
  if (!fs.existsSync(dir)) return [];
  const files = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...walkJSONFiles(fullPath));
    } else if (entry.isFile() && entry.name.endsWith(".json") && !entry.name.startsWith("_")) {
      files.push(fullPath);
    }
  }
  return files.sort((a, b) => a.localeCompare(b));
}

function loadBreakdownAuditLedger({ repoRoot, ledgerRoot } = {}) {
  if (!repoRoot && !ledgerRoot) {
    throw new Error("loadBreakdownAuditLedger requires repoRoot or ledgerRoot");
  }

  const resolvedLedgerRoot = ledgerRoot ?? path.join(repoRoot, DEFAULT_LEDGER_RELATIVE_ROOT);
  const entries = [];
  const entriesByPageID = new Map();
  const errors = [];

  for (const filePath of walkJSONFiles(resolvedLedgerRoot)) {
    let entry;
    try {
      entry = JSON.parse(fs.readFileSync(filePath, "utf8"));
    } catch (error) {
      errors.push(`${filePath}: invalid JSON: ${error.message}`);
      continue;
    }

    const pageID = normalizeDisplayText(entry.pageID);
    if (!pageID) {
      errors.push(`${filePath}: missing pageID`);
      continue;
    }
    if (entriesByPageID.has(pageID)) {
      errors.push(`${filePath}: duplicate pageID ${pageID}`);
      continue;
    }

    const normalizedEntry = {
      ...entry,
      pageID,
      __filePath: filePath,
    };
    entries.push(normalizedEntry);
    entriesByPageID.set(pageID, normalizedEntry);
  }

  return {
    ledgerRoot: resolvedLedgerRoot,
    entries,
    entriesByPageID,
    errors,
  };
}

function phraseTextForPage(page) {
  return normalizeDisplayText(page?.title ?? page?.phraseText ?? page?.vietnamese);
}

function breakdownSectionsForPage(page) {
  return (page.sections ?? []).filter((section) => (section.breakdown ?? []).length > 0 || section.id === "breakdown");
}

function appFacingTokenID(pageID, token, index, isFinal) {
  if (token.id) return normalizeDisplayText(token.id);
  return isFinal ? `${pageID}-breakdown-full` : `${pageID}-breakdown-piece-${index + 1}`;
}

function appFacingTokenEnglish(vietnamese, english) {
  const cleanVietnamese = normalizeDisplayText(vietnamese);
  const cleanEnglish = normalizeDisplayText(english);
  if (cleanVietnamese === "tôi" && cleanEnglish.toLocaleLowerCase("vi") === "me") {
    return "I / me";
  }
  return cleanEnglish;
}

function appFacingBreakdownTokens(entry, audioKeyForToken) {
  const tokens = Array.isArray(entry.tokens) ? entry.tokens : [];
  return tokens.map((token, index) => {
    const isFinal = index === tokens.length - 1;
    const vietnamese = normalizeDisplayText(token.vietnamese);
    const english = appFacingTokenEnglish(vietnamese, token.english);
    const audioKey = Object.prototype.hasOwnProperty.call(token, "audioKey")
      ? token.audioKey
      : (audioKeyForToken ? audioKeyForToken(vietnamese, { isFinal, token, index }) : null);

    return {
      id: appFacingTokenID(entry.pageID, token, index, isFinal),
      vietnamese,
      english,
      audioKey,
    };
  });
}

function reviewFacingBreakdownTokens(entry) {
  const tokens = Array.isArray(entry.tokens) ? entry.tokens : [];
  return tokens.map((token, index) => {
    const isFinal = index === tokens.length - 1;
    const keepTogetherReason = normalizeDisplayText(token.keepTogetherReason);
    const exportedToken = {
      id: appFacingTokenID(entry.pageID, token, index, isFinal),
      vietnamese: normalizeDisplayText(token.vietnamese),
      english: normalizeDisplayText(token.english),
      audioKey: Object.prototype.hasOwnProperty.call(token, "audioKey") ? token.audioKey : null,
    };

    if (keepTogetherReason) {
      exportedToken.keepTogetherReason = keepTogetherReason;
    }

    return exportedToken;
  });
}

function applyReviewedBreakdownOverride({ page, existingBreakdown, ledger, audioKeyForToken }) {
  const entry = ledger?.entriesByPageID?.get(page.id);
  if (!entry || entry.reviewStatus !== "reviewed") {
    return existingBreakdown ?? [];
  }

  return appFacingBreakdownTokens(entry, audioKeyForToken);
}

function validateEntryAgainstPage(entry, page, { requireReviewed }) {
  const errors = [];
  const pageLabel = entry.pageID || "(missing pageID)";
  const phraseText = page ? phraseTextForPage(page) : normalizeDisplayText(entry.phraseText);

  if (requireReviewed && entry.reviewStatus !== "reviewed") {
    errors.push(`${pageLabel}: reviewStatus must be reviewed`);
  }
  if (requireReviewed && entry.visualReview?.status !== "reviewed") {
    errors.push(`${pageLabel}: visualReview.status must be reviewed`);
  }
  if (!Array.isArray(entry.tokens) || entry.tokens.length === 0) {
    errors.push(`${pageLabel}: tokens must be a non-empty array`);
    return errors;
  }

  const entryPhraseText = normalizeDisplayText(entry.phraseText);
  if (page && entryPhraseText && normalizeComparisonText(entryPhraseText) !== normalizeComparisonText(phraseText)) {
    errors.push(`${pageLabel}: phraseText does not match page title`);
  }

  const tokens = entry.tokens.map((token) => ({
    vietnamese: normalizeDisplayText(token.vietnamese),
    english: normalizeDisplayText(token.english),
    keepTogetherReason: normalizeDisplayText(token.keepTogetherReason),
  }));

  for (const [index, token] of tokens.entries()) {
    const tokenLabel = `${pageLabel}: token ${index + 1}`;
    if (!token.vietnamese) errors.push(`${tokenLabel} missing vietnamese`);
    if (!token.english) errors.push(`${tokenLabel} missing english`);

    const lowerGloss = token.english.toLocaleLowerCase("vi");
    const isFinal = index === tokens.length - 1;
    if (!isFinal && isPlaceholderGloss(token.english)) {
      errors.push(`${tokenLabel} uses placeholder gloss "${token.english}"`);
    }

    const vietnameseSelfGlossKey = normalizeSelfGlossText(token.vietnamese);
    const englishSelfGlossKey = normalizeSelfGlossText(token.english);
    if (
      !isFinal
      && vietnameseSelfGlossKey
      && vietnameseSelfGlossKey === englishSelfGlossKey
      && !ALLOWED_SELF_GLOSS_TOKENS.has(vietnameseSelfGlossKey)
    ) {
      errors.push(`${tokenLabel} uses untranslated self-gloss "${token.vietnamese} = ${token.english}"`);
    }

    const malformedKey = `${normalizeVietnameseKey(token.vietnamese)} = ${lowerGloss}`;
    if (MALFORMED_LEGACY_CHUNKS.has(malformedKey)) {
      errors.push(`${tokenLabel} keeps malformed legacy chunk ${token.vietnamese} = ${token.english}`);
    }

    if (!isFinal && wordCount(token.vietnamese) > 1 && !token.keepTogetherReason) {
      errors.push(`${tokenLabel} is multi-word and needs keepTogetherReason`);
    }
    if (!isFinal && String(token.keepTogetherReason ?? "").trim().toLowerCase() === "proper name") {
      errors.push(`${tokenLabel} has generic keepTogetherReason`);
    }
  }

  const nonFinalTokens = tokens.slice(0, -1);
  for (const sequence of FORBIDDEN_SPLIT_SEQUENCES) {
    const normalizedPieces = sequence.pieces.map(normalizeSequencePieceText);
    for (let index = 0; index <= nonFinalTokens.length - normalizedPieces.length; index += 1) {
      const matches = normalizedPieces.every(
        (piece, offset) => normalizeSequencePieceText(nonFinalTokens[index + offset].vietnamese) === piece,
      );
      if (matches) {
        errors.push(
          `${pageLabel}: tokens ${index + 1}-${index + normalizedPieces.length} split ${sequence.vietnamese}; keep together as ${sequence.expectedGloss}`,
        );
      }
    }
  }

  const finalToken = tokens[tokens.length - 1];
  if (phraseText && normalizeComparisonText(finalToken.vietnamese) !== normalizeComparisonText(phraseText)) {
    errors.push(`${pageLabel}: final token must be the complete phrase`);
  }

  const reconstructed = tokens.length === 1
    ? tokens[0].vietnamese
    : tokens.slice(0, -1).map((token) => token.vietnamese).join(" ");
  if (phraseText && normalizeComparisonText(reconstructed) !== normalizeComparisonText(phraseText)) {
    errors.push(`${pageLabel}: non-final tokens do not reconstruct phrase`);
  }

  return errors;
}

function validateBreakdownAuditCoverage({ pages, ledger, requireAllReviewed = false } = {}) {
  const errors = [...(ledger?.errors ?? [])];
  const warnings = [];
  const pagesWithBreakdown = (pages ?? []).filter((page) => breakdownSectionsForPage(page).length > 0);
  const pagesByID = new Map((pages ?? []).map((page) => [page.id, page]));
  const reviewedPageIDs = [];

  for (const entry of ledger?.entries ?? []) {
    const page = pagesByID.get(entry.pageID);
    if (!page) {
      errors.push(`${entry.pageID}: ledger entry has no matching runtime page`);
      continue;
    }
    errors.push(...validateEntryAgainstPage(entry, page, { requireReviewed: requireAllReviewed }));
    if (entry.reviewStatus === "reviewed") {
      reviewedPageIDs.push(entry.pageID);
    }
  }

  if (requireAllReviewed) {
    for (const page of pagesWithBreakdown) {
      const entry = ledger?.entriesByPageID?.get(page.id);
      if (!entry) {
        errors.push(`${page.id} missing reviewed ledger entry`);
      } else if (entry.reviewStatus !== "reviewed") {
        errors.push(`${page.id}: ledger entry is not reviewed`);
      }
    }
  }

  return {
    ok: errors.length === 0,
    errors,
    warnings,
    counts: {
      runtimePages: pages?.length ?? 0,
      pagesWithBreakdown: pagesWithBreakdown.length,
      ledgerEntries: ledger?.entries?.length ?? 0,
      reviewedEntries: reviewedPageIDs.length,
      missingReviewedEntries: requireAllReviewed
        ? Math.max(0, pagesWithBreakdown.length - reviewedPageIDs.length)
        : null,
    },
  };
}

function renderBreakdownAuditExport({ pages, ledger }) {
  const generatedAt = new Date().toISOString();
  const renderedPages = (pages ?? []).map((page) => {
    const entry = ledger?.entriesByPageID?.get(page.id);
    const sections = breakdownSectionsForPage(page);
    const runtimeBreakdown = sections.flatMap((section) => section.breakdown ?? []);
    const reviewedBreakdown = entry?.reviewStatus === "reviewed"
      ? reviewFacingBreakdownTokens(entry)
      : null;

    return {
      pageID: page.id,
      phraseText: phraseTextForPage(page),
      englishTitle: page.englishTitle ?? "",
      reviewStatus: entry?.reviewStatus ?? "missing",
      visualReview: entry?.visualReview ?? { status: "missing" },
      notes: entry?.notes ?? entry?.reviewNotes ?? [],
      runtimeBreakdown,
      reviewedBreakdown,
    };
  });

  return {
    generatedAt,
    ledgerRoot: ledger?.ledgerRoot ?? null,
    summary: {
      pages: renderedPages.length,
      reviewed: renderedPages.filter((page) => page.reviewStatus === "reviewed").length,
      visualReviewed: renderedPages.filter((page) => page.visualReview?.status === "reviewed").length,
      missing: renderedPages.filter((page) => page.reviewStatus === "missing").length,
      generatedAt,
    },
    pages: renderedPages,
  };
}

module.exports = {
  DEFAULT_AUDIT_RELATIVE_ROOT,
  DEFAULT_LEDGER_RELATIVE_ROOT,
  applyReviewedBreakdownOverride,
  loadBreakdownAuditLedger,
  normalizeDisplayText,
  normalizeVietnameseKey,
  renderBreakdownAuditExport,
  validateBreakdownAuditCoverage,
};
