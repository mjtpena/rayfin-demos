import type { AppConfigInput } from './appConfig';

/**
 * Per-project settings. The template ships this file as
 * `__projectName__.config.ts`, so the Rayfin CLI renames it after the project
 * on scaffold (for example `my-app.config.ts`) and the app title defaults to
 * that name. Set `title` here to override it.
 */
export default {
  tagline: 'Track the work your team ships on Fabric.',
} satisfies AppConfigInput;
