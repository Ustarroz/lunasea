# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Monorepo structure

This repository contains four modules:

| Directory | Stack | Role |
|---|---|---|
| `lunasea/` | Flutter / Dart 3 | Mobile & desktop app (Android, iOS, macOS, Windows, Linux, Web) |
| `lunasea-notification-service/` | TypeScript / Express / Node.js | Webhook receiver → Firebase push notifications |
| `lunasea-cloud-functions/` | TypeScript / Firebase Functions | Serverless backend (user cleanup, etc.) |
| `lunasea-docs/` | GitBook | Documentation |

---

## lunasea (Flutter app)

All commands below are run from the `lunasea/` directory.

### Common commands

```bash
# Run in debug mode
flutter run

# Lint / static analysis
flutter analyze

# Code generation — required after changing any @HiveType, @JsonSerializable, or @RestApi annotation
npm run generate                   # Full pipeline
npm run generate:build_runner      # Hive adapters + JSON serializers + Retrofit clients only
npm run generate:localization      # Merge localization JSON files into assets/localization/
npm run generate:environment       # Regenerate lib/system/environment.dart from environment_config.yaml

# Watch mode for code generation during active development
npm run generate:build_runner:watch

# Release builds
npm run build:android
npm run build:ios
npm run build:macos
npm run build:web
npm run build:windows
npm run build:linux

# Profile build (performance testing)
npm run profile

# Prepare project after cloning (install husky, flutter pub get)
npm run prepare
```

There are no automated tests; `flutter analyze` is the primary quality gate.

### Architecture

**Entry point → bootstrap → app:**
`lib/main.dart` calls `bootstrap()` which initializes the database, theme, window manager, network, image cache, router and memory store in sequence. If bootstrap fails, `LunaRecoveryMode` launches instead of `LunaBIOS`.

**Four main layers:**

1. **`lib/api/`** — Self-contained API clients for each service (Radarr, Sonarr, Lidarr, SABnzbd, NZBGet, Tautulli, Wake-on-LAN). Each client is a plain Dart class (`RadarrAPI`, etc.) backed by Dio. Commands are split into small `part` files under `commands/`. Retrofit's `@RestApi` annotations are used for HTTP code generation — the generated files end in `.g.dart`.

2. **`lib/database/`** — Local persistence via Hive (key-value store).
   - `LunaBox` enum wraps the six Hive boxes (`lunasea`, `profiles`, `indexers`, `logs`, `externalModules`, `alerts`).
   - `LunaTable` enum maps each box to a settings enum (e.g., `RadarrDatabase`, `LunaSeaDatabase`).
   - Every setting is a `LunaTableMixin` enum value providing `.read()`, `.update()`, `.watch()`, and `.listenableBuilder()`.
   - Key format: `TABLENAME_SETTINGNAME` (e.g., `RADARR_QUEUE_REFRESH_RATE`).

3. **`lib/modules/`** — One subdirectory per supported service. Each follows the same internal layout:
   - `core/state.dart` — `extends LunaModuleState extends ChangeNotifier`. Holds the API instance and async futures for all data (`Future<List<RadarrMovie>>? _movies`). Calls `notifyListeners()` on any mutation.
   - `core/api_helper.dart` — Thin wrapper for error-handling around API calls.
   - `routes/` — One file per screen; screens are registered as `GoRoute` entries.

4. **`lib/router/`** — GoRouter-based navigation.
   - `LunaRoutes` enum lists top-level module routes.
   - Per-module route enums implement `LunaRoutesMixin`, which provides `.go()`, `.route()`, and `.redirect()` helpers and automatically shows `NotEnabledPage` when a module isn't configured in the active profile.

**State management:** Provider (`ChangeNotifierProvider`). All module states are registered in `LunaState.providers()` (`lib/system/state.dart`). Access via `context.read<RadarrState>()`.

**`LunaModule` enum** (`lib/modules.dart`) is the central registry for every module — it holds metadata (title, icon, colour, routes, webhook handlers) and is decorated with `@HiveType` so the drawer order can be persisted.

**Profiles:** `LunaProfile` (a Hive model) stores per-service credentials (host, API key, custom headers). The active profile is read at state reset time: every `*State.resetProfile()` reads `LunaProfile.current` to (re)create the API instance.

**Localization:** Source JSON files live in `localization/<module>/<lang>.json`. The script `scripts/generate_localization.dart` merges them into `assets/localization/<lang>.json`. All strings are accessed via `'key'.tr()` from `easy_localization`.

**Code generation output:** All `.g.dart` files are generated — do not edit them manually. Re-run `npm run generate:build_runner` after any change to annotated files.

### Commit convention

Commits must follow conventional commits with these allowed types: `feat`, `fix`, `refactor`, `chore`, `docs`, `release`. Enforced by commitlint (`.commitlintrc`).

### Git workflow

**Never push directly to `master`.** The harness blocks direct pushes to the default branch. Always go through a feature branch + PR, even on this personal fork — the history stays clean and reviewable.

Standard flow when changes are ready to ship:

```bash
# 1. Create a feature branch from current commit (after committing locally on master by mistake, or proactively before committing)
git branch <type>/<short-description> HEAD
git reset --hard origin/master         # rewind master to remote state
git checkout <type>/<short-description>

# 2. Push the branch
git push -u origin <type>/<short-description>

# 3. Create the PR (uses the gh CLI, already authenticated)
gh pr create --title "<conventional commit subject>" --body "<summary + test plan>"

# 4. Merge the PR and delete the remote branch in one shot
gh pr merge <PR-number> --merge --delete-branch

# 5. The local master auto-updates via the merge command. Verify:
git checkout master
git status   # should show "up to date with 'origin/master'"
```

Branch naming follows the commit type: `chore/...`, `feat/...`, `fix/...`, `refactor/...`, `docs/...`.

---

## lunasea-notification-service

Run from `lunasea-notification-service/`.

```bash
npm install
npm start          # Dev mode (nodemon + pino-pretty logging)
npm run build      # Compile TypeScript → dist/
npm run serve      # Production (runs compiled dist/)
npm run lint       # ESLint
npm run format     # Prettier
npm run docker:build
```

Requires environment variables for Firebase (project ID, client email, private key, database URL), Fanart.tv API key, TMDb API key, and Redis connection details. See `.env.sample` for the full list.

---

## lunasea-cloud-functions

Run from `lunasea-cloud-functions/functions/`.

```bash
npm install
npm run build      # Compile TypeScript
npm run serve      # Start Firebase local emulator
npm run deploy     # Deploy to Firebase
npm run logs       # Stream live function logs
```

> ⚠️ This module targets Node.js 14 (EOL) and firebase-functions v3. Upgrade to Node.js 18+ and firebase-functions v4+ before deploying to a new Firebase project.
