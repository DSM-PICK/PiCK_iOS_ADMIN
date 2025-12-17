import ComposableArchitecture

public struct ResignReducer: Reducer {
    public init() {}

    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case resignButtonTapped
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .resignButtonTapped:
                return .none
            }
        }
    }
}
