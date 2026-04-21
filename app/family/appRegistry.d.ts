import { AppDefinition, AppVariant } from './contracts';

export const DEFAULT_APP_VARIANT: AppVariant;
export const appRegistry: Record<AppVariant, AppDefinition>;
export const supportedAppVariants: AppVariant[];
export function resolveAppVariantFromEnv(env?: Record<string, string | undefined>): AppVariant;
export function findAppVariantByEasProjectId(easProjectId?: string): AppVariant | undefined;
export function resolveAppVariantFromBuildContext(options?: {
  env?: Record<string, string | undefined>;
  expoExtra?: {
    appVariant?: string;
    eas?: {
      projectId?: string;
    };
  };
  easProjectId?: string;
  allowDefault?: boolean;
}): AppVariant;
export function getAppDefinition(variant: AppVariant): AppDefinition;
