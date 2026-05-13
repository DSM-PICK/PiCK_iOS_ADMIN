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

## PR / Issue Convention

### Branch naming
```
feature/(#이슈번호)-slug
예: feature/(#135)-tca_rollout
```

### PR 제목
```
[#이슈번호] 한국어 작업 요약
예: [#135] TCA Feature 래퍼 제거 및 TDD 워크플로우 구축
```

### PR 본문 (필수 섹션)
```markdown
## 개요
- #이슈번호 작업 설명입니다.
- 주요 변경 내용 한 줄 요약
- Closes #이슈번호

## 작업사항
- 변경 항목 1
- 변경 항목 2

## UI
- 없음  (UI 변경 없을 때)
```

### 레이블 (택 1~2)
| 레이블 | 용도 |
|---|---|
| `✨feat` | 새로운 기능 |
| `♻️refactor` | 리팩토링 |
| `👾bug` | 버그 수정 |
| `⚙️setting` | 프로젝트 설정 변경 |
| `📝docs` | 문서 추가·변경 |
| `🛠️chore` | 기타 코드 수정 |

### Assignee / Reviewer
- Assignee: 작업자 본인 (`leejh08`)
- Reviewer: `circle0802`, `xnlwe09`

### gh CLI (주의: `gh pr edit`는 GraphQL 오류를 냄 — REST API 직접 사용)
```bash
# 1. PR 생성
gh pr create --base develop --title "[#번호] 제목" --body "..."

# 2. Assignee
gh api repos/DSM-PICK/PiCK_iOS_ADMIN/issues/{PR번호}/assignees \
  -X POST --input - <<< '{"assignees":["leejh08"]}'

# 3. Reviewer
gh api repos/DSM-PICK/PiCK_iOS_ADMIN/pulls/{PR번호}/requested_reviewers \
  -X POST --input - <<< '{"reviewers":["circle0802","xnlwe09"]}'

# 4. Label
gh api repos/DSM-PICK/PiCK_iOS_ADMIN/issues/{PR번호}/labels \
  -X POST --input - <<< '{"labels":["✨feat"]}'
```

---

## Verification Checklist (before any commit)

- [ ] `git diff --check` clean
- [ ] All test targets build and pass
- [ ] No `ViewStore`, `WithViewStore`, `IfLetStore`, `SwitchStore`, `@ObservedObject` in changed files
- [ ] For manifest / Project.swift changes: `tuist generate --no-open`
