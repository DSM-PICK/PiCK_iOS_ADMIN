import ComposableArchitecture

public struct WithDrawReducer: Reducer {
    public init() {}

    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case withdrawButtonTapped
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .withdrawButtonTapped:
                // TODO: API 연동 시 구현
                return .none
            }
        }
    }
}
