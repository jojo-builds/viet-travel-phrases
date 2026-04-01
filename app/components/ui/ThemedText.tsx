import { Text, type TextProps } from 'react-native';

const variants = {
  vietnamese: 'text-vietnamese text-2xl font-bold',
  romanized: 'text-romanized text-lg font-medium',
  english: 'text-english text-sm',
  title: 'text-text-primary text-[28px] font-bold',
  subtitle: 'text-text-primary text-lg font-semibold',
  body: 'text-body text-base',
  caption: 'text-caption text-xs',
} as const;

type Variant = keyof typeof variants;

type Props = TextProps & {
  variant?: Variant;
  className?: string;
};

export function ThemedText({
  variant = 'body',
  className = '',
  ...props
}: Props) {
  return <Text className={`${variants[variant]} ${className}`.trim()} {...props} />;
}
