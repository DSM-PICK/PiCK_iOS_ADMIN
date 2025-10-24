import ComposableArchitecture

public struct OnboardingReducer: Reducer {

    public init() {}

    public struct State: Equatable {
        public init() {}
    }
  
    public enum Action {
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
