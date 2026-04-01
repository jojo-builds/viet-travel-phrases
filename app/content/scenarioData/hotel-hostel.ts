import { Scenario } from '../types';

export const hotelHostelScenario: Scenario = {
  "id": "hotel-hostel",
  "name": "Hotel / Hostel",
  "emoji": "🏨",
  "description": "Handle check-in and room needs",
  "tip": "Keep your passport ready at check-in. Most places need to register guests with local authorities.",
  "phrases": [
    {
      "id": "hotel-1",
      "scenarioId": "hotel-hostel",
      "vietnamese": "Tôi có đặt phòng",
      "romanized": "toy koh daht fong",
      "english": "I have a reservation",
      "audioKey": "hotel-1",
      "context": "Use this first at reception when you arrive to check in.",
      "emoji": "🛎️"
    },
    {
      "id": "hotel-2",
      "scenarioId": "hotel-hostel",
      "vietnamese": "Cho tôi nhận phòng",
      "romanized": "cho toy nyun fong",
      "english": "I’d like to check in",
      "audioKey": "hotel-2",
      "context": "Say this when you are ready to begin the check-in process.",
      "emoji": "🔑"
    },
    {
      "id": "hotel-3",
      "scenarioId": "hotel-hostel",
      "vietnamese": "Mấy giờ trả phòng?",
      "romanized": "may zuh cha fong",
      "english": "What time is check-out?",
      "audioKey": "hotel-3",
      "context": "Ask this early so you know the departure deadline.",
      "emoji": "⏰"
    },
    {
      "id": "hotel-4",
      "scenarioId": "hotel-hostel",
      "vietnamese": "Phòng này có nóng quá",
      "romanized": "fong NAI koh nong gwah",
      "english": "This room is too hot",
      "audioKey": "hotel-4",
      "context": "Use this if the room cooling is not working well.",
      "emoji": "🥵"
    },
    {
      "id": "hotel-5",
      "scenarioId": "hotel-hostel",
      "vietnamese": "Máy lạnh không chạy",
      "romanized": "my lahn khong chai",
      "english": "The air conditioner isn’t working",
      "audioKey": "hotel-5",
      "context": "Say this when you need staff to fix or check the AC.",
      "emoji": "❄️"
    },
    {
      "id": "hotel-6",
      "scenarioId": "hotel-hostel",
      "vietnamese": "Cho tôi thêm khăn",
      "romanized": "cho toy them khan",
      "english": "More towels please",
      "audioKey": "hotel-6",
      "context": "Use this when you need extra towels brought to your room.",
      "emoji": "🧺"
    },
    {
      "id": "hotel-7",
      "scenarioId": "hotel-hostel",
      "vietnamese": "Giữ hành lý giúp tôi",
      "romanized": "zoo han-lee zoop toy",
      "english": "Please hold my luggage",
      "audioKey": "hotel-7",
      "context": "Use this if you arrive early or leave after check-out.",
      "emoji": "🧳"
    }
  ]
};
