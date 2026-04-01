import { Scenario } from '../types';

export const askingPriceScenario: Scenario = {
  "id": "asking-price",
  "name": "Asking the Price",
  "emoji": "💸",
  "description": "Check prices before you buy",
  "tip": "At markets, ask the price before agreeing and keep smaller bills ready so change is easy.",
  "phrases": [
    {
      "id": "price-1",
      "scenarioId": "asking-price",
      "vietnamese": "Cái này bao nhiêu?",
      "romanized": "gai NAI bao nyew",
      "english": "How much is this?",
      "audioKey": "price-1",
      "context": "Use this while pointing at an item in a market, shop, or food stall.",
      "emoji": "🏷️"
    },
    {
      "id": "price-2",
      "scenarioId": "asking-price",
      "vietnamese": "Bao nhiêu một ký?",
      "romanized": "bao nyew moht kee",
      "english": "How much per kilo?",
      "audioKey": "price-2",
      "context": "Use this when buying fruit, snacks, or other goods sold by weight.",
      "emoji": "⚖️"
    },
    {
      "id": "price-3",
      "scenarioId": "asking-price",
      "vietnamese": "Mắc quá",
      "romanized": "mahk gwah",
      "english": "Too expensive",
      "audioKey": "price-3",
      "context": "Say this lightly when bargaining or reacting to a high quoted price.",
      "emoji": "😅"
    },
    {
      "id": "price-4",
      "scenarioId": "asking-price",
      "vietnamese": "Bớt chút được không?",
      "romanized": "buht choot dook khong",
      "english": "Can you lower it a little?",
      "audioKey": "price-4",
      "context": "Use this politely in markets where bargaining is normal.",
      "emoji": "🤝"
    },
    {
      "id": "price-5",
      "scenarioId": "asking-price",
      "vietnamese": "Giá cuối bao nhiêu?",
      "romanized": "yah kooy bao nyew",
      "english": "What’s your final price?",
      "audioKey": "price-5",
      "context": "Ask this when you want the seller’s best price before deciding.",
      "emoji": "💬"
    },
    {
      "id": "price-6",
      "scenarioId": "asking-price",
      "vietnamese": "Cho tôi xem cái khác",
      "romanized": "cho toy sem gai khahk",
      "english": "Show me another one",
      "audioKey": "price-6",
      "context": "Use this when you want to compare options instead of buying immediately.",
      "emoji": "👀"
    },
    {
      "id": "price-7",
      "scenarioId": "asking-price",
      "vietnamese": "Tôi lấy cái này",
      "romanized": "toy lay gai NAI",
      "english": "I’ll take this one",
      "audioKey": "price-7",
      "context": "Say this once you agree on the item and price.",
      "emoji": "🛍️"
    }
  ]
};
