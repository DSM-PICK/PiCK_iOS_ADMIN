# OnboardingFeature

## TCA rollout 메모

- `OnboardingReducer`가 로그인 버튼 탭과 네비게이션 소비 상태를 관리합니다.
- 로그인 버튼 탭 시 `shouldNavigateToSignin`를 `true`로 변경합니다.
- `OnboardingView`는 `shouldNavigateToSignin` 변경을 감지해 `router.path.append(.signin)`을 수행한 뒤
  `signinNavigationHandled` 액션으로 플래그를 즉시 정리합니다.
- 이 구조로 온보딩 화면이 다시 그려져도 중복 네비게이션 상태가 남지 않습니다.

## 검증 포인트

- 초기 상태에서 이동 플래그는 `false`여야 합니다.
- 로그인 버튼 탭 후 Signin 이동 요청이 발생해야 합니다.
- 이동 처리 후 플래그가 `false`로 복구되어 다음 로그인 시도를 다시 처리할 수 있어야 합니다.

## 이번 점검 범위

- OnboardingFeature 내부 TCA reducer / view 흐름
- OnboardingFeature 단위 테스트 및 lint
- Signin 이동 플래그 reset 계약 문서화
