import ComposableArchitecture
import AuthDomainInterface

public struct SigninReducer: Reducer {
    private let loginUseCase: any LoginUseCase

    public init(loginUseCase: any LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    public struct State: Equatable {
        public var email = ""
        public var password = ""
        public var isLoginSuccessful = false
        
        public init() {}
    }

    public enum Action {
        case emailChanged(String)
        case passwordChanged(String)
        case loginButtonTapped
        case loginResponse(TaskResult<Void>)
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
                return performLogin(with: state)
                
            case .loginResponse(.success):
                state.isLoginSuccessful = true
                return .none
                
            case .loginResponse(.failure):
                return .none
            }
        }
    }
    
    private func performLogin(with state: State) -> Effect<Action> {
        .run { send in
            await send(.loginResponse(
                await TaskResult {
                    for try await _ in loginUseCase.execute(
                        req: .init(
                            adminID: state.email,
                            password: state.password,
                            deviceToken: ""
                        )
                    ).values {}
                }
            ))
        }
    }
}
