import { Text, type TextProps } from 'react-native';

const variants = {
  vietnamese: 'text-vietnamese text-[28px] font-bold leading-[34px]',
  target: 'text-vietnamese text-[28px] font-bold leading-[34px]',
  romanized: 'text-romanized text-base font-semibold leading-6',
  pronunciation: 'text-romanized text-base font-semibold leading-6',
  english: 'text-english text-base leading-6',
  source: 'text-english text-base leading-6',
  title: 'text-text-primary text-[30px] font-bold leading-[36px]',
  subtitle: 'text-text-primary text-[20px] font-semibold leading-[26px]',
  body: 'text-body text-[15px] leading-6',
  caption: 'text-caption text-[13px] leading-5',
  label: 'text-caption text-[11px] font-semibold uppercase tracking-[1px]',
  stat: 'text-text-primary text-xl font-semibold',
} as const;

type Variant = keyof typeof variants;

type Props = TextProps & {
  variant?: Variant;
  className?: string;
};

export function ThemedText({ variant = 'body', className = '', ...props }: Props) {
  return <Text className={`${variants[variant]} ${className}`.trim()} {...props} />;
}
