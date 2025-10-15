
import ComposableArchitecture

public struct HomeReducer: Reducer {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        // Add actions here
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
