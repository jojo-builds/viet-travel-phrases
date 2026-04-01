import { Scenario } from '../types';

export const convenienceStoreScenario: Scenario = {
  "id": "convenience-store",
  "name": "Convenience Store",
  "emoji": "🏪",
  "description": "Handle quick shop stops",
  "tip": "Many convenience stores have seating upstairs or outside, but some charge separately for heated food or add-on items.",
  "phrases": [
    {
      "id": "store-1",
      "scenarioId": "convenience-store",
      "vietnamese": "Cho tôi chai nước",
      "romanized": "cho toy chai nook",
      "english": "A bottle of water please",
      "audioKey": "store-1",
      "context": "Use this for the most common quick purchase in a mini-mart.",
      "emoji": "💧"
    },
    {
      "id": "store-2",
      "scenarioId": "convenience-store",
      "vietnamese": "Có túi không?",
      "romanized": "koh too-ee khong",
      "english": "Do you have a bag?",
      "audioKey": "store-2",
      "context": "Ask this if you are buying several items and need a carry bag.",
      "emoji": "🛍️"
    },
    {
      "id": "store-3",
      "scenarioId": "convenience-store",
      "vietnamese": "Cho tôi khăn giấy",
      "romanized": "cho toy khan zai",
      "english": "Tissues please",
      "audioKey": "store-3",
      "context": "Use this when you need tissues, wipes, or napkins at the counter.",
      "emoji": "🧻"
    },
    {
      "id": "store-4",
      "scenarioId": "convenience-store",
      "vietnamese": "Ở đâu có kem chống nắng?",
      "romanized": "uh dow koh kem chong nahng",
      "english": "Where is the sunscreen?",
      "audioKey": "store-4",
      "context": "Ask this when you need help finding sunscreen in a larger convenience store.",
      "emoji": "🧴"
    },
    {
      "id": "store-5",
      "scenarioId": "convenience-store",
      "vietnamese": "Mở cái này giúp tôi",
      "romanized": "muh gai NAI zoop toy",
      "english": "Please open this for me",
      "audioKey": "store-5",
      "context": "Use this for bottled drinks or packaged items that are hard to open.",
      "emoji": "🔓"
    },
    {
      "id": "store-6",
      "scenarioId": "convenience-store",
      "vietnamese": "Tôi quẹt thẻ được không?",
      "romanized": "toy kweht teh dook khong",
      "english": "Can I pay by card?",
      "audioKey": "store-6",
      "context": "Ask this before checkout if you are not carrying enough cash.",
      "emoji": "💳"
    },
    {
      "id": "store-7",
      "scenarioId": "convenience-store",
      "vietnamese": "Cho tôi hóa đơn",
      "romanized": "cho toy hwah dun",
      "english": "Please give me the receipt",
      "audioKey": "store-7",
      "context": "Use this if you need the receipt for tracking spending or reimbursement.",
      "emoji": "🧾"
    }
  ]
};
