# #140 — Needle DI 의존성 그래프 재설계 플랜

> TDD + Tidy First 원칙 준수. 매 커밋마다 빌드 가능 상태 유지.
> `go` 입력 시 다음 미완료 항목을 진행.

---

## 진단 요약

```
현재 의존 그래프 (문제 부분만):

AllTabFeature ──concrete──▶ HomeFeature
              ──concrete──▶ BugReportFeature
              ──concrete──▶ CheckSelfStudyTeacherFeature
              ──concrete──▶ ChangePasswordFeature
              ──concrete──▶ ClassroomMoveListFeature
              ──concrete──▶ OutListFeature
              ──concrete──▶ OutingHistoryFeature
              ──concrete──▶ SelfStudyCheckFeature  (← 이 안에 AcceptFeature 데드 임포트)

HomeFeature ──interface──▶ AllTabFeatureInterface
            ──interface──▶ PlanFeatureInterface
            ──interface──▶ SchoolMealFeatureInterface
            ──interface──▶ AcceptFeatureInterface  ← 제거 대상

AppComponent ──conforms──▶ 12개 Dependency 프로토콜 (전부 직접)
```

---

## Phase 0 — 데드 코드 제거 (Structural, 즉시 가능)

- [ ] `SelfStudyCheckView.swift`에서 `import AcceptFeature` 제거
- [ ] `SelfStudyCheck/Project.swift`에서 `.Features.acceptFeature` 제거
- [ ] 빌드 검증: `make test SCHEME=SelfStudyCheckFeature`

커밋: `chore[refact]: Remove dead AcceptFeature import from SelfStudyCheckView`

---

## Phase 1 — AllTabView Factory 주입 전환 (핵심, 빌드 캐스케이드 차단)

> AllTabView가 8개 Feature를 concrete import하는 구조를 Factory 프로토콜 주입으로 전환.
> AllTabFeature는 자기 도메인(AllTabDomainInterface)만 알고, 하위 Feature들의 View는 Factory를 통해 받는다.

### 1-1. AllTabFeatureInterface에 하위 Feature Factory 프로토콜 추가 [RED]
- [ ] `AllTabDependency`에 필요한 Factory 타입 정의 (또는 기존 FeatureInterface 활용)
- [ ] `AllTabView` 생성자에 Factory 파라미터 추가 (컴파일 에러 상태 허용)

커밋: `feat[red]: AllTabView receives sub-feature factories instead of concrete imports`

### 1-2. AllTabComponent에서 Factory 주입 구현 [GREEN]
- [ ] `AllTabComponent.makeView()`에서 Factory 파라미터 주입
- [ ] `AllTabView.swift`에서 8개 concrete Feature import 제거
- [ ] `AllTabFeature/Project.swift`에서 8개 Feature 의존 제거, Factory Interface 의존만 유지
- [ ] 빌드 검증

커밋: `feat[green]: Wire AllTabComponent to inject sub-feature factories`

### 1-3. AllTabComponent를 각 Feature Component의 부모로 재편 [GREEN]
- [ ] BugReportComponent, CheckSelfStudyTeacherComponent, SelfStudyCheckComponent 등을 AllTabComponent 자식으로 이동
- [ ] AppComponent에서 해당 Feature 직접 생성 제거
- [ ] NeedleGenerated.swift 재생성: `make needle`
- [ ] 전체 빌드 검증

커밋: `chore[refact]: Move tab-feature components under AllTabComponent`

---

## Phase 2 — AllTabDependency 분해 (God Dependency 해소)

> AllTabDependency의 17개 use case를 각 하위 Feature Component가 직접 소유하도록 분리.

### 2-1. 각 하위 Feature Dependency 프로토콜 정리 [REFACT]
- [ ] `CheckSelfStudyTeacherDependency`: 자기 Domain use case만 보유 확인
- [ ] `BugReportDependency`: 자기 Domain use case만 보유 확인
- [ ] `SelfStudyCheckDependency`: 자기 Domain use case만 보유 확인
- [ ] `OutListDependency`: 자기 Domain use case만 보유 확인
- [ ] `ClassroomMoveListDependency`: 자기 Domain use case만 보유 확인
- [ ] `OutingHistoryDependency`: 자기 Domain use case만 보유 확인

### 2-2. AppComponent에서 중복 use case 제공 제거 [REFACT]
- [ ] 각 Feature Component가 직접 Domain을 인스턴스화하도록 `AppComponent+*.swift` 정리
- [ ] `AllTabDependency`에서 하위 Feature 관련 use case 모두 제거
- [ ] `make needle` 후 빌드 검증

커밋: `chore[refact]: Decompose AllTabDependency — each feature owns its domain`

---

## Phase 3 — HomeDependency 정리 (AppComponent 슬림화)

> HomeFeature가 AllTab/Plan/SchoolMeal/Accept Factory를 알고 있는 구조 개선.
> Factory 주입은 AppComponent 레벨에서 조율.

### 3-1. HomeDependency에서 Factory 제거 [RED → GREEN]
- [ ] `HomeDependency`에서 `allTabFactory`, `planFactory`, `schoolMealFactory`, `acceptFactory` 제거
- [ ] `HomeFeature`가 Factory 대신 AppComponent 레벨 조율로 전환
- [ ] `HomeFeature/Project.swift`에서 Feature Interface 의존 제거
- [ ] 빌드 검증

커밋: `chore[refact]: Remove sibling factory references from HomeDependency`

### 3-2. AppComponent Dependency 준수 축소
- [ ] `AppComponent`의 Dependency 준수 목록 확인 및 불필요한 것 제거
- [ ] `make needle` 후 빌드 검증
- [ ] NeedleGenerated.swift import 수 측정 (목표: 30개 이하)

커밋: `chore[refact]: Slim down AppComponent dependency conformances`

---

## Phase 4 — SignupFlowComponent 그룹화 (선택적)

> SecretKey, VerifyEmail, Password, InfoSetting 4개가 AppComponent 직접 자식인 구조 개선.

- [ ] `SignupFlowComponent` 신규 생성
- [ ] 4개 Signup Component를 SignupFlowComponent 자식으로 이동
- [ ] AppComponent에서 SignupFlowComponent 하나만 참조
- [ ] `make needle` 후 빌드 검증

커밋: `chore[refact]: Group signup flow under SignupFlowComponent`

---

## Done 기준

- [ ] Feature → Feature concrete import 0개 (`grep -r "import.*Feature" Projects/Feature --include="*.swift" | grep -v "Interface\|BaseFeature"` 결과 없음)
- [ ] `AllTabDependency` use case 수 ≤ AllTab 자체 도메인 것만
- [ ] `AppComponent` Dependency 프로토콜 준수 수 ≤ 4개
- [ ] NeedleGenerated.swift import 수 ≤ 30개
- [ ] `make test-all-features` 전체 통과
- [ ] `tuist generate --no-open` 성공
