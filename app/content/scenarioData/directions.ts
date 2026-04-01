import { Scenario } from '../types';

export const directionsScenario: Scenario = {
  "id": "directions",
  "name": "Directions",
  "emoji": "🗺️",
  "description": "Find your way around town",
  "tip": "Save your hotel name and address in Vietnamese on your phone in case maps or data fail.",
  "phrases": [
    {
      "id": "directions-1",
      "scenarioId": "directions",
      "vietnamese": "Cho hỏi đi chợ Bến Thành",
      "romanized": "cho hoy dee chuh benh TANH",
      "english": "Excuse me, how do I get to Bến Thành Market?",
      "audioKey": "directions-1",
      "context": "Use this when asking for a route to a famous place or landmark.",
      "emoji": "🗺️"
    },
    {
      "id": "directions-2",
      "scenarioId": "directions",
      "vietnamese": "Ở gần đây không?",
      "romanized": "uh guhn DAI khong",
      "english": "Is it near here?",
      "audioKey": "directions-2",
      "context": "Ask this when deciding whether to walk or call a ride.",
      "emoji": "📍"
    },
    {
      "id": "directions-3",
      "scenarioId": "directions",
      "vietnamese": "Đi bộ bao lâu?",
      "romanized": "dee boh bao low",
      "english": "How long on foot?",
      "audioKey": "directions-3",
      "context": "Use this to check whether walking is realistic in the heat or rain.",
      "emoji": "🚶"
    },
    {
      "id": "directions-4",
      "scenarioId": "directions",
      "vietnamese": "Rẽ trái ở đâu?",
      "romanized": "reh chai uh dow",
      "english": "Where do I turn left?",
      "audioKey": "directions-4",
      "context": "Ask this when someone is giving you step-by-step directions.",
      "emoji": "⬅️"
    },
    {
      "id": "directions-5",
      "scenarioId": "directions",
      "vietnamese": "Rẽ phải phải không?",
      "romanized": "reh fai fai khong",
      "english": "Turn right, correct?",
      "audioKey": "directions-5",
      "context": "Use this to confirm you understood the next turn correctly.",
      "emoji": "➡️"
    },
    {
      "id": "directions-6",
      "scenarioId": "directions",
      "vietnamese": "Đi thẳng hả?",
      "romanized": "dee thang hah",
      "english": "Go straight?",
      "audioKey": "directions-6",
      "context": "Ask this to confirm you should keep going forward.",
      "emoji": "⬆️"
    },
    {
      "id": "directions-7",
      "scenarioId": "directions",
      "vietnamese": "Cảm ơn, tôi hiểu rồi",
      "romanized": "kahm UHN, toy hee-u roy",
      "english": "Thanks, I understand now",
      "audioKey": "directions-7",
      "context": "Use this to politely end the exchange after getting directions.",
      "emoji": "🙏"
    }
  ]
};
