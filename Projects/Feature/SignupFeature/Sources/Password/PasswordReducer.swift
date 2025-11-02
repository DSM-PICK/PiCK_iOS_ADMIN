import ComposableArchitecture
import AuthDomainInterface

public struct PasswordReducer: Reducer {
    public struct State: Equatable {
        public var secretKey = ""
        public var accountId = ""
        public var code = ""
        public var password = ""
        public var passwordConfirm = ""

        public init(secretKey: String = "", accountId: String = "", code: String = "") {
            self.secretKey = secretKey
            self.accountId = accountId
            self.code = code
        }
    }
    
    public enum Action {
        case passwordChanged(String)
        case passwordConfirmChanged(String)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .passwordChanged(password):
                state.password = password
                return .none
            case let .passwordConfirmChanged(password):
                state.passwordConfirm = password
                return .none
            }
        }
    }
}
