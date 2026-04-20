import XCTest
import ComposableArchitecture
@testable import OnboardingFeature

@MainActor
final class OnboardingFeatureTests: XCTestCase {
    func testInitialState_HasNoPendingNavigation() {
        let state = OnboardingReducer.State()

        XCTAssertFalse(state.shouldNavigateToSignin)
    }

    func testLoginButtonTapped_RequestsSigninNavigation() async {
        let store = makeStore()

        await store.send(.loginButtonTapped) {
            $0.shouldNavigateToSignin = true
        }
    }

    func testSigninNavigationHandled_ClearsPendingNavigation() async {
        let store = makeStore(
            initialState: OnboardingReducer.State(shouldNavigateToSignin: true)
        )

        await store.send(.signinNavigationHandled) {
            $0.shouldNavigateToSignin = false
        }
    }

    func testLoginFlow_CanRequestSigninNavigationAgainAfterHandling() async {
        let store = makeStore()

        await store.send(.loginButtonTapped) {
            $0.shouldNavigateToSignin = true
        }
        await store.send(.signinNavigationHandled) {
            $0.shouldNavigateToSignin = false
        }
        await store.send(.loginButtonTapped) {
            $0.shouldNavigateToSignin = true
        }
    }

    private func makeStore(
        initialState: OnboardingReducer.State = OnboardingReducer.State()
    ) -> TestStore<OnboardingReducer.State, OnboardingReducer.Action> {
        TestStore(initialState: initialState) {
            OnboardingReducer()
        }
    }
}
