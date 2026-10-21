# Contributing

Thanks for helping keep these demos accurate. Fabric Apps and the Rayfin CLI are in
preview and change often, so the most useful contributions are reports of what no
longer matches.

## Reporting a problem

Open an issue with:

- the demo folder and step,
- the Rayfin CLI version (`npx rayfin --version`) and your OS,
- the command you ran and the output you got (remove tenant, workspace, and item IDs,
  hosting URLs, publishable keys, and tokens first).

## Changing a demo

- Keep each demo self-contained in its own folder, with its own `package.json`,
  README, and `recording/`. Don't add shared tooling at the repository root.
- Follow the layout the existing READMEs use: tutorial link, recording table,
  prerequisites, steps, notes, clean up.
- If a change alters what a demo does, say in the pull request whether the recording
  still matches. Re-recording isn't required for a pull request; the maintainer can
  re-record against a real tenant.
- Never commit `rayfin/.env*`, `rayfin/.deployments.json`, `.env.local`, build output,
  or anything that identifies a tenant. Each demo's `.gitignore` already excludes the
  files the CLI generates.

## Pull requests

Keep pull requests focused on one demo or one problem, and describe how you checked
the change (for example, which commands you ran against which CLI version).
