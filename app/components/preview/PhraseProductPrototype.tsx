import Ionicons from '@expo/vector-icons/Ionicons';
import { useEffect, useMemo, useRef, useState } from 'react';
import { Pressable, ScrollView, StyleSheet, TextInput, type TextStyle, View, useWindowDimensions } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import Animated, { Easing, interpolate, useAnimatedStyle, useSharedValue, withTiming } from 'react-native-reanimated';
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

const palette = {
  page: '#F5F6F8',
  paper: '#FFFFFF',
  text: '#0F172A',
  muted: '#667085',
  subtle: '#98A2B3',
  line: 'rgba(148, 163, 184, 0.22)',
  glass: 'rgba(255, 255, 255, 0.78)',
  glassStrong: 'rgba(255, 255, 255, 0.92)',
  glassBorder: 'rgba(255, 255, 255, 0.88)',
  red: '#D84E42',
  redSoft: 'rgba(216, 78, 66, 0.12)',
  yellow: '#E1B847',
  yellowSoft: 'rgba(225, 184, 71, 0.16)',
  shadow: '#B6BFCC',
} as const;

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

type SearchEntry = {
  key: string;
  pageId: string;
  heroId: string;
  groupLabel: string;
  targetText: string;
  sourceText: string;
  context: string;
};

const bottomToolbarItems = [
  { id: 'quick', label: 'Quick', icon: 'flash-outline', sectionId: 'quick' },
  { id: 'breakdown', label: 'Break', icon: 'reorder-three-outline', sectionId: 'breakdown' },
  { id: 'next', label: 'Next', icon: 'arrow-forward-outline', sectionId: 'next' },
] as const;

const searchEntries: SearchEntry[] = Object.values(phrasePages).flatMap((page) => {
  const heroIds = Array.from(new Set([page.defaultHeroId, page.quickSayId, ...page.otherWayIds]));

  return heroIds.map((heroId) => {
    const hero = phraseHeroes[heroId];

    return {
      key: `${page.id}:${hero.id}`,
      pageId: page.id,
      heroId: hero.id,
      groupLabel: hero.label,
      targetText: hero.targetText,
      sourceText: hero.sourceText,
      context: `${page.momentLabel} · ${page.situation}`,
    };
  });
});

const webSearchInputReset = {
  boxShadow: 'none',
  outlineColor: 'transparent',
  outlineStyle: 'none',
  outlineWidth: 0,
} as unknown as TextStyle;

function SectionHeading({ label, note }: { label: string; note?: string }) {
  return (
    <View style={styles.sectionHeader}>
      <ThemedText variant="label" style={styles.sectionLabel}>
        {label}
      </ThemedText>
      {note ? (
        <ThemedText variant="caption" style={styles.sectionNote}>
          {note}
        </ThemedText>
      ) : null}
    </View>
  );
}

function MetaChip({
  label,
  tone = 'neutral',
}: {
  label: string;
  tone?: 'neutral' | 'red' | 'yellow';
}) {
  const style =
    tone === 'red'
      ? styles.metaChipRed
      : tone === 'yellow'
        ? styles.metaChipYellow
        : styles.metaChipNeutral;

  const textStyle =
    tone === 'red'
      ? styles.metaChipTextRed
      : tone === 'yellow'
        ? styles.metaChipTextYellow
        : styles.metaChipTextNeutral;

  return (
    <View style={[styles.metaChip, style]}>
      <ThemedText variant="caption" style={[styles.metaChipText, textStyle]}>
        {label}
      </ThemedText>
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
      style={[styles.controlPill, selected ? styles.controlPillSelected : styles.controlPillIdle]}
    >
      <ThemedText variant="caption" style={selected ? styles.controlPillTextSelected : styles.controlPillTextIdle}>
        {label}
      </ThemedText>
    </Pressable>
  );
}

export function PhraseProductPrototype() {
  const scrollViewRef = useRef<ScrollView>(null);
  const searchInputRef = useRef<TextInput>(null);
  const [pageStack, setPageStack] = useState<string[]>(['doctor']);
  const [heroOverrides, setHeroOverrides] = useState<Record<string, string>>({});
  const [savedHeroIds, setSavedHeroIds] = useState<string[]>(['doctor-main']);
  const [playbackSpeed, setPlaybackSpeed] = useState<SpeedOption>('1.0x');
  const [isPlaying, setIsPlaying] = useState(false);
  const [isSearchExpanded, setIsSearchExpanded] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const [sectionOffsets, setSectionOffsets] = useState<Record<string, number>>({});
  const searchProgress = useSharedValue(0);
  const { width } = useWindowDimensions();

  const currentPageId = pageStack[pageStack.length - 1] ?? 'doctor';
  const currentPage = phrasePages[currentPageId];
  const activeHeroId = heroOverrides[currentPageId] ?? currentPage.defaultHeroId;
  const activeHero = phraseHeroes[activeHeroId];
  const quickSayHero = phraseHeroes[currentPage.quickSayId];
  const otherWays = currentPage.otherWayIds.map((heroId) => phraseHeroes[heroId]);
  const isSaved = savedHeroIds.includes(activeHeroId);
  const collapsedSearchWidth = 56;
  const expandedSearchWidth = Math.max(224, Math.min(width - 56, 352));
  const toolbarActionWidth = Math.min(156, Math.max(132, width * 0.34));

  useEffect(() => {
    searchProgress.value = withTiming(isSearchExpanded ? 1 : 0, {
      duration: 380,
      easing: Easing.bezier(0.22, 1, 0.36, 1),
    });

    if (isSearchExpanded) {
      const timeout = setTimeout(() => searchInputRef.current?.focus(), 170);
      return () => clearTimeout(timeout);
    }

    searchInputRef.current?.blur();
  }, [isSearchExpanded, searchProgress]);

  const suggestedEntries = useMemo(() => {
    const seen = new Set<string>();
    const samePageEntries = [quickSayHero, ...otherWays]
      .filter((hero) => {
        const key = `${currentPage.id}:${hero.id}`;
        if (seen.has(key)) {
          return false;
        }

        seen.add(key);
        return true;
      })
      .slice(0, 2)
      .map(
        (hero): SearchEntry => ({
          key: `${currentPage.id}:${hero.id}`,
          pageId: currentPage.id,
          heroId: hero.id,
          groupLabel: hero.label,
          targetText: hero.targetText,
          sourceText: hero.sourceText,
          context: 'Swap hero in place',
        }),
      );

    const nextEntries = currentPage.nextLinks.slice(0, 3).map((link) => {
      const nextPage = phrasePages[link.pageId];
      const nextHero = phraseHeroes[nextPage.defaultHeroId];

      return {
        key: `${nextPage.id}:${nextHero.id}`,
        pageId: nextPage.id,
        heroId: nextHero.id,
        groupLabel: link.label,
        targetText: nextHero.targetText,
        sourceText: nextHero.sourceText,
        context: link.hint,
      } satisfies SearchEntry;
    });

    return [...samePageEntries, ...nextEntries].slice(0, 4);
  }, [currentPage.id, currentPage.nextLinks, otherWays, quickSayHero]);

  const visibleSearchResults = useMemo(() => {
    const normalizedQuery = searchQuery.trim().toLowerCase();
    if (!normalizedQuery) {
      return suggestedEntries;
    }

    return searchEntries
      .filter((entry) =>
        [entry.targetText, entry.sourceText, entry.context, entry.groupLabel].join(' ').toLowerCase().includes(normalizedQuery),
      )
      .slice(0, 4);
  }, [searchQuery, suggestedEntries]);

  const toolbarActionsStyle = useAnimatedStyle(() => ({
    width: interpolate(searchProgress.value, [0, 1], [toolbarActionWidth, 0]),
    opacity: interpolate(searchProgress.value, [0, 1], [1, 0]),
    marginRight: interpolate(searchProgress.value, [0, 1], [12, 0]),
    transform: [
      { translateX: interpolate(searchProgress.value, [0, 1], [0, -18]) },
      { scale: interpolate(searchProgress.value, [0, 1], [1, 0.92]) },
    ],
  }));

  const searchCapsuleStyle = useAnimatedStyle(() => ({
    width: interpolate(searchProgress.value, [0, 1], [collapsedSearchWidth, expandedSearchWidth]),
    transform: [{ translateY: interpolate(searchProgress.value, [0, 1], [0, -2]) }],
  }));

  const searchInputWrapStyle = useAnimatedStyle(() => ({
    width: interpolate(searchProgress.value, [0, 1], [0, expandedSearchWidth - 94]),
    opacity: interpolate(searchProgress.value, [0, 0.4, 1], [0, 0, 1]),
    marginLeft: interpolate(searchProgress.value, [0, 1], [0, 6]),
  }));

  const searchResultsStyle = useAnimatedStyle(() => ({
    opacity: interpolate(searchProgress.value, [0, 1], [0, 1]),
    transform: [
      { translateY: interpolate(searchProgress.value, [0, 1], [18, 0]) },
      { scale: interpolate(searchProgress.value, [0, 1], [0.98, 1]) },
    ],
  }));

  function handleToggleSearch(nextValue?: boolean) {
    setIsSearchExpanded((current) => {
      const next = nextValue ?? !current;
      if (!next) {
        setSearchQuery('');
      }

      return next;
    });
  }

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

  function handleSearchResultPress(entry: SearchEntry) {
    if (entry.pageId === currentPageId) {
      handleSelectHero(entry.heroId);
    } else {
      setHeroOverrides((current) => ({ ...current, [entry.pageId]: entry.heroId }));
      setPageStack((current) => [...current, entry.pageId]);
      setIsPlaying(false);
    }

    setSearchQuery('');
    setIsSearchExpanded(false);
  }

  function rememberSectionOffset(sectionId: string, offset: number) {
    setSectionOffsets((current) => {
      if (current[sectionId] === offset) {
        return current;
      }

      return { ...current, [sectionId]: offset };
    });
  }

  function handleJumpToSection(sectionId: string) {
    const target = sectionOffsets[sectionId];
    if (typeof target !== 'number') {
      return;
    }

    scrollViewRef.current?.scrollTo({
      y: Math.max(target - 104, 0),
      animated: true,
    });
  }

  return (
    <SafeAreaView style={styles.safeArea} edges={['top', 'bottom']}>
      <View style={styles.root}>
        <View style={[styles.lightOrb, styles.redOrb]} />
        <View style={[styles.lightOrb, styles.yellowOrb]} />
        <View style={[styles.lightOrb, styles.whiteOrb]} />

        <View style={styles.backLayer} pointerEvents="box-none">
          <Pressable
            accessibilityRole="button"
            hitSlop={10}
            onPress={handleBack}
            style={[styles.backGlassButton, pageStack.length <= 1 ? styles.disabledBackGlassButton : null]}
          >
            <Ionicons name="arrow-back" size={20} color={palette.text} />
          </Pressable>
        </View>

        <ScrollView
          ref={scrollViewRef}
          contentContainerStyle={styles.scrollContent}
          keyboardShouldPersistTaps="handled"
          showsVerticalScrollIndicator={false}
        >
          <View style={styles.topMetaRow}>
            <MetaChip label={currentPage.situation} tone="yellow" />
            <MetaChip label={currentPage.momentLabel} />
            <MetaChip label={activeHero.label} tone="red" />
            {pageStack.length > 1 ? <MetaChip label={`${pageStack.length} pages deep`} /> : null}
          </View>

          <View style={styles.heroCopyBlock}>
            <View style={styles.heroAccentDots}>
              <View style={[styles.heroAccentDot, styles.heroAccentDotRed]} />
              <View style={[styles.heroAccentDot, styles.heroAccentDotYellow]} />
            </View>

            <ThemedText variant="target" style={styles.heroTarget}>
              {activeHero.targetText}
            </ThemedText>
            <ThemedText variant="pronunciation" style={styles.heroPronunciation}>
              {activeHero.pronunciation}
            </ThemedText>
            <ThemedText variant="source" style={styles.heroSource}>
              {activeHero.sourceText}
            </ThemedText>
            <ThemedText variant="caption" style={styles.heroDetail}>
              {activeHero.detailHint}
            </ThemedText>
          </View>

          <View style={styles.controlDock}>
            <View style={styles.controlDockRow}>
              <Pressable
                accessibilityRole="button"
                onPress={() => setIsPlaying((current) => !current)}
                style={[styles.playOrbOuter, isPlaying ? styles.playOrbOuterActive : null]}
              >
                <View style={styles.playOrbInner}>
                  <Ionicons name={isPlaying ? 'pause' : 'play'} size={28} color={palette.paper} />
                </View>
              </Pressable>

              <View style={styles.controlDockCopy}>
                <ThemedText variant="label" style={styles.controlEyebrow}>
                  Playback
                </ThemedText>
                <ThemedText variant="caption" style={styles.controlHint}>
                  Hear the full line, slow it down, then save it if this is one you will need again.
                </ThemedText>
              </View>
            </View>

            <View style={styles.controlCluster}>
              <View style={styles.speedRow}>
                {speedOptions.map((speed) => (
                  <TogglePill
                    key={speed}
                    label={speed}
                    selected={playbackSpeed === speed}
                    onPress={() => setPlaybackSpeed(speed)}
                  />
                ))}
              </View>

              <Pressable accessibilityRole="button" onPress={handleToggleSave} style={styles.savePill}>
                <Ionicons
                  name={isSaved ? 'bookmark' : 'bookmark-outline'}
                  size={16}
                  color={isSaved ? palette.red : palette.muted}
                />
                <ThemedText variant="caption" style={isSaved ? styles.savePillTextActive : styles.savePillText}>
                  Save
                </ThemedText>
              </Pressable>
            </View>
          </View>

          <View onLayout={({ nativeEvent }) => rememberSectionOffset('quick', nativeEvent.layout.y)}>
            <SectionHeading label="Quick say" note="Shortest useful version under stress." />
            <Pressable accessibilityRole="button" onPress={() => handleSelectHero(quickSayHero.id)} style={styles.rowSurface}>
              <View style={styles.rowMain}>
                <View style={styles.rowCopy}>
                  <ThemedText variant="subtitle" style={styles.rowTitle}>
                    {quickSayHero.targetText}
                  </ThemedText>
                  <ThemedText variant="caption" style={styles.rowSubtitle}>
                    {quickSayHero.sourceText}
                  </ThemedText>
                </View>
                <View style={styles.rowTrailing}>
                  {activeHeroId === quickSayHero.id ? <MetaChip label="Active" tone="red" /> : null}
                  <Ionicons
                    name={activeHeroId === quickSayHero.id ? 'radio-button-on' : 'chevron-forward'}
                    size={18}
                    color={activeHeroId === quickSayHero.id ? palette.red : palette.muted}
                  />
                </View>
              </View>
            </Pressable>
          </View>

          <View onLayout={({ nativeEvent }) => rememberSectionOffset('breakdown', nativeEvent.layout.y)}>
            <SectionHeading label="Break it down" note="Keep every non-English piece paired with plain English." />
            <View style={styles.listSurface}>
              {activeHero.breakdown.map((item, index) => (
                <View
                  key={`${activeHero.id}-${item.targetText}-${index}`}
                  style={[styles.breakdownRow, index < activeHero.breakdown.length - 1 ? styles.breakdownDivider : null]}
                >
                  <View style={styles.breakdownCopy}>
                    <ThemedText variant="subtitle" style={styles.breakdownTitle}>
                      {item.targetText}
                    </ThemedText>
                    <ThemedText variant="caption" style={styles.breakdownSubtitle}>
                      {item.sourceText}
                    </ThemedText>
                  </View>
                  <Ionicons name="remove" size={18} color={palette.subtle} />
                </View>
              ))}
            </View>
          </View>

          <SectionHeading label="Other ways" note="These keep you on the same page and swap the hero." />
          <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.horizontalRail}>
            {otherWays.map((hero) => {
              const selected = activeHeroId === hero.id;

              return (
                <Pressable
                  key={hero.id}
                  accessibilityRole="button"
                  onPress={() => handleSelectHero(hero.id)}
                  style={[styles.variantTile, selected ? styles.variantTileSelected : null]}
                >
                  <View style={styles.variantTopRow}>
                    <ThemedText variant="label" style={selected ? styles.variantLabelSelected : styles.variantLabel}>
                      {hero.label}
                    </ThemedText>
                    {selected ? <MetaChip label="Active" tone="red" /> : null}
                  </View>
                  <ThemedText variant="subtitle" style={styles.variantTitle}>
                    {hero.targetText}
                  </ThemedText>
                  <ThemedText variant="caption" style={styles.variantSubtitle}>
                    {hero.sourceText}
                  </ThemedText>
                </Pressable>
              );
            })}
          </ScrollView>

          <SectionHeading label="When to say" />
          <ThemedText style={styles.whenToSayText}>{activeHero.whenToSay}</ThemedText>

          <View onLayout={({ nativeEvent }) => rememberSectionOffset('next', nativeEvent.layout.y)}>
            <SectionHeading label="Next" note="These are deeper phrase pages, not hero swaps." />
            <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.horizontalRail}>
              {currentPage.nextLinks.map((nextLink) => (
                <Pressable
                  key={`${currentPage.id}-${nextLink.pageId}`}
                  accessibilityRole="button"
                  onPress={() => handleOpenNext(nextLink.pageId)}
                  style={styles.nextTile}
                >
                  <View style={styles.nextTileTopRow}>
                    <MetaChip label={nextLink.label} tone="yellow" />
                    <Ionicons name="arrow-forward" size={18} color={palette.red} />
                  </View>
                  <ThemedText variant="subtitle" style={styles.nextTitle}>
                    {nextLink.targetText}
                  </ThemedText>
                  <ThemedText variant="caption" style={styles.nextSubtitle}>
                    {nextLink.sourceText}
                  </ThemedText>
                  <ThemedText variant="caption" style={styles.nextHint}>
                    {nextLink.hint}
                  </ThemedText>
                </Pressable>
              ))}
            </ScrollView>
          </View>
        </ScrollView>

        <Animated.View pointerEvents={isSearchExpanded ? 'auto' : 'none'} style={[styles.searchResultsLayer, searchResultsStyle]}>
          <View style={styles.searchResultsShell}>
            <View style={styles.searchResultsHeader}>
              <ThemedText variant="label" style={styles.searchResultsEyebrow}>
                {searchQuery.trim() ? 'Search' : 'Jump from here'}
              </ThemedText>
              <ThemedText variant="caption" style={styles.searchResultsCount}>
                {searchQuery.trim() ? `${visibleSearchResults.length} matches` : 'Quick phrase pivots'}
              </ThemedText>
            </View>

            {visibleSearchResults.length ? (
              visibleSearchResults.map((entry, index) => (
                <Pressable
                  key={entry.key}
                  accessibilityRole="button"
                  onPress={() => handleSearchResultPress(entry)}
                  style={[styles.searchResultRow, index < visibleSearchResults.length - 1 ? styles.searchResultDivider : null]}
                >
                  <View style={styles.searchResultCopy}>
                    <View style={styles.searchResultMetaRow}>
                      <MetaChip label={entry.groupLabel} tone="red" />
                    </View>
                    <ThemedText variant="subtitle" style={styles.searchResultTitle}>
                      {entry.targetText}
                    </ThemedText>
                    <ThemedText variant="caption" style={styles.searchResultSubtitle}>
                      {entry.sourceText}
                    </ThemedText>
                    <ThemedText variant="caption" style={styles.searchResultContext}>
                      {entry.context}
                    </ThemedText>
                  </View>
                  <Ionicons name="arrow-forward" size={18} color={palette.red} />
                </Pressable>
              ))
            ) : (
              <ThemedText variant="caption" style={styles.searchEmptyText}>
                No matches yet. Try doctor, pharmacy, pain, or medicine.
              </ThemedText>
            )}
          </View>
        </Animated.View>

        <View style={styles.bottomDockLayer} pointerEvents="box-none">
          <View style={styles.bottomDockShell}>
            <Animated.View style={[styles.bottomToolsRow, toolbarActionsStyle]}>
              {bottomToolbarItems.map((item) => (
                <Pressable
                  key={item.id}
                  accessibilityRole="button"
                  accessibilityLabel={item.label}
                  onPress={() => handleJumpToSection(item.sectionId)}
                  style={styles.bottomToolButton}
                >
                  <View style={styles.bottomToolIcon}>
                    <Ionicons name={item.icon} size={16} color={palette.text} />
                  </View>
                </Pressable>
              ))}
            </Animated.View>

            <Animated.View style={[styles.searchCapsule, searchCapsuleStyle]}>
              <Pressable
                accessibilityRole="button"
                accessibilityLabel={isSearchExpanded ? 'Focus search' : 'Open search'}
                onPress={() => {
                  if (!isSearchExpanded) {
                    handleToggleSearch(true);
                    return;
                  }

                  searchInputRef.current?.focus();
                }}
                style={styles.searchIconButton}
              >
                <Ionicons name="search-outline" size={18} color={palette.text} />
              </Pressable>

              <Animated.View style={[styles.searchInputWrap, searchInputWrapStyle]}>
                <TextInput
                  ref={searchInputRef}
                  value={searchQuery}
                  onChangeText={setSearchQuery}
                  placeholder="Search phrases or situations"
                  placeholderTextColor={palette.muted}
                  selectionColor={palette.red}
                  style={[styles.searchInput, webSearchInputReset]}
                />

                <Pressable
                  accessibilityRole="button"
                  onPress={() => {
                    if (searchQuery.length > 0) {
                      setSearchQuery('');
                      return;
                    }

                    handleToggleSearch(false);
                  }}
                  style={styles.searchCloseButton}
                >
                  <Ionicons name={searchQuery.length > 0 ? 'close-circle' : 'close'} size={16} color={palette.muted} />
                </Pressable>
              </Animated.View>
            </Animated.View>
          </View>
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: palette.page,
  },
  root: {
    flex: 1,
    overflow: 'hidden',
    backgroundColor: palette.page,
  },
  scrollContent: {
    paddingHorizontal: 20,
    paddingTop: 88,
    paddingBottom: 188,
  },
  lightOrb: {
    position: 'absolute',
    borderRadius: 999,
  },
  redOrb: {
    right: -52,
    top: 86,
    width: 208,
    height: 208,
    backgroundColor: 'rgba(216, 78, 66, 0.12)',
  },
  yellowOrb: {
    left: -34,
    top: 248,
    width: 180,
    height: 180,
    backgroundColor: 'rgba(225, 184, 71, 0.14)',
  },
  whiteOrb: {
    right: 36,
    top: 214,
    width: 156,
    height: 156,
    backgroundColor: 'rgba(255, 255, 255, 0.84)',
  },
  backLayer: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    zIndex: 20,
  },
  backGlassButton: {
    marginLeft: 20,
    marginTop: 8,
    width: 54,
    height: 54,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 27,
    backgroundColor: palette.glass,
    borderWidth: 1,
    borderColor: palette.glassBorder,
    shadowColor: palette.shadow,
    shadowOpacity: 0.18,
    shadowRadius: 22,
    shadowOffset: { width: 0, height: 10 },
    elevation: 10,
  },
  disabledBackGlassButton: {
    opacity: 0.48,
  },
  topMetaRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
    alignItems: 'center',
    marginTop: 8,
  },
  metaChip: {
    borderRadius: 999,
    paddingHorizontal: 12,
    paddingVertical: 8,
  },
  metaChipNeutral: {
    backgroundColor: 'rgba(255, 255, 255, 0.82)',
    borderWidth: 1,
    borderColor: palette.glassBorder,
  },
  metaChipRed: {
    backgroundColor: palette.redSoft,
  },
  metaChipYellow: {
    backgroundColor: palette.yellowSoft,
  },
  metaChipText: {
    lineHeight: 16,
  },
  metaChipTextNeutral: {
    color: palette.muted,
  },
  metaChipTextRed: {
    color: palette.red,
  },
  metaChipTextYellow: {
    color: '#9A6D0A',
  },
  heroCopyBlock: {
    marginTop: 24,
  },
  heroAccentDots: {
    flexDirection: 'row',
    gap: 8,
    marginTop: 8,
  },
  heroAccentDot: {
    width: 10,
    height: 10,
    borderRadius: 999,
  },
  heroAccentDotRed: {
    backgroundColor: palette.red,
  },
  heroAccentDotYellow: {
    backgroundColor: palette.yellow,
  },
  heroTarget: {
    marginTop: 18,
    color: palette.text,
    fontSize: 40,
    lineHeight: 46,
  },
  heroPronunciation: {
    marginTop: 12,
    color: palette.red,
    fontSize: 19,
    lineHeight: 24,
  },
  heroSource: {
    marginTop: 10,
    color: palette.text,
    fontSize: 18,
    lineHeight: 24,
  },
  heroDetail: {
    marginTop: 14,
    color: palette.muted,
    lineHeight: 22,
  },
  controlDock: {
    marginTop: 20,
    padding: 18,
    borderRadius: 32,
    backgroundColor: palette.glass,
    borderWidth: 1,
    borderColor: palette.glassBorder,
    shadowColor: palette.shadow,
    shadowOpacity: 0.2,
    shadowRadius: 26,
    shadowOffset: { width: 0, height: 14 },
    elevation: 8,
  },
  controlDockRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 16,
  },
  playOrbOuter: {
    width: 92,
    height: 92,
    borderRadius: 999,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(255, 255, 255, 0.7)',
  },
  playOrbOuterActive: {
    backgroundColor: 'rgba(255, 255, 255, 0.9)',
  },
  playOrbInner: {
    width: 66,
    height: 66,
    borderRadius: 999,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: palette.red,
    shadowColor: palette.red,
    shadowOpacity: 0.28,
    shadowRadius: 16,
    shadowOffset: { width: 0, height: 8 },
    elevation: 6,
  },
  controlDockCopy: {
    flex: 1,
  },
  controlEyebrow: {
    color: palette.red,
  },
  controlHint: {
    marginTop: 8,
    color: palette.muted,
    lineHeight: 21,
  },
  controlCluster: {
    marginTop: 18,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 14,
  },
  speedRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
    flex: 1,
  },
  controlPill: {
    borderRadius: 999,
    paddingHorizontal: 14,
    paddingVertical: 10,
  },
  controlPillIdle: {
    backgroundColor: palette.glassStrong,
  },
  controlPillSelected: {
    backgroundColor: palette.red,
  },
  controlPillTextIdle: {
    color: palette.muted,
  },
  controlPillTextSelected: {
    color: palette.paper,
  },
  savePill: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    borderRadius: 999,
    backgroundColor: palette.glassStrong,
    paddingHorizontal: 14,
    paddingVertical: 10,
  },
  savePillText: {
    color: palette.muted,
  },
  savePillTextActive: {
    color: palette.red,
  },
  sectionHeader: {
    marginTop: 28,
  },
  sectionLabel: {
    color: palette.red,
  },
  sectionNote: {
    marginTop: 8,
    color: palette.muted,
  },
  rowSurface: {
    marginTop: 12,
    borderRadius: 24,
    backgroundColor: palette.paper,
    borderWidth: 1,
    borderColor: palette.line,
    paddingHorizontal: 16,
    paddingVertical: 16,
  },
  rowMain: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 12,
  },
  rowCopy: {
    flex: 1,
  },
  rowTitle: {
    color: palette.text,
    fontSize: 19,
    lineHeight: 24,
  },
  rowSubtitle: {
    marginTop: 4,
    color: palette.muted,
  },
  rowTrailing: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  listSurface: {
    marginTop: 12,
    borderRadius: 26,
    backgroundColor: palette.paper,
    borderWidth: 1,
    borderColor: palette.line,
    paddingHorizontal: 16,
    paddingVertical: 4,
  },
  breakdownRow: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    justifyContent: 'space-between',
    gap: 12,
    paddingVertical: 16,
  },
  breakdownDivider: {
    borderBottomWidth: 1,
    borderBottomColor: palette.line,
  },
  breakdownCopy: {
    flex: 1,
  },
  breakdownTitle: {
    color: palette.text,
    fontSize: 18,
    lineHeight: 22,
  },
  breakdownSubtitle: {
    marginTop: 4,
    color: palette.muted,
  },
  horizontalRail: {
    gap: 12,
    paddingRight: 20,
    marginTop: 12,
  },
  variantTile: {
    width: 222,
    borderRadius: 24,
    backgroundColor: palette.glass,
    borderWidth: 1,
    borderColor: palette.glassBorder,
    paddingHorizontal: 16,
    paddingVertical: 16,
  },
  variantTileSelected: {
    backgroundColor: 'rgba(255, 255, 255, 0.9)',
    borderColor: 'rgba(216, 78, 66, 0.18)',
  },
  variantTopRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 8,
  },
  variantLabel: {
    color: palette.muted,
  },
  variantLabelSelected: {
    color: palette.red,
  },
  variantTitle: {
    marginTop: 14,
    color: palette.text,
    fontSize: 18,
    lineHeight: 23,
  },
  variantSubtitle: {
    marginTop: 8,
    color: palette.muted,
  },
  whenToSayText: {
    marginTop: 12,
    color: palette.text,
    lineHeight: 27,
  },
  nextTile: {
    width: 236,
    borderRadius: 24,
    backgroundColor: palette.paper,
    borderWidth: 1,
    borderColor: palette.line,
    paddingHorizontal: 16,
    paddingVertical: 16,
  },
  nextTileTopRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 10,
  },
  nextTitle: {
    marginTop: 14,
    color: palette.text,
    fontSize: 18,
    lineHeight: 23,
  },
  nextSubtitle: {
    marginTop: 8,
    color: palette.muted,
  },
  nextHint: {
    marginTop: 16,
    color: palette.red,
  },
  searchResultsLayer: {
    position: 'absolute',
    left: 18,
    right: 18,
    bottom: 106,
    zIndex: 16,
  },
  searchResultsShell: {
    borderRadius: 30,
    paddingHorizontal: 16,
    paddingVertical: 14,
    backgroundColor: 'rgba(255, 255, 255, 0.88)',
    borderWidth: 1,
    borderColor: palette.glassBorder,
    shadowColor: palette.shadow,
    shadowOpacity: 0.18,
    shadowRadius: 26,
    shadowOffset: { width: 0, height: 14 },
    elevation: 10,
  },
  searchResultsHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 12,
    paddingBottom: 8,
  },
  searchResultsEyebrow: {
    color: palette.red,
  },
  searchResultsCount: {
    color: palette.muted,
  },
  searchResultRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    gap: 12,
    paddingVertical: 14,
  },
  searchResultDivider: {
    borderBottomWidth: 1,
    borderBottomColor: palette.line,
  },
  searchResultCopy: {
    flex: 1,
  },
  searchResultMetaRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  searchResultTitle: {
    marginTop: 10,
    color: palette.text,
    fontSize: 18,
    lineHeight: 24,
  },
  searchResultSubtitle: {
    marginTop: 4,
    color: palette.muted,
  },
  searchResultContext: {
    marginTop: 8,
    color: palette.red,
  },
  searchEmptyText: {
    paddingVertical: 12,
    color: palette.muted,
    lineHeight: 21,
  },
  bottomDockLayer: {
    position: 'absolute',
    left: 18,
    right: 18,
    bottom: 18,
    zIndex: 18,
  },
  bottomDockShell: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  bottomToolsRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    overflow: 'hidden',
  },
  bottomToolButton: {
    width: 44,
    height: 44,
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 22,
    backgroundColor: palette.glass,
    borderWidth: 1,
    borderColor: palette.glassBorder,
    shadowColor: palette.shadow,
    shadowOpacity: 0.16,
    shadowRadius: 18,
    shadowOffset: { width: 0, height: 10 },
    elevation: 8,
  },
  bottomToolIcon: {
    width: 44,
    height: 44,
    borderRadius: 22,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: palette.glassStrong,
  },
  searchCapsule: {
    height: 58,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'flex-start',
    borderRadius: 999,
    paddingHorizontal: 10,
    backgroundColor: palette.glassStrong,
    borderWidth: 1,
    borderColor: palette.glassBorder,
    shadowColor: palette.shadow,
    shadowOpacity: 0.22,
    shadowRadius: 22,
    shadowOffset: { width: 0, height: 12 },
    elevation: 10,
    overflow: 'hidden',
  },
  searchIconButton: {
    width: 36,
    height: 36,
    borderRadius: 18,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: palette.glassStrong,
  },
  searchInputWrap: {
    flexDirection: 'row',
    alignItems: 'center',
    overflow: 'hidden',
  },
  searchInput: {
    flex: 1,
    minWidth: 0,
    color: palette.text,
    fontSize: 15,
    backgroundColor: 'transparent',
    borderWidth: 0,
    borderColor: 'transparent',
    paddingVertical: 0,
    paddingHorizontal: 0,
  },
  searchCloseButton: {
    width: 28,
    height: 28,
    alignItems: 'center',
    justifyContent: 'center',
    marginLeft: 8,
  },
});
