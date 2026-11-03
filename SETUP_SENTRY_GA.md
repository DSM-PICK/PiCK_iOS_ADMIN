# Sentry + Google Analytics(Firebase) 연동 가이드

Sentry 와 GA 는 **PROD 구성에서만** 동작합니다.

- DEV / STAGE 빌드에서는 Sentry 를 초기화하지 않습니다.
- DEV / STAGE 에서는 Analytics 수집도 꺼져 있고, 이벤트를 보낼 로거도 연결하지 않습니다.
- `FirebaseApp.configure()` 는 푸시 알림(FCM) 때문에 모든 구성에서 그대로 실행됩니다.
- 이 앱은 `GoogleService-Info.plist` 하나를 모든 구성이 같이 씁니다. 그래서 PROD 가 아닐 때 수집을 막는 것이 특히 중요합니다.

---

## 1. 빌드 전에 받아야 하는 비밀 파일

비밀 파일은 레포에 커밋하지 않습니다. 모두 `.gitignore` 에 들어 있습니다.

| 파일 | 받는 곳 | 넣을 위치 |
|---|---|---|
| `XCConfig/` 폴더 전체 | 비공개 레포 `DSM-PICK/PiCK_iOS_ADMIN_XCConfig` 의 `XCConfig/` | 레포 루트의 `XCConfig/` |
| `GoogleService-Info.plist` | 팀 Firebase 콘솔 (ADMIN 앱, 번들 ID `com.team.pick.PiCK-iOS-ADMIN`) 또는 팀원 | `Projects/App/Resources/Firebase/GoogleService-Info.plist` |
| Sentry DSN | Sentry 프로젝트 → Settings → Client Keys (DSN) | `XCConfig/PiCK_iOS_ADMIN/PROD.xcconfig` (아래 2번 참고) |

`Projects/App/Resources/Firebase/` 폴더가 없으면 `make generate` 와 빌드 스크립트가 바로 실패합니다.

```bash
git clone https://github.com/DSM-PICK/PiCK_iOS_ADMIN_XCConfig.git /tmp/admin-xcconfig && mv /tmp/admin-xcconfig/XCConfig ./XCConfig
```

---

## 2. xcconfig 에 추가할 줄

`XCConfig/PiCK_iOS_ADMIN/PROD.xcconfig` 에 아래 한 줄을 추가합니다. 이 파일은 비공개 XCConfig 레포에도 반영해 주세요.

```
SENTRY_DSN = https:/$()/<PUBLIC_KEY>@<ORG_HOST>.ingest.sentry.io/<PROJECT_ID>
```

- **`//` 를 그대로 쓰면 안 됩니다.** xcconfig 에서 `//` 는 주석으로 처리되기 때문에, `https://...` 라고 쓰면 값이 `https:` 에서 잘립니다.
- `$()` 는 빈 값으로 치환되는 변수라서 `https:/$()/` 가 빌드 후 `https://` 가 됩니다.
- `DEV.xcconfig` / `STAGE.xcconfig` 에는 추가하지 않습니다. 넣더라도 코드에서 PROD 가 아니면 Sentry 를 시작하지 않습니다.
- DSN 이 없거나 형식이 잘못돼도 앱은 죽지 않습니다. Sentry 초기화만 건너뜁니다 (`AppEnvironment.sentryDSN` 이 `nil`).

---

## 3. 빌드 순서 (Mac)

1. 도구를 설치합니다.
   ```bash
   mise install tuist@4.31.0
   ```
   ```bash
   brew install needle
   ```
2. 1번의 비밀 파일과 2번의 `SENTRY_DSN` 을 넣습니다.
3. 프로젝트를 생성합니다. 이 명령은 Needle → `tuist install` → `tuist generate` 를 차례로 실행합니다.
   ```bash
   make generate
   ```
   - `tuist install` 단계에서 sentry-cocoa 9.32.0 을 내려받고 `Tuist/Package.resolved` 가 바뀝니다. **바뀐 `Tuist/Package.resolved` 는 이 브랜치에 커밋해 주세요.** (Windows 에서 작업해 이 파일은 갱신하지 못했습니다.)
   - Feature 의 `Project.swift` 를 고쳤으므로 생성이 성공하는지 꼭 확인해 주세요.
4. 생성된 `PiCK_iOS_ADMIN.xcworkspace` 를 엽니다.
5. 스킴을 `PiCK_iOS_ADMIN-PROD` 로 고르고 실기기에서 실행합니다. DEV / STAGE 동작 확인은 `PiCK_iOS_ADMIN-DEV` / `-STAGE` 로 합니다.
   - Xcode 16 이상이 필요합니다 (Sentry 9.x 요구사항).
6. 테스트를 실행합니다. 이번에 이벤트 테스트를 추가한 Feature 가 모두 포함돼 있습니다.
   ```bash
   make test-all-features
   ```

빌드가 막히면 먼저 아래를 시도해 보세요.
```bash
make regenerate
```

---

## 4. 연동 확인 방법

### 4-1. Sentry 테스트 에러 보내기

1. 확인할 때만 `Projects/App/Sources/SentryConfiguration.swift` 의 `SentrySDK.start` 안에 `options.debug = true` 를 잠깐 추가합니다. 콘솔에 Sentry 로그가 찍힙니다.
2. 같은 파일의 `SentrySDK.start { ... }` 바로 아래에 테스트 코드를 잠깐 넣습니다.
   ```swift
   SentrySDK.capture(message: "Sentry 연동 테스트")
   ```
3. `PiCK_iOS_ADMIN-PROD` 스킴으로 실행합니다. Sentry 웹 → Issues 에서 `environment:production` 으로 필터해 메시지가 왔는지 봅니다.
4. 크래시 리포트도 보고 싶다면 `SentrySDK.crash()` 를 호출합니다. 주의할 점이 두 가지 있습니다.
   - **Xcode 디버거가 붙어 있으면 크래시가 잡히지 않습니다.** Xcode 에서 실행한 뒤 Stop 을 누르고, 홈 화면에서 앱을 직접 실행한 상태에서 크래시를 냅니다.
   - 크래시 리포트는 **앱을 다시 실행할 때** 전송됩니다.
5. 확인이 끝나면 `options.debug = true` 와 테스트 코드를 지웁니다.

DEV / STAGE 스킴으로 같은 테스트를 했을 때 Sentry 에 아무것도 오지 않으면 정상입니다.

### 4-2. Firebase DebugView 로 이벤트 확인하기

1. Xcode → Product → Scheme → Edit Scheme → Run → Arguments → **Arguments Passed On Launch** 에 `-FIRDebugEnabled` 를 추가합니다.
2. `PiCK_iOS_ADMIN-PROD` 스킴으로 실기기에서 실행합니다. 이 앱은 추적 허용 팝업(ATT)이 없습니다. IDFA 를 쓰지 않는 `FirebaseAnalyticsCore` 를 사용합니다.
3. Firebase 콘솔 → Analytics → **DebugView** 에서 기기를 선택하고 아래 이벤트를 확인합니다.

| 이벤트 | 발생 시점 | 파라미터 |
|---|---|---|
| `screen_view` | 화면 진입 | `screen_name` (예: `Home`, `Accept`, `SelfStudyCheck`) |
| `login` | 로그인 성공 | `method=id_password` |
| `application_decision` | 외출 / 교실이동 / 조기귀가 신청 수락·거절 | `application_type` (`outing` / `classroom_move` / `early_return`), `decision` (`approve` / `reject`), `source` (`home` / `accept_list`), `result` (`success` / `fail`) |
| `attendance_save` | 자습 출석 저장 | `result` |
| `student_return` | 외출 학생 복귀 처리 | `result` |
| `bug_report_submit` | 버그 제보 | `result` |

4. 확인이 끝나면 `-FIRDebugEnabled` 를 지우거나 체크를 끕니다.
5. DEV / STAGE 스킴에서는 DebugView 에 아무 이벤트도 오지 않아야 합니다.

새 이벤트를 추가하는 방법은 다음과 같습니다.

1. `Projects/Shared/Utility/Sources/Analytics/AnalyticsEvent.swift` 에 case 를 추가합니다.
2. Reducer 에서 `AnalyticsService.log(.새이벤트)` 를 부릅니다.
3. Reducer 파일에서는 `import Utility` 대신 아래처럼 필요한 타입만 import 합니다. Utility 와 디자인 시스템(PiCK_iOS_DesignSystem)에 같은 이름의 `SuccessType` 이 있어서, 통째로 import 하면 이름 충돌이 날 수 있기 때문입니다.
   ```swift
   import enum Utility.AnalyticsService
   import enum Utility.AnalyticsEvent
   ```

---

## 5. dSYM 업로드 (Sentry 크래시 심볼리케이션)

dSYM 이 없으면 Sentry 크래시 스택이 주소로만 보입니다. **auth token 은 코드나 레포에 넣지 않습니다.**

1. Sentry → Settings → Auth Tokens 에서 `project:releases` 권한이 있는 토큰을 만듭니다 (Organization Token 권장).
2. 방법 A: 아카이브 후 수동 업로드
   ```bash
   brew install getsentry/tools/sentry-cli
   ```
   ```bash
   SENTRY_AUTH_TOKEN=<TOKEN> sentry-cli debug-files upload --org <ORG_SLUG> --project <PROJECT_SLUG> --include-sources <Archive 안의 dSYMs 폴더 경로>
   ```
   - Archive 위치: Xcode → Organizer → 아카이브 우클릭 → Show in Finder → `.xcarchive` 패키지 내용 보기 → `dSYMs/`
3. 방법 B: Xcode Cloud 에서 자동 업로드
   - Xcode Cloud 워크플로 환경 변수에 `SENTRY_AUTH_TOKEN` 을 **Secret** 으로 등록합니다.
   - `ci_scripts/ci_post_xcodebuild.sh` 를 만들고, `$CI_ARCHIVE_PATH/dSYMs` 를 위 명령으로 업로드합니다.
   - 이 스크립트는 이번 작업에 포함하지 않았습니다. 필요하면 별도로 추가해 주세요.
4. PROD(Release) 구성의 `DEBUG_INFORMATION_FORMAT` 은 `dwarf-with-dsym` 이어야 합니다.

---

## 6. 이번 작업에서 바뀐 동작

- **Sentry 와 Firebase Analytics 는 앱 타깃에만 연결했습니다.** 기존 `FirebaseMessaging` 과 같은 방식입니다. 동적 프레임워크(ThirdPartyLib, Utility)에 정적 SDK 를 넣으면 앱과 프레임워크에 같은 SDK 가 두 번 들어갈 수 있어서입니다.
- Feature 모듈은 Firebase 를 모릅니다.
  - Utility 의 `AnalyticsService` 에 이벤트를 보내기만 합니다.
  - 앱이 PROD 에서만 `FirebaseAnalyticsLogger` 를 연결합니다.
- `Tuist/Package.swift` 의 `FirebaseAnalyticsWithoutAdIdSupport` 를 `FirebaseAnalyticsCore` 로 바꿨습니다. Firebase 12.x 에는 `FirebaseAnalyticsWithoutAdIdSupport` 제품이 없습니다.
- Info.plist 에 `FIREBASE_ANALYTICS_COLLECTION_ENABLED = false` 를 넣었습니다. 다만 Firebase 는 `setAnalyticsCollectionEnabled` 값을 앱 재실행 후에도 유지하고 plist 보다 우선합니다. 그래서 앱을 실행할 때마다 `FirebaseApp.configure()` **전에** 현재 구성 기준(PROD 일 때만 켜기)으로 덮어씁니다.
- Firebase 자동 화면 추적(`FirebaseAutomaticScreenReportingEnabled`)을 껐습니다. SwiftUI 화면은 `UIHostingController` 이름으로만 잡히기 때문입니다. 대신 각 Component 에서 `.trackScreen("화면이름")` 으로 기록합니다.
- 수락과 거절은 같은 응답 액션(`updateStatusResponse`)을 쓰기 때문에, 요청을 보내는 시점에 `decision` 을 붙여서 기록합니다.

---

## 7. 빌드할 때 특히 봐야 할 곳 (Windows 에서 작성해 빌드·테스트로 확인하지 못한 부분)

1. **`make generate` 성공 여부.**
   - `Tuist/Package.swift`, `Projects/App/Project.swift`, Feature 5개의 `Project.swift` 를 고쳤습니다.
   - `.external(name: "Sentry")`, `.external(name: "FirebaseAnalyticsCore")` 가 해석되는지 확인해 주세요.
2. **`import FirebaseAnalytics` 가 `FirebaseAnalyticsCore` 제품으로도 되는지** (`FirebaseAnalyticsLogger.swift`). Firebase 12.5.0 의 Package.swift 기준으로 같은 `FirebaseAnalytics` 바이너리를 쓰는 것을 확인했지만, 실제로 빌드해 보지는 못했습니다.
3. **Sentry 9.x 옵션 이름.** `releaseName`, `environment`, `sendDefaultPii`, `tracesSampleRate` 가 컴파일되는지 확인해 주세요.
4. **scoped import** (`import enum Utility.AnalyticsService`) 가 Reducer 와 테스트 파일에서 문제없이 컴파일되는지. 안 되면 `import Utility` 로 바꾸고, `SuccessType` 이 모호하다는 오류가 나는 곳만 `PiCK_iOS_DesignSystem.SuccessType` 처럼 앞에 모듈 이름을 붙여 주세요.
5. **`FirebaseApp.configure()` 전에 `Analytics.setAnalyticsCollectionEnabled` 를 부르는 부분** (`PiCK_iOS_ADMINApp.swift`). 공식 문서에 순서 제약은 없지만, 콘솔에 "not configured" 같은 오류가 나오거나 값이 적용되지 않으면 `AnalyticsConfiguration.applyCollectionState()` 를 `FirebaseApp.configure()` 바로 다음 줄로 옮겨 주세요.
6. **새로 추가한 테스트.**
   - `store.exhaustivity = .off`, `store.finish()`, `addTeardownBlock` 으로 작성했습니다.
   - `make test-all-features` 에서 기존 테스트를 포함해 모두 통과하는지 확인해 주세요.
   - 실패하면 `feat[red]` / `feat[green]` 커밋 중 어느 쪽 문제인지 알려주세요.
7. **`screen_view` 화면 이름.** 탭 전환과 push 할 때 DebugView 에 의도한 이름으로 한 번씩 찍히는지 확인해 주세요. 신청 수락 화면은 `NavigationView` 바깥에 붙였습니다.
8. **Xcode Cloud.** `ci_scripts/ci_post_clone.sh` 에서 Firebase 폴더를 받아오는 부분이 주석 처리돼 있습니다. 이번 작업 전부터 그랬지만, CI 빌드가 Firebase 폴더 검사에서 막힐 수 있습니다.
