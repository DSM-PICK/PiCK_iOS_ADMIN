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
                return .run { [state] send in
                    await send(.loginResponse(await TaskResult {
                        for try await _ in self.loginUseCase.execute(
                            req: .init(
                                adminID: state.email,
                                password: state.password,
                                deviceToken: ""
                            )
                        ).values {}
                    }))
                }

            case .loginResponse(.success):
                return .none

            case .loginResponse(.failure):
                return .none
            }
        }
    }
}
