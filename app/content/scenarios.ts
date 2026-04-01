import { Phrase, Scenario } from './types';
import { coffeeShopScenario } from './scenarioData/coffee-shop';
import { streetFoodScenario } from './scenarioData/street-food';
import { grabTaxiScenario } from './scenarioData/grab-taxi';
import { askingPriceScenario } from './scenarioData/asking-price';
import { politeBasicsScenario } from './scenarioData/polite-basics';
import { convenienceStoreScenario } from './scenarioData/convenience-store';
import { hotelHostelScenario } from './scenarioData/hotel-hostel';
import { directionsScenario } from './scenarioData/directions';
import { simpleProblemsScenario } from './scenarioData/simple-problems';
import { smallTalkScenario } from './scenarioData/small-talk';

export const scenarios: Scenario[] = [
  coffeeShopScenario,
  streetFoodScenario,
  grabTaxiScenario,
  askingPriceScenario,
  politeBasicsScenario,
  convenienceStoreScenario,
  hotelHostelScenario,
  directionsScenario,
  simpleProblemsScenario,
  smallTalkScenario,
];

export const phrases = scenarios.flatMap((scenario) => scenario.phrases);

export const scenarioMap = Object.fromEntries(
  scenarios.map((scenario) => [scenario.id, scenario]),
) as Record<string, Scenario>;

export const phraseMap = Object.fromEntries(
  phrases.map((phrase) => [phrase.id, phrase]),
) as Record<string, Phrase>;

export const quickPhrases = idsToPhrases(["polite-1","polite-2","polite-5","price-1","polite-4"]);

function idsToPhrases(ids: string[]): Phrase[] {
  return ids.map((id) => phraseMap[id]).filter(Boolean);
}
