import ComposableArchitecture
import AuthDomainInterface

public struct VerifyEmailReducer: Reducer {
//    private let secretKeyUseCase: any SecretKeyUseCase
//
//    public init(secretKeyUseCase: any SecretKeyUseCase) {
//        self.secretKeyUseCase = secretKeyUseCase
//    }

    public struct State: Equatable {
        public var secretKey = ""
        public var email = ""
        public var code = ""

        public init(secretKey: String) {
            self.secretKey = secretKey
        }
    }

    public enum Action: Equatable {
        case emailChanged(String)
        case codeChanged(String)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .emailChanged(email):
                state.email = email
                return .none
            case let .codeChanged(code):
                state.code = code
                return .none
            }
        }
    }
}
