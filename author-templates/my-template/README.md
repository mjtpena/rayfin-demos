# {{PROJECT_NAME}}

{{PROJECT_NAME}} is a Fabric app scaffolded from the **My Starter** template:
Fabric-authenticated todo CRUD with a Rayfin data model and per-user row-level
security.

| Identifier | Value |
|------------|-------|
| npm package / Fabric item | `{{PROJECT_NAME_KEBAB}}` |
| App config | `src/{{PROJECT_NAME_KEBAB}}.config.ts` |
| PascalCase name (for types and components) | `{{PROJECT_NAME_PASCAL}}` |

## Getting started

```bash
# Provision the Fabric backend and start the local dev server
npm run dev

# Deploy the app to Fabric
npx rayfin up
```

Open [http://localhost:5173](http://localhost:5173) to view the app.

The CLI fills in the workspace ID, API URL, and publishable key in
`rayfin/.env` when you run `npm run dev` or `npx rayfin up`, so nothing
workspace-specific is checked in.

## Customize

Edit `src/{{PROJECT_NAME_KEBAB}}.config.ts` to change the app title and tagline
shown in the header and on the sign-in page.

## Project structure

```text
├── rayfin/
│   ├── rayfin.yml          # Fabric service configuration
│   └── data/
│       ├── Todo.ts         # Todo entity with @role-based per-user access
│       └── schema.ts       # Schema export consumed by the typed client
├── src/
│   ├── {{PROJECT_NAME_KEBAB}}.config.ts  # Per-project title and tagline
│   ├── appConfig.ts        # Loads the project config file
│   ├── main.tsx            # Entry point + Rayfin client bootstrap
│   ├── App.tsx             # Routes and auth gate
│   ├── hooks/
│   │   └── AuthContext.tsx # React context wrapping the auth helpers
│   ├── components/
│   │   └── AuthPage.tsx    # Sign-in UI
│   ├── pages/
│   │   └── HomePage.tsx    # Todo list UI
│   └── services/
│       ├── IAuthService.ts        # Auth service contract + AuthUser type
│       ├── MockAuthService.ts     # Local-dev impl (email/password)
│       ├── RayfinAuthService.ts   # Production impl (Fabric brokered auth)
│       ├── rayfinClient.ts        # Typed Rayfin client singleton
│       ├── bootstrap.ts           # Reads env, picks the right auth service
│       └── todos.ts               # Todo CRUD wrappers (in-memory in local dev)
└── package.json
```

## Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Provision or reuse the Fabric backend and start the local dev server |
| `npm run build` | Production build |
| `npm run build:fabric` | Build for Fabric deployment (entrypoint for `rayfin up staticapp deploy`) |
| `npm run lint` | Lint with ESLint |
| `npm run test` | Run unit tests with Vitest |
| `npm run rayfin:db` | Apply database migrations |
