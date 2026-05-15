# PiCK_iOS_ADMIN Project Conventions

This file contains repository-specific guidance for PiCK_iOS_ADMIN.
Keep this file agent-agnostic so the same project rules work for Codex, Claude, or any other coding agent.
Use this file for repository-local build, verification, PR, and structure rules only.
Avoid tool-vendor-specific orchestration policy in this file unless the repository truly depends on it.

## Response / documentation language
- Default user-facing summaries, issue comments, and PR bodies to Korean unless the user explicitly asks for another language.

## Repository structure
- `Projects/App` — app target and app resources
- `Projects/Feature` — feature modules and feature `Project.swift` manifests
- `Projects/*Domain*` — domain modules
- `Tuist` — Tuist config, helpers, and templates
- `Scripts`, `ci_scripts` — automation helpers

## Build / generation workflow
- This repository uses Tuist + Needle.
- Before generation, ensure `Projects/App/Resources/Firebase` exists.
- Prefer the checked-in Make targets when they fit:
  - `make generate`
  - `make regenerate`
  - `make needle`
- Equivalent raw generation flow:
  1. `needle generate Projects/App/Sources/Application/DI/NeedleGenerated.swift Projects`
  2. `tuist install`
  3. `tuist generate`

## Verification rules
- Always run `git diff --check` before finishing code changes.
- For `Project.swift`, Tuist helper, or manifest changes, run `tuist generate --no-open` (or `make generate` when Firebase prerequisites are present).
- For helper-backed feature manifest changes, only set `includeUnitTests: true` when tracked test source files actually exist under that feature's `Tests/` directory.
- When changing Tuist manifest infrastructure, prefer verification that still works from a fresh worktree / clean checkout, not only from the current local state.

## Feature manifest conventions
- Common-case feature manifests should prefer `Project.makeFeatureModule(...)`.
- `BaseFeature` is an intentional exception today:
  - it uses `Project.makeFeature(...)`
  - it merges `Sources/**` and `Interface/**` into a single module
  - do not migrate it to `makeFeatureModule(...)` unless the helper contract is expanded for that single-module shape.

## PR / issue conventions
- PR title style should follow the repository's current pattern, e.g. `[#136] ...`.
- PR body should match `.github/PULL_REQUEST_TEMPLATE.md`:
  - `## 개요`
  - `## 작업사항`
  - `## UI`
- Link the related issue explicitly when applicable (`Closes #...`).

## Change-scope guidance
- Keep infra refactors and app logic changes separated when possible.
- Do not add new dependencies unless the user explicitly requests it.
- Prefer small, reviewable diffs and preserve existing feature-local ownership.

## TDD + Tidy First workflow
- Follow the Red → Green → Refactor cycle for all behavioral changes.
- Structural changes (wrapper removal, rename, extract) are Tidy First — commit separately before behavioral changes.
- See CLAUDE.md for the full methodology and commit convention.

## Commit convention
```
<type>[<phase>]: <description>
```
- `feat[red]` — failing test added
- `feat[green]` — minimum code to pass
- `feat[refact]` — refactor while green
- `chore[refact]` — structural / tidy-first cleanup
- `fix[red]` / `fix[green]` — bug fix cycle
- `add[green]` — new file/resource with no failing test phase needed

## Modern TCA pattern (target state for this repo)
- Views: `@Perception.Bindable var store: StoreOf<Reducer>` + `WithPerceptionTracking { }`
- Components: NeedleFoundation `Component<Dependency>` instantiates View directly — no `*Feature.swift` passthrough wrapper.
- No `ViewStore`, `WithViewStore`, `IfLetStore`, `@ObservedObject` anywhere.
