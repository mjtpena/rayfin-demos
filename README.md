# Fabric Apps (Rayfin CLI) demos

Each folder is a self-contained demo of one Microsoft Learn tutorial for
[Fabric Apps](https://learn.microsoft.com/en-us/fabric/apps/). Each one was run
end to end against a real Fabric tenant and recorded. The recordings cover the
Fabric side too: the app items in the portal, the deployed app running inside
Fabric and at its live URL, and the app's data in its Fabric SQL database.

These are unofficial, community demos. They aren't affiliated with or endorsed by
Microsoft. Fabric Apps is in preview, so commands, output, and portal screens may
have changed since the recordings were made (October 2026, Rayfin CLI 1.36.2).

| Demo | Tutorial | What it shows | Recording |
|------|----------|---------------|-----------|
| [create-app-with-cli](create-app-with-cli/) | [Create and deploy your first Fabric app](https://learn.microsoft.com/en-us/fabric/apps/create-app-with-cli) | Scaffold, run locally with Fabric SSO, deploy, open the app inside Fabric and at its live URL, then a schema-only change (checked in the Fabric SQL editor) and a frontend-only update | [mp4](create-app-with-cli/recording/demo.mp4) · [gif](create-app-with-cli/recording/demo.gif) |
| [author-templates](author-templates/) | [Author and share Fabric Apps templates](https://learn.microsoft.com/en-us/fabric/apps/author-templates#create-a-template) | Deploy a working app, turn it into a template with placeholders, scaffold a project from it, run it locally, and deploy it to Fabric unchanged | [mp4](author-templates/recording/demo.mp4) · [gif](author-templates/recording/demo.gif) |
| [dev-prod-workflow](dev-prod-workflow/) | [Dev and prod workflow with the Rayfin CLI](https://learn.microsoft.com/en-us/fabric/apps/dev-prod-workflow) | One project in dev and prod workspaces, each with its own app item and database, `up switch` between them, and a fix that reaches dev before prod | [mp4](dev-prod-workflow/recording/demo.mp4) · [gif](dev-prod-workflow/recording/demo.gif) |
| [deploy-github-actions](deploy-github-actions/) | [Deploy a Fabric app with GitHub Actions](https://learn.microsoft.com/en-us/fabric/apps/deploy-github-actions) | Service-principal deploys from a GitHub workflow: a manual run creates the app in an empty workspace, then a push to `main` updates it | [mp4](deploy-github-actions/recording/demo.mp4) · [gif](deploy-github-actions/recording/demo.gif) |

The order above is a natural presenting order: create an app, package it as a
template, run it through dev and prod, then automate the deploy.

## Common prerequisites

- Node.js 20+ and npm
- A Fabric tenant with the **Fabric Apps** workload enabled, and a workspace on an active capacity
- Rayfin CLI 1.36.2, the version used for every recording. Each project lists
  `@microsoft/rayfin-cli` as a dev dependency, so run `npx rayfin` from inside the project.

## Signing in without a browser

`npx rayfin login` opens a browser. In a remote shell or agent session, reuse your
Azure CLI sign-in instead:

```bash
export RAYFIN_TOKEN=$(az account get-access-token \
  --resource https://api.fabric.microsoft.com --query accessToken -o tsv)
```

The token covers `up`, `dev`, `db apply`, `staticapp deploy`, `status`, `list`, and
`switch`, and lasts about an hour. The terminal parts of every recording except the
GitHub Actions one signed in this way.

## How the recordings were made

Each `demo.mp4` cuts the terminal run together with browser segments recorded at the
matching points. The terminal is real commands, captured as an asciicast
(`demo.cast`) and rendered with [agg](https://github.com/asciinema/agg). The browser
segments drive Edge, signed in to the Fabric tenant, through the portal, the deployed
apps, and `localhost`. A cursor, highlights, and a caption bar are drawn on top. Every
app item, URL, and row in the videos came from that run. `demo.gif` is the same
timeline at a lower frame rate. Stills from the browser segments sit next to each
video as `recording/*.png`.

The recordings are redacted. In the terminal output and the casts, tenant, capacity,
workspace, item, and service principal IDs are replaced with placeholders
(`00000000-0000-0000-0000-00000000000N`, consistent within each recording). The random
part of each hosting URL is zeroed, and local paths are shortened to `C:\src\…`. In the
browser segments, the signed-in user's name, email, and profile photo, the apps' live
URLs, and IDs shown on screen (such as the SQL preview's `id` and `user_id` columns) are
blurred. The apps in the recordings were deployed to a demo tenant and can't be
reached without signing in to it.

## Where the docs and CLI 1.36.2 disagree

Each demo's README lists what it found. The main ones:

- `npm create @microsoft/rayfin@latest my-app --workspace …` needs `--` before the
  scaffolder's options, or npm takes `--workspace` itself ([dev-prod-workflow](dev-prod-workflow/)).
- `rayfin dev` ignores the workspace that `npm create --workspace` saved in `rayfin/.env`.
  On a first run without `--workspace`, it creates a new `<project>-<timestamp>` workspace
  and picks a capacity for it, so pass `--workspace` again ([create-app-with-cli](create-app-with-cli/)).
- The docs' GitHub Actions YAML doesn't deploy as written. It needs line continuations and
  `"$CLIENT_SECRET"` in `rayfin login`, an `npm ci` step, `--encryption-fallback-enabled`, and
  `libsecret-1-0` on `ubuntu-24.04` runners ([deploy-github-actions](deploy-github-actions/)).
- `npx rayfin init .` right after `npm create` cancels, because `rayfin.yml` already exists.
  It's the path for an empty folder or existing code ([create-app-with-cli](create-app-with-cli/)).
- `rayfin up status` reports the first SQL database in the workspace, not necessarily the
  app's own ([create-app-with-cli](create-app-with-cli/)).
- A custom template's file contents aren't rewritten (only `README.md` and the `package.json` name),
  so code has to discover `__projectName__` files at runtime ([author-templates](author-templates/)).

## Contributing

Corrections are welcome, especially when a preview change breaks a step. See
[CONTRIBUTING.md](CONTRIBUTING.md). To report a leaked secret or tenant detail, see
[SECURITY.md](SECURITY.md).

## License

[MIT](LICENSE). The scaffolded projects in each demo were generated by
[`@microsoft/create-rayfin`](https://www.npmjs.com/package/@microsoft/create-rayfin) and
use the Rayfin packages, which are MIT licensed (Copyright Microsoft Corporation).
[`create-app-with-cli/my-app`](create-app-with-cli/my-app/) keeps the
[MIT license](create-app-with-cli/my-app/LICENSE) its template ships with (Copyright GitHub, Inc.).
