export interface AppConfig {
  /** Shown in the header, sign-in card, and browser tab. */
  title: string;
  /** One-line description under the title on the sign-in card. */
  tagline: string;
}

export type AppConfigInput = Partial<AppConfig>;

// The project config file is named after the project (`<project>.config.ts`),
// so it can't be imported by a fixed path. Load whichever one is present.
const modules = import.meta.glob<{ default: AppConfigInput }>(
  './*.config.ts',
  { eager: true }
);
const [configPath, configModule] = Object.entries(modules)[0] ?? [];
const projectName =
  configPath?.match(/^\.\/(.+)\.config\.ts$/)?.[1] ?? 'fabric-app';

function toTitle(slug: string): string {
  return slug
    .split(/[-_\s]+/)
    .filter(Boolean)
    .map((word) => word[0]!.toUpperCase() + word.slice(1))
    .join(' ');
}

export const appConfig: AppConfig = {
  title: toTitle(projectName),
  tagline: 'Sign in to get started.',
  ...configModule?.default,
};
