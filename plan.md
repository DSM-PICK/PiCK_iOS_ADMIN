# plan.md — Feature Wrapper Removal (TCA Rollout #135)

## How to use
- Say **"go"** → agent picks the next `- [ ]` item, writes the test, then the minimum code to pass it.
- Items marked `[STRUCTURAL]` are Tidy First changes: no new test needed, verify existing suite green before and after.
- TDD items follow `RED → GREEN → REFACT` with commits `feat[red]:`, `feat[green]:`, `feat[refact]:`.
- Structural items use commit `chore[refact]:`.

---

## Scope

Remove the passthrough `*Feature.swift` wrapper structs from 4 features and have each Component instantiate the View directly, matching the `ClassroomMoveListFeature` reference pattern.

| Feature | Wrapper to remove | Extra work |
|---|---|---|
| `SchoolMealFeature` | `SchoolMealFeature.swift` | none (View already uses `@Perception.Bindable`) |
| `BugReport` | `BugReportFeature.swift` | none (View already uses `@Perception.Bindable`) |
| `CheckSelfStudyTeacher` | `CheckSelfStudyTeacherFeature.swift` | none (View already uses `@Perception.Bindable`) |
| `SelfStudyCheck` | `SelfStudyCheckFeature.swift` | View needs `@Perception.Bindable` + old `Store<S,A>` type |

---

## Phase 1 — Fill SelfStudyCheck test gaps (TDD)

SelfStudyCheck has only 1 test. Add Reducer coverage before touching the structure.

- [x] RED: `testFetchStudents_StoresStudentItemsAndClearsLoading` — onAppear triggers fetch, success stores items and sets isLoading false
- [x] GREEN: verify SelfStudyCheckReducer.fetchStudents path makes the test pass (existing impl satisfies)
- [x] RED: `testSelectPeriod_UpdatesSelectedPeriodAndRefetches` — sending `.selectPeriod(.ninth)` updates state and triggers a new fetch
- [x] GREEN: verify selectPeriod reducer path passes (existing impl satisfies)
- [x] RED: `testSelectGradeAndClass_UpdatesFilterAndRefetches` — `.selectGradeAndClass(grade:2, classNum:3)` updates selectedGrade/Class and triggers fetch
- [x] GREEN: verify selectGradeAndClass reducer path passes (existing impl satisfies)
- [x] RED: `testSaveAttendance_SetsIsSavingThenClearsOnSuccess` — `.saveAttendance` sets isSaving true; `.saveAttendanceResponse(.success)` clears it and resets baseline
- [x] GREEN: verify saveAttendance reducer path passes (existing impl satisfies)
- [x] RED: `testFetchStudents_FailureStopsLoading` — fetch failure clears isLoading, does not crash
- [x] GREEN: verify failure path passes (existing impl satisfies)

---

## Phase 2 — Tidy First: structural wrapper removals

Each item below is a structural change. Run the relevant test target before and after to confirm no behavioral regression.

### 2-A  BugReport

- [x] [STRUCTURAL] Verify `BugReportTests` green before change
- [x] [STRUCTURAL] Remove `BugReportFeature.swift`; update `BugReportComponent.makeView()` to instantiate `BugReportView(store:)` directly
- [x] [STRUCTURAL] Verify `BugReportTests` green after change — commit `chore[refact]: Remove BugReportFeature passthrough wrapper`

### 2-B  CheckSelfStudyTeacher

- [x] [STRUCTURAL] Verify `CheckSelfStudyTeacherFeatureTests` green before change
- [x] [STRUCTURAL] Remove `CheckSelfStudyTeacherFeature.swift`; update `CheckSelfStudyTeacherComponent.makeView()` to instantiate `CheckSelfStudyTeacherView(store:)` directly
- [x] [STRUCTURAL] Verify `CheckSelfStudyTeacherFeatureTests` green after change — commit `chore[refact]: Remove CheckSelfStudyTeacherFeature passthrough wrapper`

### 2-C  SchoolMeal

- [x] [STRUCTURAL] Verify `SchoolMealTests` green before change
- [x] [STRUCTURAL] Remove `SchoolMealFeature.swift`; update `SchoolMealComponentImpl.makeSchoolMealView()` to instantiate `SchoolMealView(store:)` directly
- [x] [STRUCTURAL] Verify `SchoolMealTests` green after change — commit `chore[refact]: Remove SchoolMealFeature passthrough wrapper`

### 2-D  SelfStudyCheck

- [x] [STRUCTURAL] Verify `SelfStudyCheckTests` green before change (Phase 1 tests must all pass first)
- [x] [STRUCTURAL] Apply `@Perception.Bindable var store: StoreOf<SelfStudyCheckReducer>` to `SelfStudyCheckView`
- [x] [STRUCTURAL] Remove `SelfStudyCheckFeature.swift`; update `SelfStudyCheckComponent.makeView()` to instantiate `SelfStudyCheckView(store:)` directly; remove `NavigationView` wrapper
- [x] [STRUCTURAL] Verify `SelfStudyCheckTests` green after change — commit `chore[refact]: Remove SelfStudyCheckFeature passthrough wrapper and modernize View`

---

## Done criteria

- [x] No `*Feature.swift` passthrough wrapper files exist in BugReport, CheckSelfStudyTeacher, SchoolMeal, SelfStudyCheck
- [x] Wrapper type instantiation scan: 0 remaining references in production sources
- [x] Forbidden TCA pattern scan: 0 (`ViewStore`, `WithViewStore`, `IfLetStore`, `@ObservedObject`)
- [x] `git diff --check` clean
- [x] All commits follow `<type>[<phase>]:` convention (enforced by commit-msg hook)
- [x] pre-commit hook active: catches forbidden patterns + View `let store` violations
- [ ] All feature test targets pass — requires Xcode build (run `make generate` then test in Xcode)

> Note: `let store` remains in `HomeFeature` and `PlanFeature` — out of scope for #135.
