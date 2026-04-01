import { Scenario } from '../types';

export const streetFoodScenario: Scenario = {
  "id": "street-food",
  "name": "Street Food / Restaurant",
  "emoji": "🍜",
  "description": "Order fast and eat well",
  "tip": "Busy stalls with high turnover are usually the safest bet, and cash in small notes speeds things up.",
  "phrases": [
    {
      "id": "food-1",
      "scenarioId": "street-food",
      "vietnamese": "Cho tôi một phần",
      "romanized": "cho toy moht fuhn",
      "english": "One portion please",
      "audioKey": "food-1",
      "context": "Use this for simple food orders when pointing at what you want.",
      "emoji": "🍽️"
    },
    {
      "id": "food-2",
      "scenarioId": "street-food",
      "vietnamese": "Cho tôi tô này",
      "romanized": "cho toy toh NAI",
      "english": "I’ll take this bowl",
      "audioKey": "food-2",
      "context": "Say this while pointing when choosing from prepared noodle dishes.",
      "emoji": "🍜"
    },
    {
      "id": "food-3",
      "scenarioId": "street-food",
      "vietnamese": "Không cay nhé",
      "romanized": "khong kai NYEH",
      "english": "Not spicy please",
      "audioKey": "food-3",
      "context": "Use this before the dish is made if you do not want chili added.",
      "emoji": "🌶️"
    },
    {
      "id": "food-4",
      "scenarioId": "street-food",
      "vietnamese": "Cho thêm rau",
      "romanized": "cho them rau",
      "english": "More herbs please",
      "audioKey": "food-4",
      "context": "Use this at noodle stalls or bánh mì shops when you want extra greens.",
      "emoji": "🥬"
    },
    {
      "id": "food-5",
      "scenarioId": "street-food",
      "vietnamese": "Có nước suối không?",
      "romanized": "koh nook soo-ee khong",
      "english": "Do you have bottled water?",
      "audioKey": "food-5",
      "context": "Ask this when you want plain bottled water with your meal.",
      "emoji": "💧"
    },
    {
      "id": "food-6",
      "scenarioId": "street-food",
      "vietnamese": "Cho tôi muỗng với đũa",
      "romanized": "cho toy moo-ung voy doo-ah",
      "english": "A spoon and chopsticks please",
      "audioKey": "food-6",
      "context": "Use this if utensils were not set out or you need an extra pair.",
      "emoji": "🥢"
    },
    {
      "id": "food-7",
      "scenarioId": "street-food",
      "vietnamese": "Gói mang về",
      "romanized": "goy mang veh",
      "english": "Pack it to go",
      "audioKey": "food-7",
      "context": "Say this when you want takeaway from a restaurant or street stall.",
      "emoji": "🛍️"
    }
  ]
};
