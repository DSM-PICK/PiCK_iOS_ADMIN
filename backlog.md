# PiCK_iOS_ADMIN — 개발 백로그

> 작업 항목은 우선순위 순으로 정렬. 이슈 번호로 추적.

---

## 진행 중

| 이슈 | 제목 | 브랜치 | 상태 |
|---|---|---|---|
| [#140](https://github.com/DSM-PICK/PiCK_iOS_ADMIN/issues/140) | Needle DI 의존성 그래프 재설계 | `feature/(#140)-di_graph_redesign` | 🔄 진행 중 |

---

## 대기 (우선순위 순)

### DI / 아키텍처

| 이슈 | 제목 | 우선순위 | 메모 |
|---|---|---|---|
| #140 | Feature-to-Feature 직접 의존 제거 | P1 | AllTabView 8개 concrete import → Factory |
| #140 | AllTabDependency God 프로토콜 분해 | P1 | 17 use case → 각 Feature Component 직접 소유 |
| #140 | HomeDependency Factory 참조 제거 | P2 | AllTabFactory 등 AppComponent 레벨로 이동 |
| #140 | AppComponent 12개 Dependency 준수 → 슬림화 | P2 | SignupFlowComponent 그룹화 포함 |
| #140 | SelfStudyCheck → AcceptFeature 데드 임포트 제거 | P0 | 코드 1줄 삭제, 즉시 가능 |

### 테스트 커버리지

| 이슈 | 제목 | 대상 |
|---|---|---|
| - | BugReportFeature 테스트 작성 | BugReportReducer |
| - | HomeFeature 테스트 작성 | HomeReducer |
| - | AcceptFeature 테스트 작성 | AcceptReducer |
| - | CheckSelfStudyTeacherFeature 테스트 작성 | Reducer |

### TCA 현대화 (TCA rollout 잔여분)

| 이슈 | 제목 | 대상 |
|---|---|---|
| - | SchoolMealFeature @Perception 전환 확인 | SchoolMealView |
| - | PlanFeature @Perception 전환 확인 | PlanView |

---

## 완료

| 이슈 | 제목 | PR |
|---|---|---|
| #135 | TCA Feature 래퍼 제거 및 TDD 워크플로우 구축 | [#139](https://github.com/DSM-PICK/PiCK_iOS_ADMIN/pull/139) |
| #135 | TCA 1.x modernization rollout | [#137](https://github.com/DSM-PICK/PiCK_iOS_ADMIN/pull/137) |
| #136 | Tuist feature manifest boilerplate 축소 | [#138](https://github.com/DSM-PICK/PiCK_iOS_ADMIN/pull/138) |

---

## 기술 부채

| 항목 | 심각도 | 메모 |
|---|---|---|
| `AllTabDomain`의 `GetMyNameUseCase` — 경계 모호 | 낮음 | User/Profile 도메인이 더 적절하나 Domain 재편 시 처리 |
| NeedleGenerated.swift 60+ import | 증상 | P1~P3 해결 시 자동 개선됨 |
| Signup 4개 Component → SignupFlowComponent 그룹화 | 낮음 | AppComponent 슬림화 시 함께 처리 |
