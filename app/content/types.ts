export type Phrase = {
  id: string;
  scenarioId: string;
  vietnamese: string;
  romanized: string;
  english: string;
  audioKey: string;
  context?: string;
  emoji?: string;
};

export type Scenario = {
  id: string;
  name: string;
  emoji: string;
  description: string;
  tip: string;
  phrases: Phrase[];
};
