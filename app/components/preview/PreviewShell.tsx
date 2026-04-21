import { ReactNode } from 'react';
import { View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ThemedText } from '../ui/ThemedText';

type Tone = 'warm' | 'premium';

type PreviewShellProps = {
  label: string;
  title: string;
  body: string;
  footer: string;
  tone?: Tone;
  children: ReactNode;
};

export function PreviewShell({
  label,
  title,
  body,
  footer,
  tone = 'warm',
  children,
}: PreviewShellProps) {
  const badgeTone = tone === 'premium' ? 'text-premium bg-premium-soft' : 'text-primary bg-accent-soft';
  const accentOne = tone === 'premium' ? 'bg-premium-soft' : 'bg-accent-soft';
  const accentTwo = tone === 'premium' ? 'bg-accent-soft' : 'bg-premium-soft';

  return (
    <SafeAreaView className="flex-1 bg-background" edges={['top', 'bottom']}>
      <View className="flex-1 overflow-hidden">
        <View className={`absolute -right-10 top-0 h-36 w-36 rounded-full ${accentOne}`} style={{ opacity: 0.95 }} />
        <View className={`absolute -left-12 bottom-28 h-44 w-44 rounded-full ${accentTwo}`} style={{ opacity: 0.55 }} />
        <View className="flex-1 px-5 pb-6 pt-4">
          <View className="flex-1 justify-between">
            <View className="gap-5">
              <View className="flex-row items-center justify-between">
                <View className={`rounded-full px-3 py-2 ${badgeTone}`}>
                  <ThemedText variant="label" className={tone === 'premium' ? 'text-premium' : 'text-primary'}>
                    {label}
                  </ThemedText>
                </View>
                <View className="rounded-full bg-surface px-3 py-2">
                  <ThemedText variant="label">SpeakLocal native concept</ThemedText>
                </View>
              </View>

              <View>
                <ThemedText variant="title" className="text-[34px] leading-[40px]">
                  {title}
                </ThemedText>
                <ThemedText className="mt-3 text-[16px] leading-7">{body}</ThemedText>
              </View>
            </View>

            <View className="my-5 gap-4">{children}</View>

            <View className="rounded-[28px] border border-border bg-surface px-4 py-4 shadow-sm">
              <ThemedText variant="caption" className={tone === 'premium' ? 'text-premium' : 'text-text-secondary'}>
                {footer}
              </ThemedText>
            </View>
          </View>
        </View>
      </View>
    </SafeAreaView>
  );
}

export function PreviewCard({ children, className = '' }: { children: ReactNode; className?: string }) {
  return <View className={`rounded-[30px] border border-border bg-surface p-4 shadow-sm ${className}`.trim()}>{children}</View>;
}

export function PreviewChip({
  label,
  tone = 'neutral',
}: {
  label: string;
  tone?: 'neutral' | 'warm' | 'premium';
}) {
  const className =
    tone === 'warm'
      ? 'bg-accent-soft text-primary'
      : tone === 'premium'
        ? 'bg-premium-soft text-premium'
        : 'bg-surface-soft text-text-primary';

  return (
    <View className={`self-start rounded-full px-3 py-2 ${className}`}>
      <ThemedText variant="label" className={tone === 'premium' ? 'text-premium' : tone === 'warm' ? 'text-primary' : ''}>
        {label}
      </ThemedText>
    </View>
  );
}

export function PreviewStat({
  label,
  value,
  tone = 'neutral',
}: {
  label: string;
  value: string;
  tone?: 'neutral' | 'warm' | 'premium';
}) {
  const className =
    tone === 'warm' ? 'bg-accent-soft' : tone === 'premium' ? 'bg-premium-soft' : 'bg-surface-soft';

  return (
    <View className={`min-w-[92px] flex-1 rounded-3xl px-4 py-4 ${className}`}>
      <ThemedText variant="label" className={tone === 'premium' ? 'text-premium' : tone === 'warm' ? 'text-primary' : ''}>
        {label}
      </ThemedText>
      <ThemedText variant="stat" className="mt-2 text-[26px] leading-[30px]">
        {value}
      </ThemedText>
    </View>
  );
}

export function PreviewMiniRow({
  eyebrow,
  title,
  body,
  trailing,
}: {
  eyebrow?: string;
  title: string;
  body?: string;
  trailing?: ReactNode;
}) {
  return (
    <View className="flex-row items-start justify-between gap-3 rounded-[24px] bg-background px-4 py-4">
      <View className="flex-1">
        {eyebrow ? (
          <ThemedText variant="label" className="text-primary">
            {eyebrow}
          </ThemedText>
        ) : null}
        <ThemedText variant="subtitle" className={eyebrow ? 'mt-2 text-[18px] leading-[24px]' : 'text-[18px] leading-[24px]'}>
          {title}
        </ThemedText>
        {body ? <ThemedText variant="caption" className="mt-2">{body}</ThemedText> : null}
      </View>
      {trailing ? <View>{trailing}</View> : null}
    </View>
  );
}
