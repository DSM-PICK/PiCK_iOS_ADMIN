import ComposableArchitecture

public struct OnboardingReducer: Reducer {

    public init() {}

    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case nextButtonTapped
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                return .none
            }
        }
    }
}
