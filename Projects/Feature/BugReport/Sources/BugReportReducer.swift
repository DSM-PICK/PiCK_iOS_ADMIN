import ComposableArchitecture
import Foundation

public struct BugReportReducer: Reducer {
    public init() {}

    public struct State: Equatable {
        public var bugLocation: String = ""

        public init() {}
    }

    public enum Action {
        case bugLocationChanged(String)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .bugLocationChanged(text):
                state.bugLocation = text
                return .none
            }
        }
    }
}
