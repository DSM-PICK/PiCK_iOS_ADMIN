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

## Phase 0 — 데드 코드 제거 (Structural, 즉시 가능) ✅

- [x] `SelfStudyCheckView.swift`에서 `import AcceptFeature` 제거
- [x] `SelfStudyCheck/Project.swift`에서 `.Features.acceptFeature` 제거
- [x] 빌드 검증: `make test SCHEME=SelfStudyCheckFeature` (6개 테스트 통과)

커밋: `chore[refact]: Remove dead AcceptFeature import from SelfStudyCheckView`

---

## Phase 1 — AllTabView Factory 주입 전환 (핵심, 빌드 캐스케이드 차단) ✅

> AllTabView가 8개 Feature를 concrete import하는 구조를 Factory 프로토콜 주입으로 전환.
> AllTabFeature는 자기 도메인(AllTabDomainInterface)만 알고, 하위 Feature들의 View는 Factory를 통해 받는다.

### 1-0. ChangePassword Factory 프로토콜 Interface로 이동 ✅
- [x] `ChangePasswordFactory`, `NewPasswordFactory`를 Interface 모듈로 이동
- [x] `NewPasswordFactory.makeView`에 `onSuccess` 파라미터 추가

커밋: `chore[refact]: Move ChangePassword/NewPassword factory protocols to Interface`

### 1-0b. AllTabFeature 패스스루 래퍼 삭제 ✅
- [x] `AllTabFeature.swift` 삭제 (SelfStudyCheckFeature.swift와 동일 패턴)
- [x] `AllTabComponent.makeView()`가 `AllTabView`를 직접 호출하도록 수정

커밋: `chore[refact]: Delete AllTabFeature passthrough wrapper`

### 1-1. AllTabView에 Factory 파라미터 추가 [RED] ✅
- [x] `AllTabView` 생성자에 8개 Factory 파라미터 추가 (WithPerceptionTracking, @Perception.Bindable)
- [x] concrete Feature import 제거, FeatureInterface import로 교체
- [x] AllTabReducer.State에 @ObservableState 추가

커밋: `feat[red]: AllTabView receives sub-feature factories instead of concrete imports`

### 1-2. AllTabComponent에서 Factory 주입 구현 [GREEN] ✅
- [x] `AllTabDependency` — use case 17개 → factory 8개 + 자체 2개로 교체
- [x] `AllTabComponent.makeView()` — factories를 AllTabView에 주입
- [x] `AllTabFeature/Project.swift` — concrete Feature 의존 제거, FeatureInterface 의존만 유지

커밋: `feat[green]: Wire AllTabComponent to inject sub-feature factories`

### 1-3. AllTabComponent를 각 Feature Component의 부모로 재편 ✅
- [x] AllTabComponent.swift를 AllTabFeature → App 타겟으로 이동 (concrete import 허용)
- [x] AllTabDependency: getMyNameUseCase + authRepository만 유지 (factory 요구 제거)
- [x] AllTabComponent에서 8개 자식 Component 직접 생성 (`parent: self`)
- [x] AppComponent: CheckSelfStudyTeacherDependency 등 7개 Dependency 준수 제거
- [x] AppComponent: 8개 factory 프로퍼티 제거 (AllTabComponent가 직접 담당)
- [x] NeedleGenerated.swift 재생성: `^->AppComponent->AllTabComponent->*Component` 경로 반영

커밋: `chore[refact]: Move tab-feature components under AllTabComponent`

---

## Phase 2 — AllTabDependency 분해 (God Dependency 해소) ✅

> AllTabDependency의 17개 use case → 8개 factory + 2개 자체 도메인으로 교체 (Phase 1-2에서 완료).
> AppComponent 확장 파일의 dead import 제거.

### 2-1. 각 하위 Feature Dependency 프로토콜 정리 ✅
- [x] 모든 하위 Feature Dependency 프로토콜이 이미 자기 Domain use case만 보유

### 2-2. AppComponent 확장 파일 dead import 제거 ✅
- [x] `AppComponent+SelfStudyCheck.swift` — `NeedleFoundation`, `SwiftUI`, `SelfStudyCheckFeature` 제거
- [x] `AppComponent+OutList.swift` — `NeedleFoundation`, `SwiftUI`, `OutListFeature`, `OutListFeatureInterface` 제거
- [x] `AppComponent+ClassroomMoveList.swift` — `NeedleFoundation`, `SwiftUI`, `ClassroomMoveListFeature`, `ClassroomMoveListFeatureInterface` 제거
- [x] `AppComponent+OutingHistory.swift` — `NeedleFoundation`, `SwiftUI`, `OutingHistoryFeature`, `OutingHistoryFeatureInterface` 제거
- [x] `AppComponent+ChangePassword.swift` — `NeedleFoundation`, `ChangePasswordFeature` 제거
- [x] `AllTabDependency`에서 하위 Feature 관련 use case 제거 (Phase 1-2에서 완료)

커밋: `chore[refact]: Remove dead Feature imports and modernize Plan/SchoolMeal TCA pattern`

---

## Phase 3 — HomeDependency 정리 (AppComponent 슬림화) ✅ (dead import 부분)

> HomeFeature가 AllTab/Plan/SchoolMeal/Accept Factory를 알고 있는 구조 개선.

### 3-0. PlanView/SchoolMealView dead HomeFeature import 제거 ✅
- [x] `PlanView.swift`에서 `import HomeFeature` 제거 + WithPerceptionTracking 전환
- [x] `SchoolMealView.swift`에서 `import HomeFeature` 제거 + WithPerceptionTracking 전환
- [x] `PlanReducer.State`, `SchoolMealReducer.State`에 `@ObservableState` 추가

### 3-1. HomeDependency Project.swift 의존성 정리 ✅
- [x] `HomeDependency` factory 4개 유지 (TabBarView에서 탭별 View 생성에 필요)
- [x] `HomeFeature/Project.swift`에 누락된 의존성 추가 (acceptFeatureInterface, acceptDomainInterface, classroomMoveListDomainInterface, outListDomainInterface)
- [x] `HomeComponent.swift`에서 dead `import AllTabDomainInterface` 제거
- [x] `HomeReducer.State`에 `@ObservableState` 추가
- [x] `HomeView.swift` WithViewStore → WithPerceptionTracking 전환

커밋: `chore[refact]: Fix HomeFeature Project.swift deps and modernize HomeView TCA pattern`

### 3-2. AppComponent Dependency 준수 축소 ✅
- [x] `HomeComponent`를 App 타겟으로 이동 (PlanComponent/SchoolMealComponent/AcceptComponent를 parent: self로 생성)
- [x] `HomeDependency`에서 planFactory/schoolMealFactory/acceptFactory 제거
- [x] `AppComponent+Plan.swift`에서 `planFactory` 제거
- [x] `AppComponent+SchoolMeal.swift`에서 `schoolMealFactory` 제거
- [x] `AppComponent`에서 PlanDependency/SchoolMealDependency/AcceptDependency 제거, acceptFactory 제거
- [x] `AppComponent` 준수 수: HomeDependency + AllTabDependency (2개)
- [x] `make needle` 후 경로 검증: `^->AppComponent->HomeComponent->PlanComponent` 등 확인
- [x] NeedleGenerated.swift import 수: 64개 (Feature 모듈 수에 비례하므로 현재 아키텍처 한계)

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
