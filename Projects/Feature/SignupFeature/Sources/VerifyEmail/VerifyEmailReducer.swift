import ComposableArchitecture
import AuthDomainInterface

public struct VerifyEmailReducer: Reducer {
    public struct State: Equatable {
        public var secretKey: String
        
        public init(secretKey: String) {
            self.secretKey = secretKey
        }
    }

    public enum Action: Equatable {}

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            .none
        }
    }
}
