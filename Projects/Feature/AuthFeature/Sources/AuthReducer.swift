import ComposableArchitecture
import AuthDomainInterface

public struct AuthReducer: Reducer {
    private let loginUseCase: any LoginUseCase

    public init(loginUseCase: any LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    public struct State: Equatable {
        public var email = ""
        public var password = ""
        public init() {}
    }

    public enum Action {
        case emailChanged(String)
        case passwordChanged(String)
        case loginButtonTapped
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .emailChanged(email):
                state.email = email
                return .none
            case let .passwordChanged(password):
                state.password = password
                return .none
            case .loginButtonTapped:
                // Handle login logic here
                return .none
            }
        }
    }
}
