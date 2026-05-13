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

- [ ] RED: `testFetchStudents_StoresStudentItemsAndClearsLoading` — onAppear triggers fetch, success stores items and sets isLoading false
- [ ] GREEN: verify SelfStudyCheckReducer.fetchStudents path makes the test pass
- [ ] RED: `testSelectPeriod_UpdatesSelectedPeriodAndRefetches` — sending `.selectPeriod(.third)` updates state and triggers a new fetch
- [ ] GREEN: verify selectPeriod reducer path passes
- [ ] RED: `testSelectGradeAndClass_UpdatesFilterAndRefetches` — `.selectGradeAndClass(grade:2, classNum:3)` updates selectedGrade/Class and triggers fetch
- [ ] GREEN: verify selectGradeAndClass reducer path passes
- [ ] RED: `testSaveAttendance_SetsIsSavingThenClearsOnSuccess` — `.saveAttendance` sets isSaving true; `.saveAttendanceResponse(.success)` clears it and resets baseline
- [ ] GREEN: verify saveAttendance reducer path passes
- [ ] RED: `testFetchStudents_FailureStopsLoading` — fetch failure clears isLoading, does not crash
- [ ] GREEN: verify failure path passes

---

## Phase 2 — Tidy First: structural wrapper removals

Each item below is a structural change. Run the relevant test target before and after to confirm no behavioral regression.

### 2-A  BugReport

- [ ] [STRUCTURAL] Verify `BugReportTests` green before change
- [ ] [STRUCTURAL] Remove `BugReportFeature.swift`; update `BugReportComponent.makeView()` to instantiate `BugReportView(store:)` directly
- [ ] [STRUCTURAL] Verify `BugReportTests` green after change — commit `chore[refact]: Remove BugReportFeature passthrough wrapper`

### 2-B  CheckSelfStudyTeacher

- [ ] [STRUCTURAL] Verify `CheckSelfStudyTeacherFeatureTests` green before change
- [ ] [STRUCTURAL] Remove `CheckSelfStudyTeacherFeature.swift`; update `CheckSelfStudyTeacherComponent.makeView()` to instantiate `CheckSelfStudyTeacherView(store:)` directly
- [ ] [STRUCTURAL] Verify `CheckSelfStudyTeacherFeatureTests` green after change — commit `chore[refact]: Remove CheckSelfStudyTeacherFeature passthrough wrapper`

### 2-C  SchoolMeal

- [ ] [STRUCTURAL] Verify `SchoolMealTests` green before change
- [ ] [STRUCTURAL] Remove `SchoolMealFeature.swift`; update `SchoolMealComponentImpl.makeSchoolMealView()` to instantiate `SchoolMealView(store:)` directly
- [ ] [STRUCTURAL] Verify `SchoolMealTests` green after change — commit `chore[refact]: Remove SchoolMealFeature passthrough wrapper`

### 2-D  SelfStudyCheck

- [ ] [STRUCTURAL] Verify `SelfStudyCheckTests` green before change (Phase 1 tests must all pass first)
- [ ] [STRUCTURAL] Apply `@Perception.Bindable var store: StoreOf<SelfStudyCheckReducer>` to `SelfStudyCheckView` (removes `let`, consistent with all other views)
- [ ] [STRUCTURAL] Remove `SelfStudyCheckFeature.swift`; update `SelfStudyCheckComponent.makeView()` to instantiate `SelfStudyCheckView(store:)` directly; remove `NavigationView` wrapper that belongs in a coordinator
- [ ] [STRUCTURAL] Verify `SelfStudyCheckTests` green after change — commit `chore[refact]: Remove SelfStudyCheckFeature passthrough wrapper and modernize View`

---

## Done criteria

- [ ] No `*Feature.swift` passthrough wrapper files exist in BugReport, CheckSelfStudyTeacher, SchoolMeal, SelfStudyCheck
- [ ] `grep -r "SelfStudyCheckFeature\|BugReportFeature\|CheckSelfStudyTeacherFeature\|SchoolMealFeature" --include="*.swift" Projects/Feature` returns only test/non-wrapper references
- [ ] All feature test targets pass
- [ ] `git diff --check` clean
