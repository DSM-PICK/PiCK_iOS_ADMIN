import ComposableArchitecture

@Reducer
public struct OnboardingReducer: Reducer {
    public init() {}

    @ObservableState
    public struct State: Equatable {
        public var shouldNavigateToSignin: Bool

        public init(shouldNavigateToSignin: Bool = false) {
            self.shouldNavigateToSignin = shouldNavigateToSignin
        }
    }

    public enum Action: Equatable {
        case loginButtonTapped
        case signinNavigationHandled
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loginButtonTapped:
                state.shouldNavigateToSignin = true
                return .none

            case .signinNavigationHandled:
                state.shouldNavigateToSignin = false
                return .none
            }
        }
    }
}
