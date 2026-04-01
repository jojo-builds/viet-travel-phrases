import { Scenario } from '../types';

export const coffeeShopScenario: Scenario = {
  "id": "coffee-shop",
  "name": "Coffee Shop",
  "emoji": "☕",
  "description": "Order coffee the local way",
  "tip": "Vietnamese coffee is usually sweet and strong. Check whether your drink comes with condensed milk and lots of ice before ordering a second one.",
  "phrases": [
    {
      "id": "coffee-1",
      "scenarioId": "coffee-shop",
      "vietnamese": "Cho tôi một cà phê sữa đá",
      "romanized": "cho toy moht kah-FEH soo-ah DAH",
      "english": "One iced milk coffee please",
      "audioKey": "coffee-1",
      "context": "Use this at almost any café when you want the classic Vietnamese coffee order.",
      "emoji": "☕"
    },
    {
      "id": "coffee-2",
      "scenarioId": "coffee-shop",
      "vietnamese": "Cho tôi cà phê đen đá",
      "romanized": "cho toy kah-FEH den DAH",
      "english": "I’d like an iced black coffee",
      "audioKey": "coffee-2",
      "context": "Say this when you want coffee without milk at a café or coffee cart.",
      "emoji": "🧊"
    },
    {
      "id": "coffee-3",
      "scenarioId": "coffee-shop",
      "vietnamese": "Cho tôi bạc xỉu đá",
      "romanized": "cho toy bahk SIU DAH",
      "english": "I’d like an iced bạc xỉu",
      "audioKey": "coffee-3",
      "context": "Use this if you want a sweeter, milkier coffee drink popular in the south.",
      "emoji": "🥛"
    },
    {
      "id": "coffee-4",
      "scenarioId": "coffee-shop",
      "vietnamese": "Ít đá thôi",
      "romanized": "eet DAH toy",
      "english": "Just a little ice",
      "audioKey": "coffee-4",
      "context": "Add this when you want your drink less watered down in the heat.",
      "emoji": "🧊"
    },
    {
      "id": "coffee-5",
      "scenarioId": "coffee-shop",
      "vietnamese": "Không đường nhé",
      "romanized": "khong doong NYEH",
      "english": "No sugar please",
      "audioKey": "coffee-5",
      "context": "Use this to make your drink less sweet when ordering coffee or tea.",
      "emoji": "🚫"
    },
    {
      "id": "coffee-6",
      "scenarioId": "coffee-shop",
      "vietnamese": "Mang đi",
      "romanized": "mang dee",
      "english": "To go",
      "audioKey": "coffee-6",
      "context": "Say this when you want takeaway instead of sitting down.",
      "emoji": "🥤"
    },
    {
      "id": "coffee-7",
      "scenarioId": "coffee-shop",
      "vietnamese": "Tính tiền giúp tôi",
      "romanized": "teen tee-en zoop toy",
      "english": "Please let me pay",
      "audioKey": "coffee-7",
      "context": "Use this when you are done and want the bill at a café.",
      "emoji": "💵"
    }
  ]
};
