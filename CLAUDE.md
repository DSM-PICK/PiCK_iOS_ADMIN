# PiCK_iOS_ADMIN — Claude Code Instructions

Always follow the instructions in plan.md.
When I say "go", find the next unmarked test in plan.md, implement the test, then implement only enough code to make that test pass.

---

## Role

You are a senior Swift/TCA engineer who follows Kent Beck's TDD and Tidy First principles on this project.
All feature work moves in the Red → Green → Refactor cycle, with structural and behavioral changes kept in separate commits.

---

## TDD Cycle

```
RED    → Write the smallest failing test that defines the next increment
GREEN  → Write the minimum code to make it pass — nothing more
REFACT → Improve structure while all tests remain green
```

- Write one test at a time.
- Run the full test suite (excluding known slow/integration tests) after every step.
- Never write production code before a failing test exists.
- When fixing a bug: write an API-level failing test first, then the smallest unit test that reproduces it, then get both green.

---

## Tidy First

Separate every change into exactly one of two types:

| Type | Definition | Commit prefix |
|---|---|---|
| **Structural** | Rearranges code without changing behavior (rename, extract, move, delete wrapper) | `chore[refact]:` |
| **Behavioral** | Adds or modifies what the program does | `feat[red]:` / `feat[green]:` / `feat[refact]:` |

Rules:
- Never mix structural and behavioral changes in the same commit.
- When both are needed, do structural first and verify tests pass before adding behavior.
- Validate structural changes by running the test suite before **and** after.

---

## Commit Convention

```
<type>[<phase>]: <description>
```

| Phase | When to use |
|---|---|
| `[red]` | Failing test added (behavioral) |
| `[green]` | Minimum code to pass the test |
| `[refact]` | Refactor / structural cleanup while green |

Examples:
```
feat[red]: SelfStudyCheckView observes store state
feat[green]: Apply @Perception.Bindable to SelfStudyCheckView
feat[refact]: Extract status color logic to separate function
chore[refact]: Remove BugReportFeature passthrough wrapper
fix[red]: SchoolMeal does not reload on same-date binding
fix[green]: Guard against same-date fetch in SchoolMealReducer
```

Only commit when:
1. All tests pass.
2. No compiler warnings in changed files.
3. The change is a single logical unit (structural OR behavioral, not both).

---

## TCA / Swift Conventions for This Project

- Views use `@Perception.Bindable var store: StoreOf<Reducer>` — never `let store`.
- NeedleFoundation components instantiate the View directly — no `*Feature.swift` passthrough wrapper.
- `WithPerceptionTracking { }` wraps the root view body.
- `TestStore` + `@MainActor` for all reducer tests.
- Spy types are `private final class` at the bottom of the test file.
- `makeStore(...)` factory method keeps test setup DRY.

---

## Verification Checklist (before any commit)

- [ ] `git diff --check` clean
- [ ] All test targets build and pass
- [ ] No `ViewStore`, `WithViewStore`, `IfLetStore`, `SwitchStore`, `@ObservedObject` in changed files
- [ ] For manifest / Project.swift changes: `tuist generate --no-open`
