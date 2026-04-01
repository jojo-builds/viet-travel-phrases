import { Scenario } from '../types';

export const grabTaxiScenario: Scenario = {
  "id": "grab-taxi",
  "name": "Grab / Taxi",
  "emoji": "🚕",
  "description": "Get around without confusion",
  "tip": "For city rides, Grab usually avoids fare arguments. Always check the license plate before getting in.",
  "phrases": [
    {
      "id": "taxi-1",
      "scenarioId": "grab-taxi",
      "vietnamese": "Cho tôi tới đây",
      "romanized": "cho toy tuy DAI",
      "english": "Take me here",
      "audioKey": "taxi-1",
      "context": "Use this while showing your destination on your phone to the driver.",
      "emoji": "📍"
    },
    {
      "id": "taxi-2",
      "scenarioId": "grab-taxi",
      "vietnamese": "Đi quận Một",
      "romanized": "dee gwen moht",
      "english": "Go to District 1",
      "audioKey": "taxi-2",
      "context": "Say this for a simple district destination when the place is already understood.",
      "emoji": "🏙️"
    },
    {
      "id": "taxi-3",
      "scenarioId": "grab-taxi",
      "vietnamese": "Dừng ở đây được rồi",
      "romanized": "zoong uh DAI dook roy",
      "english": "You can stop here",
      "audioKey": "taxi-3",
      "context": "Use this when you want the driver to let you out at the current spot.",
      "emoji": "🛑"
    },
    {
      "id": "taxi-4",
      "scenarioId": "grab-taxi",
      "vietnamese": "Đi đường này đi",
      "romanized": "dee doong NAI dee",
      "english": "Go this way",
      "audioKey": "taxi-4",
      "context": "Say this if you know a better route and need to guide the driver.",
      "emoji": "➡️"
    },
    {
      "id": "taxi-5",
      "scenarioId": "grab-taxi",
      "vietnamese": "Mở máy lạnh giúp tôi",
      "romanized": "muh my lahn zoop toy",
      "english": "Please turn on the air conditioning",
      "audioKey": "taxi-5",
      "context": "Use this on a hot ride when the car air conditioning is off.",
      "emoji": "❄️"
    },
    {
      "id": "taxi-6",
      "scenarioId": "grab-taxi",
      "vietnamese": "Chờ tôi năm phút",
      "romanized": "choy toy nahm foot",
      "english": "Wait for me five minutes",
      "audioKey": "taxi-6",
      "context": "Use this if you need a very short stop and the driver agrees to wait.",
      "emoji": "⏳"
    },
    {
      "id": "taxi-7",
      "scenarioId": "grab-taxi",
      "vietnamese": "Tôi trả bằng tiền mặt",
      "romanized": "toy cha bang tee-en maht",
      "english": "I’ll pay cash",
      "audioKey": "taxi-7",
      "context": "Say this if payment method needs to be clear before the ride ends.",
      "emoji": "💵"
    }
  ]
};
