import Ionicons from '@expo/vector-icons/Ionicons';
import { useState } from 'react';
import { Pressable, ScrollView, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { PreviewChip } from './PreviewShell';
import { ThemedText } from '../ui/ThemedText';

type SpeedOption = '0.5x' | '0.75x' | '1.0x';

type BreakdownItem = {
  targetText: string;
  sourceText: string;
};

type PhraseHero = {
  id: string;
  label: string;
  targetText: string;
  pronunciation: string;
  sourceText: string;
  detailHint: string;
  whenToSay: string;
  breakdown: BreakdownItem[];
};

type NextPhraseLink = {
  pageId: string;
  label: string;
  targetText: string;
  sourceText: string;
  hint: string;
};

type PhrasePage = {
  id: string;
  situation: string;
  momentLabel: string;
  defaultHeroId: string;
  quickSayId: string;
  otherWayIds: string[];
  nextLinks: NextPhraseLink[];
};

const speedOptions: SpeedOption[] = ['0.5x', '0.75x', '1.0x'];

const phraseHeroes: Record<string, PhraseHero> = {
  'doctor-main': {
    id: 'doctor-main',
    label: 'Main line',
    targetText: 'Toi can bac si',
    pronunciation: 'toy kuhn bahk see',
    sourceText: 'I need a doctor',
    detailHint: 'Clear enough for a clinic desk, hotel staff member, or Grab driver helping you fast.',
    whenToSay: 'Use this when you need medical help quickly and want the safest full sentence to lead with.',
    breakdown: [
      { targetText: 'Toi', sourceText: 'I / me' },
      { targetText: 'can', sourceText: 'need' },
      { targetText: 'bac si', sourceText: 'doctor' },
    ],
  },
  'doctor-quick': {
    id: 'doctor-quick',
    label: 'Quick say',
    targetText: 'Bac si',
    pronunciation: 'bahk see',
    sourceText: 'Doctor',
    detailHint: 'Fastest useful version when you only have time for one word.',
    whenToSay: 'Use this under pressure when you need someone to understand the need instantly.',
    breakdown: [{ targetText: 'Bac si', sourceText: 'doctor' }],
  },
  'doctor-polite': {
    id: 'doctor-polite',
    label: 'Polite',
    targetText: 'Lam on giup toi tim bac si',
    pronunciation: 'lahm uhn zoop toy teem bahk see',
    sourceText: 'Please help me find a doctor',
    detailHint: 'A softer ask when you need help getting to the right person.',
    whenToSay: 'Use this with staff, hosts, or anyone who might guide you instead of treating you directly.',
    breakdown: [
      { targetText: 'Lam on', sourceText: 'please' },
      { targetText: 'giup toi', sourceText: 'help me' },
      { targetText: 'tim bac si', sourceText: 'find a doctor' },
    ],
  },
  'doctor-clearer': {
    id: 'doctor-clearer',
    label: 'Clearer',
    targetText: 'Toi can gap bac si ngay',
    pronunciation: 'toy kuhn gahp bahk see ngai',
    sourceText: 'I need to see a doctor now',
    detailHint: 'Adds urgency without becoming long or hard to say.',
    whenToSay: 'Use this when the first line lands, but you need to stress that it is immediate.',
    breakdown: [
      { targetText: 'Toi can', sourceText: 'I need' },
      { targetText: 'gap bac si', sourceText: 'to see a doctor' },
      { targetText: 'ngay', sourceText: 'now' },
    ],
  },
  'pharmacy-main': {
    id: 'pharmacy-main',
    label: 'Main line',
    targetText: 'Nha thuoc gan nhat o dau',
    pronunciation: 'nya thwook gahn nyut uh dow',
    sourceText: 'Where is the nearest pharmacy?',
    detailHint: 'Best next move when you need medicine before deciding on a clinic.',
    whenToSay: 'Use this when you need medicine, bandages, or a local pharmacy counter quickly.',
    breakdown: [
      { targetText: 'Nha thuoc', sourceText: 'pharmacy' },
      { targetText: 'gan nhat', sourceText: 'nearest' },
      { targetText: 'o dau', sourceText: 'where is it' },
    ],
  },
  'pharmacy-quick': {
    id: 'pharmacy-quick',
    label: 'Quick say',
    targetText: 'Nha thuoc',
    pronunciation: 'nya thwook',
    sourceText: 'Pharmacy',
    detailHint: 'Fastest version when you are pointing, walking, or asking multiple people quickly.',
    whenToSay: 'Use this when you need to move fast and only need a local person to understand the destination.',
    breakdown: [{ targetText: 'Nha thuoc', sourceText: 'pharmacy' }],
  },
  'pharmacy-polite': {
    id: 'pharmacy-polite',
    label: 'Polite',
    targetText: 'Xin chi toi nha thuoc gan nhat',
    pronunciation: 'sin chee toy nya thwook gahn nyut',
    sourceText: 'Please point me to the nearest pharmacy',
    detailHint: 'A stronger guidance ask when someone is giving directions.',
    whenToSay: 'Use this when a local is already helping and you want them to point or guide you.',
    breakdown: [
      { targetText: 'Xin chi toi', sourceText: 'please point me' },
      { targetText: 'nha thuoc', sourceText: 'pharmacy' },
      { targetText: 'gan nhat', sourceText: 'nearest' },
    ],
  },
  'pharmacy-buy': {
    id: 'pharmacy-buy',
    label: 'Clearer',
    targetText: 'Toi can mua thuoc',
    pronunciation: 'toy kuhn moo-ah thwook',
    sourceText: 'I need to buy medicine',
    detailHint: 'Useful when the goal is medicine rather than the location.',
    whenToSay: 'Use this when you are already inside the pharmacy or speaking to someone helping you shop.',
    breakdown: [
      { targetText: 'Toi can', sourceText: 'I need' },
      { targetText: 'mua', sourceText: 'to buy' },
      { targetText: 'thuoc', sourceText: 'medicine' },
    ],
  },
  'ambulance-main': {
    id: 'ambulance-main',
    label: 'Main line',
    targetText: 'Lam on goi xe cuu thuong',
    pronunciation: 'lahm uhn goy seh koo thwung',
    sourceText: 'Please call an ambulance',
    detailHint: 'Direct and urgent, with the ask clear right away.',
    whenToSay: 'Use this when someone needs emergency transport and you need action more than explanation.',
    breakdown: [
      { targetText: 'Lam on', sourceText: 'please' },
      { targetText: 'goi', sourceText: 'call' },
      { targetText: 'xe cuu thuong', sourceText: 'ambulance' },
    ],
  },
  'ambulance-quick': {
    id: 'ambulance-quick',
    label: 'Quick say',
    targetText: 'Xe cuu thuong',
    pronunciation: 'seh koo thwung',
    sourceText: 'Ambulance',
    detailHint: 'One fast phrase when there is no time to build a full sentence.',
    whenToSay: 'Use this when urgency matters more than grammar.',
    breakdown: [{ targetText: 'Xe cuu thuong', sourceText: 'ambulance' }],
  },
  'ambulance-injured': {
    id: 'ambulance-injured',
    label: 'Clearer',
    targetText: 'Co nguoi bi thuong',
    pronunciation: 'koh ngoo-ee bee thwung',
    sourceText: 'Someone is injured',
    detailHint: 'Helpful when you need to explain why the ambulance is needed.',
    whenToSay: 'Use this if the person helping you does not immediately understand the situation.',
    breakdown: [
      { targetText: 'Co nguoi', sourceText: 'there is a person / someone' },
      { targetText: 'bi thuong', sourceText: 'is injured' },
    ],
  },
  'ambulance-hospital': {
    id: 'ambulance-hospital',
    label: 'Polite',
    targetText: 'Toi can den benh vien ngay',
    pronunciation: 'toy kuhn den beng vee-en ngai',
    sourceText: 'I need to get to the hospital now',
    detailHint: 'A softer but still urgent version when transport is the focus.',
    whenToSay: 'Use this when you are talking to a driver, hotel desk, or bystander helping with transport.',
    breakdown: [
      { targetText: 'Toi can', sourceText: 'I need' },
      { targetText: 'den benh vien', sourceText: 'to get to the hospital' },
      { targetText: 'ngay', sourceText: 'now' },
    ],
  },
  'hurts-main': {
    id: 'hurts-main',
    label: 'Main line',
    targetText: 'Toi bi dau o day',
    pronunciation: 'toy bee dow uh day',
    sourceText: 'It hurts here',
    detailHint: 'Useful once you are already describing the problem to a doctor, pharmacist, or helper.',
    whenToSay: 'Use this when you need to point to the pain and keep the phrase simple.',
    breakdown: [
      { targetText: 'Toi bi dau', sourceText: 'I have pain / it hurts' },
      { targetText: 'o day', sourceText: 'here' },
    ],
  },
  'hurts-quick': {
    id: 'hurts-quick',
    label: 'Quick say',
    targetText: 'Dau o day',
    pronunciation: 'dow uh day',
    sourceText: 'Hurts here',
    detailHint: 'Fastest usable version when you can point at the exact place.',
    whenToSay: 'Use this when a gesture does most of the work and the words only need to confirm the pain.',
    breakdown: [
      { targetText: 'Dau', sourceText: 'pain / hurts' },
      { targetText: 'o day', sourceText: 'here' },
    ],
  },
  'hurts-dizzy': {
    id: 'hurts-dizzy',
    label: 'Clearer',
    targetText: 'Toi thay chong mat',
    pronunciation: 'toy thay chong maht',
    sourceText: 'I feel dizzy',
    detailHint: 'A likely follow-up symptom when the problem is not only pain.',
    whenToSay: 'Use this when you need to explain the symptom instead of just pointing at it.',
    breakdown: [
      { targetText: 'Toi thay', sourceText: 'I feel' },
      { targetText: 'chong mat', sourceText: 'dizzy' },
    ],
  },
  'hurts-allergy': {
    id: 'hurts-allergy',
    label: 'Polite',
    targetText: 'Toi bi di ung',
    pronunciation: 'toy bee zee oong',
    sourceText: 'I have an allergy',
    detailHint: 'A compact follow-up when you need to frame the cause, not only the symptom.',
    whenToSay: 'Use this when you suspect food, medicine, or contact exposure is causing the problem.',
    breakdown: [
      { targetText: 'Toi bi', sourceText: 'I have / I am affected by' },
      { targetText: 'di ung', sourceText: 'an allergy' },
    ],
  },
  'dosage-main': {
    id: 'dosage-main',
    label: 'Main line',
    targetText: 'Toi uong thuoc nay the nao',
    pronunciation: 'toy oo-ung thwook nye thay now',
    sourceText: 'How do I take this medicine?',
    detailHint: 'A strong pharmacy follow-up once you already have the medicine in hand.',
    whenToSay: 'Use this when you need dosage guidance, not just the product itself.',
    breakdown: [
      { targetText: 'Toi uong', sourceText: 'I take / drink' },
      { targetText: 'thuoc nay', sourceText: 'this medicine' },
      { targetText: 'the nao', sourceText: 'how' },
    ],
  },
  'dosage-quick': {
    id: 'dosage-quick',
    label: 'Quick say',
    targetText: 'Thuoc nay the nao',
    pronunciation: 'thwook nye thay now',
    sourceText: 'This medicine, how?',
    detailHint: 'A rough but memorable stress version when you can point to the medicine.',
    whenToSay: 'Use this when you can point to the box and only need the pharmacist to understand the ask.',
    breakdown: [
      { targetText: 'Thuoc nay', sourceText: 'this medicine' },
      { targetText: 'the nao', sourceText: 'how' },
    ],
  },
  'dosage-often': {
    id: 'dosage-often',
    label: 'Clearer',
    targetText: 'Uong may lan moi ngay',
    pronunciation: 'oo-ung may lahn moy ngai',
    sourceText: 'How many times per day do I take it?',
    detailHint: 'A more specific dosage follow-up when frequency matters.',
    whenToSay: 'Use this when the first answer is not enough and you need exact timing.',
    breakdown: [
      { targetText: 'Uong', sourceText: 'take / drink' },
      { targetText: 'may lan', sourceText: 'how many times' },
      { targetText: 'moi ngay', sourceText: 'each day' },
    ],
  },
  'dosage-write': {
    id: 'dosage-write',
    label: 'Polite',
    targetText: 'Lam on viet xuong cho toi',
    pronunciation: 'lahm uhn vee-et soong choh toy',
    sourceText: 'Please write it down for me',
    detailHint: 'Helpful when spoken directions are too hard to catch.',
    whenToSay: 'Use this when you need the pharmacist to switch from speech to something you can read or screenshot.',
    breakdown: [
      { targetText: 'Lam on', sourceText: 'please' },
      { targetText: 'viet xuong', sourceText: 'write it down' },
      { targetText: 'cho toi', sourceText: 'for me' },
    ],
  },
  'allergy-main': {
    id: 'allergy-main',
    label: 'Main line',
    targetText: 'Toi bi di ung voi dau phong',
    pronunciation: 'toy bee zee oong voy zow fohng',
    sourceText: 'I am allergic to peanuts',
    detailHint: 'Specific enough for food counters, pharmacies, and clinics.',
    whenToSay: 'Use this when the cause matters and the other person needs the exact trigger.',
    breakdown: [
      { targetText: 'Toi bi di ung', sourceText: 'I am allergic' },
      { targetText: 'voi', sourceText: 'to' },
      { targetText: 'dau phong', sourceText: 'peanuts' },
    ],
  },
  'allergy-quick': {
    id: 'allergy-quick',
    label: 'Quick say',
    targetText: 'Di ung dau phong',
    pronunciation: 'zee oong zow fohng',
    sourceText: 'Peanut allergy',
    detailHint: 'Fastest useful version when you need the ingredient understood immediately.',
    whenToSay: 'Use this when someone is deciding what food or medicine to hand you.',
    breakdown: [
      { targetText: 'Di ung', sourceText: 'allergy' },
      { targetText: 'dau phong', sourceText: 'peanuts' },
    ],
  },
  'allergy-food': {
    id: 'allergy-food',
    label: 'Clearer',
    targetText: 'Mon nay co dau phong khong',
    pronunciation: 'mohn nye koh zow fohng khong',
    sourceText: 'Does this dish have peanuts?',
    detailHint: 'A practical food follow-up once the staff understands the allergy.',
    whenToSay: 'Use this when you are screening a dish or menu item before ordering.',
    breakdown: [
      { targetText: 'Mon nay', sourceText: 'this dish' },
      { targetText: 'co', sourceText: 'has / contains' },
      { targetText: 'dau phong', sourceText: 'peanuts' },
      { targetText: 'khong', sourceText: 'or not' },
    ],
  },
  'allergy-no': {
    id: 'allergy-no',
    label: 'Polite',
    targetText: 'Lam on dung cho dau phong',
    pronunciation: 'lahm uhn zoong choh zow fohng',
    sourceText: 'Please do not add peanuts',
    detailHint: 'Useful when you want the request, not just the diagnosis.',
    whenToSay: 'Use this when ordering food and you need the kitchen adjustment clearly stated.',
    breakdown: [
      { targetText: 'Lam on', sourceText: 'please' },
      { targetText: 'dung cho', sourceText: 'do not add' },
      { targetText: 'dau phong', sourceText: 'peanuts' },
    ],
  },
};

const phrasePages: Record<string, PhrasePage> = {
  doctor: {
    id: 'doctor',
    situation: 'Pharmacy and care',
    momentLabel: 'Need medical help',
    defaultHeroId: 'doctor-main',
    quickSayId: 'doctor-quick',
    otherWayIds: ['doctor-main', 'doctor-clearer', 'doctor-polite'],
    nextLinks: [
      {
        pageId: 'pharmacy',
        label: 'Next',
        targetText: 'Nha thuoc gan nhat o dau',
        sourceText: 'Where is the nearest pharmacy?',
        hint: 'Find medicine first',
      },
      {
        pageId: 'ambulance',
        label: 'Escalate',
        targetText: 'Lam on goi xe cuu thuong',
        sourceText: 'Please call an ambulance',
        hint: 'Make it urgent',
      },
      {
        pageId: 'hurts',
        label: 'Explain more',
        targetText: 'Toi bi dau o day',
        sourceText: 'It hurts here',
        hint: 'Point to the problem',
      },
    ],
  },
  pharmacy: {
    id: 'pharmacy',
    situation: 'Pharmacy and care',
    momentLabel: 'Find medicine nearby',
    defaultHeroId: 'pharmacy-main',
    quickSayId: 'pharmacy-quick',
    otherWayIds: ['pharmacy-main', 'pharmacy-buy', 'pharmacy-polite'],
    nextLinks: [
      {
        pageId: 'dosage',
        label: 'Next',
        targetText: 'Toi uong thuoc nay the nao',
        sourceText: 'How do I take this medicine?',
        hint: 'Use it correctly',
      },
      {
        pageId: 'doctor',
        label: 'Fallback',
        targetText: 'Toi can bac si',
        sourceText: 'I need a doctor',
        hint: 'Escalate beyond medicine',
      },
      {
        pageId: 'allergy',
        label: 'Safety',
        targetText: 'Toi bi di ung voi dau phong',
        sourceText: 'I am allergic to peanuts',
        hint: 'Name the trigger',
      },
    ],
  },
  ambulance: {
    id: 'ambulance',
    situation: 'Emergency',
    momentLabel: 'Get urgent transport',
    defaultHeroId: 'ambulance-main',
    quickSayId: 'ambulance-quick',
    otherWayIds: ['ambulance-main', 'ambulance-injured', 'ambulance-hospital'],
    nextLinks: [
      {
        pageId: 'hurts',
        label: 'Next',
        targetText: 'Toi bi dau o day',
        sourceText: 'It hurts here',
        hint: 'Show the injury',
      },
      {
        pageId: 'doctor',
        label: 'Doctor',
        targetText: 'Toi can bac si',
        sourceText: 'I need a doctor',
        hint: 'Ask for treatment',
      },
      {
        pageId: 'pharmacy',
        label: 'Pharmacy',
        targetText: 'Nha thuoc gan nhat o dau',
        sourceText: 'Where is the nearest pharmacy?',
        hint: 'Try a faster counter',
      },
    ],
  },
  hurts: {
    id: 'hurts',
    situation: 'Symptoms',
    momentLabel: 'Explain the problem',
    defaultHeroId: 'hurts-main',
    quickSayId: 'hurts-quick',
    otherWayIds: ['hurts-main', 'hurts-dizzy', 'hurts-allergy'],
    nextLinks: [
      {
        pageId: 'doctor',
        label: 'Doctor',
        targetText: 'Toi can bac si',
        sourceText: 'I need a doctor',
        hint: 'Ask for the right help',
      },
      {
        pageId: 'pharmacy',
        label: 'Next',
        targetText: 'Nha thuoc gan nhat o dau',
        sourceText: 'Where is the nearest pharmacy?',
        hint: 'Find medicine nearby',
      },
      {
        pageId: 'ambulance',
        label: 'Urgent',
        targetText: 'Lam on goi xe cuu thuong',
        sourceText: 'Please call an ambulance',
        hint: 'Escalate fast',
      },
    ],
  },
  dosage: {
    id: 'dosage',
    situation: 'Pharmacy follow-up',
    momentLabel: 'Use the medicine safely',
    defaultHeroId: 'dosage-main',
    quickSayId: 'dosage-quick',
    otherWayIds: ['dosage-main', 'dosage-often', 'dosage-write'],
    nextLinks: [
      {
        pageId: 'allergy',
        label: 'Safety',
        targetText: 'Toi bi di ung voi dau phong',
        sourceText: 'I am allergic to peanuts',
        hint: 'Add the cause',
      },
      {
        pageId: 'doctor',
        label: 'Doctor',
        targetText: 'Toi can bac si',
        sourceText: 'I need a doctor',
        hint: 'Escalate if needed',
      },
      {
        pageId: 'pharmacy',
        label: 'Back to counter',
        targetText: 'Nha thuoc gan nhat o dau',
        sourceText: 'Where is the nearest pharmacy?',
        hint: 'Restart the pharmacy path',
      },
    ],
  },
  allergy: {
    id: 'allergy',
    situation: 'Food and medicine safety',
    momentLabel: 'Name the allergy clearly',
    defaultHeroId: 'allergy-main',
    quickSayId: 'allergy-quick',
    otherWayIds: ['allergy-main', 'allergy-food', 'allergy-no'],
    nextLinks: [
      {
        pageId: 'doctor',
        label: 'Doctor',
        targetText: 'Toi can bac si',
        sourceText: 'I need a doctor',
        hint: 'Escalate the problem',
      },
      {
        pageId: 'pharmacy',
        label: 'Next',
        targetText: 'Nha thuoc gan nhat o dau',
        sourceText: 'Where is the nearest pharmacy?',
        hint: 'Find treatment fast',
      },
      {
        pageId: 'hurts',
        label: 'Symptoms',
        targetText: 'Toi bi dau o day',
        sourceText: 'It hurts here',
        hint: 'Describe the effect',
      },
    ],
  },
};

function SectionHeading({ label, note }: { label: string; note?: string }) {
  return (
    <View className="mt-6">
      <ThemedText variant="label" className="text-primary">
        {label}
      </ThemedText>
      {note ? (
        <ThemedText variant="caption" className="mt-2">
          {note}
        </ThemedText>
      ) : null}
    </View>
  );
}

function TogglePill({
  label,
  selected,
  onPress,
}: {
  label: string;
  selected: boolean;
  onPress: () => void;
}) {
  return (
    <Pressable
      accessibilityRole="button"
      onPress={onPress}
      className={`rounded-full px-4 py-2 ${selected ? 'bg-primary' : 'bg-background'}`}
    >
      <ThemedText variant="caption" className={selected ? 'text-background' : 'text-text-secondary'}>
        {label}
      </ThemedText>
    </Pressable>
  );
}

export function PhraseProductPrototype() {
  const [pageStack, setPageStack] = useState<string[]>(['doctor']);
  const [heroOverrides, setHeroOverrides] = useState<Record<string, string>>({});
  const [savedHeroIds, setSavedHeroIds] = useState<string[]>(['doctor-main']);
  const [playbackSpeed, setPlaybackSpeed] = useState<SpeedOption>('1.0x');
  const [isPlaying, setIsPlaying] = useState(false);

  const currentPageId = pageStack[pageStack.length - 1] ?? 'doctor';
  const currentPage = phrasePages[currentPageId];
  const activeHeroId = heroOverrides[currentPageId] ?? currentPage.defaultHeroId;
  const activeHero = phraseHeroes[activeHeroId];
  const quickSayHero = phraseHeroes[currentPage.quickSayId];
  const otherWays = currentPage.otherWayIds.map((heroId) => phraseHeroes[heroId]);
  const isSaved = savedHeroIds.includes(activeHeroId);

  function handleSelectHero(heroId: string) {
    setHeroOverrides((current) => ({ ...current, [currentPageId]: heroId }));
    setIsPlaying(false);
  }

  function handleOpenNext(pageId: string) {
    setPageStack((current) => [...current, pageId]);
    setIsPlaying(false);
  }

  function handleBack() {
    if (pageStack.length <= 1) {
      return;
    }

    setPageStack((current) => current.slice(0, -1));
    setIsPlaying(false);
  }

  function handleToggleSave() {
    setSavedHeroIds((current) =>
      current.includes(activeHeroId) ? current.filter((heroId) => heroId !== activeHeroId) : [...current, activeHeroId],
    );
  }

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <View className="flex-1 overflow-hidden bg-background">
        <View className="absolute -right-10 top-6 h-40 w-40 rounded-full bg-accent-soft" style={{ opacity: 0.92 }} />
        <View className="absolute -left-14 bottom-16 h-48 w-48 rounded-full bg-premium-soft" style={{ opacity: 0.55 }} />

        <ScrollView className="flex-1" contentContainerClassName="px-5 pb-14 pt-4">
          <View className="flex-row items-center justify-between gap-3">
            <PreviewChip label="Preview 02" tone="warm" />
            <PreviewChip label="Phrase flow wireframe" />
          </View>

          <View className="mt-4 flex-row items-center gap-3">
            <Pressable
              accessibilityRole="button"
              hitSlop={10}
              onPress={handleBack}
              className={`h-12 w-12 items-center justify-center rounded-full border border-border bg-surface ${
                pageStack.length <= 1 ? 'opacity-45' : ''
              }`}
            >
              <Ionicons name="arrow-back" size={20} color="#111827" />
            </Pressable>

            <View className="flex-1 flex-row items-center gap-3 rounded-full border border-border bg-surface px-4 py-3 shadow-sm">
              <Ionicons name="search-outline" size={18} color="#6B7280" />
              <View className="flex-1">
                <ThemedText variant="caption">Search phrases or situations</ThemedText>
              </View>
            </View>
          </View>

          <View className="mt-4 flex-row flex-wrap gap-2">
            <PreviewChip label={currentPage.situation} tone="warm" />
            <PreviewChip label={currentPage.momentLabel} />
            {pageStack.length > 1 ? <PreviewChip label={`${pageStack.length} pages deep`} tone="premium" /> : null}
          </View>

          <ThemedText variant="caption" className="mt-3">
            Quick say and Other ways swap the hero in place. Next opens another full phrase page with the same shell.
          </ThemedText>

          <View className="mt-5 rounded-[34px] border border-border bg-surface px-5 py-6 shadow-sm">
            <View className="flex-row items-center justify-between gap-3">
              <View>
                <ThemedText variant="label" className="text-primary">
                  Hero phrase
                </ThemedText>
                <ThemedText variant="caption" className="mt-2">
                  {activeHero.label}
                </ThemedText>
              </View>
              <PreviewChip label={currentPage.momentLabel} tone="warm" />
            </View>

            <ThemedText variant="target" className="mt-5 text-[33px] leading-[39px]">
              {activeHero.targetText}
            </ThemedText>
            <ThemedText variant="pronunciation" className="mt-3">
              {activeHero.pronunciation}
            </ThemedText>
            <ThemedText variant="source" className="mt-2 text-[17px] leading-[24px]">
              {activeHero.sourceText}
            </ThemedText>
            <ThemedText variant="caption" className="mt-3">
              {activeHero.detailHint}
            </ThemedText>

            <View className="mt-6 flex-row items-center gap-4">
              <Pressable
                accessibilityRole="button"
                onPress={() => setIsPlaying((current) => !current)}
                className="h-24 w-24 items-center justify-center rounded-full bg-accent-soft"
              >
                <Ionicons name={isPlaying ? 'pause' : 'play'} size={34} color="#1F6F78" />
              </Pressable>

              <View className="flex-1 gap-3">
                <View className="flex-row flex-wrap gap-2">
                  {speedOptions.map((speed) => (
                    <TogglePill
                      key={speed}
                      label={speed}
                      selected={playbackSpeed === speed}
                      onPress={() => setPlaybackSpeed(speed)}
                    />
                  ))}
                </View>

                <Pressable
                  accessibilityRole="button"
                  onPress={handleToggleSave}
                  className={`flex-row items-center self-start rounded-full px-4 py-2 ${
                    isSaved ? 'bg-premium-soft' : 'bg-background'
                  }`}
                >
                  <Ionicons
                    name={isSaved ? 'bookmark' : 'bookmark-outline'}
                    size={16}
                    color={isSaved ? '#8A5A16' : '#6B7280'}
                  />
                  <ThemedText
                    variant="caption"
                    className={`ml-2 ${isSaved ? 'text-premium' : 'text-text-secondary'}`}
                  >
                    Save
                  </ThemedText>
                </Pressable>
              </View>
            </View>
          </View>

          <SectionHeading label="Quick say" note="Shortest useful version under stress." />
          <Pressable
            accessibilityRole="button"
            onPress={() => handleSelectHero(quickSayHero.id)}
            className={`mt-3 rounded-[24px] border px-4 py-4 ${
              activeHeroId === quickSayHero.id ? 'border-primary bg-accent-soft' : 'border-border bg-surface'
            }`}
          >
            <View className="flex-row items-center justify-between gap-3">
              <View className="flex-1">
                <ThemedText variant="subtitle" className="text-[19px] leading-[24px]">
                  {quickSayHero.targetText}
                </ThemedText>
                <ThemedText variant="caption" className="mt-1">
                  {quickSayHero.sourceText}
                </ThemedText>
              </View>
              <Ionicons
                name={activeHeroId === quickSayHero.id ? 'radio-button-on' : 'chevron-forward'}
                size={18}
                color={activeHeroId === quickSayHero.id ? '#1F6F78' : '#D97745'}
              />
            </View>
          </Pressable>

          <SectionHeading label="Break it down" note="Keep every non-English piece paired with plain English." />
          <View className="mt-3 rounded-[26px] bg-surface px-4 py-1">
            {activeHero.breakdown.map((item, index) => (
              <View
                key={`${activeHero.id}-${item.targetText}-${index}`}
                className={`flex-row items-start justify-between gap-3 py-4 ${
                  index < activeHero.breakdown.length - 1 ? 'border-b border-border' : ''
                }`}
              >
                <View className="flex-1">
                  <ThemedText variant="subtitle" className="text-[18px] leading-[22px]">
                    {item.targetText}
                  </ThemedText>
                  <ThemedText variant="caption" className="mt-1">
                    {item.sourceText}
                  </ThemedText>
                </View>
                <Ionicons name="remove" size={18} color="#A7AFBD" />
              </View>
            ))}
          </View>

          <SectionHeading label="Other ways" note="These keep you on the same page and swap the hero." />
          <ScrollView horizontal showsHorizontalScrollIndicator={false} className="mt-3" contentContainerClassName="gap-3 pr-5">
            {otherWays.map((hero) => {
              const selected = activeHeroId === hero.id;

              return (
                <Pressable
                  key={hero.id}
                  accessibilityRole="button"
                  onPress={() => handleSelectHero(hero.id)}
                  className={`w-[220px] rounded-[24px] border px-4 py-4 ${
                    selected ? 'border-primary bg-accent-soft' : 'border-border bg-surface'
                  }`}
                >
                  <View className="flex-row items-start justify-between gap-2">
                    <ThemedText variant="label" className={selected ? 'text-primary' : ''}>
                      {hero.label}
                    </ThemedText>
                    {selected ? <PreviewChip label="Active" tone="warm" /> : null}
                  </View>
                  <ThemedText variant="subtitle" className="mt-3 text-[18px] leading-[23px]">
                    {hero.targetText}
                  </ThemedText>
                  <ThemedText variant="caption" className="mt-2">
                    {hero.sourceText}
                  </ThemedText>
                </Pressable>
              );
            })}
          </ScrollView>

          <SectionHeading label="When to say" />
          <ThemedText className="mt-3 text-[15px] leading-7">{activeHero.whenToSay}</ThemedText>

          <SectionHeading label="Next" note="These are deeper phrase pages, not hero swaps." />
          <ScrollView horizontal showsHorizontalScrollIndicator={false} className="mt-3" contentContainerClassName="gap-3 pr-5">
            {currentPage.nextLinks.map((nextLink) => (
              <Pressable
                key={`${currentPage.id}-${nextLink.pageId}`}
                accessibilityRole="button"
                onPress={() => handleOpenNext(nextLink.pageId)}
                className="w-[230px] rounded-[24px] border border-border bg-surface px-4 py-4"
              >
                <View className="flex-row items-center justify-between gap-3">
                  <ThemedText variant="label" className="text-primary">
                    {nextLink.label}
                  </ThemedText>
                  <Ionicons name="arrow-forward" size={18} color="#D97745" />
                </View>
                <ThemedText variant="subtitle" className="mt-3 text-[18px] leading-[23px]">
                  {nextLink.targetText}
                </ThemedText>
                <ThemedText variant="caption" className="mt-2">
                  {nextLink.sourceText}
                </ThemedText>
                <ThemedText variant="caption" className="mt-4 text-primary">
                  {nextLink.hint}
                </ThemedText>
              </Pressable>
            ))}
          </ScrollView>
        </ScrollView>
      </View>
    </SafeAreaView>
  );
}
