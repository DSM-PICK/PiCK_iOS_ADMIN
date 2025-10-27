import ComposableArchitecture
import AuthDomainInterface

public struct SigninReducer: Reducer {
    private let signinUseCase: any SigninUseCase

    public init(signinUseCase: any SigninUseCase) {
        self.signinUseCase = signinUseCase
    }

    public struct State: Equatable {
        public var email = ""
        public var password = ""
        public var isSigninSuccessful = false
        public init() {}
    }

    public enum Action {
        case emailChanged(String)
        case passwordChanged(String)
        case signinButtonTapped
        case signinResponse(TaskResult<Void>)
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
            case .signinButtonTapped:
                return .run { [state] send in
                    await send(.signinResponse(await TaskResult {
                        for try await _ in self.signinUseCase.execute(
                            req: .init(
                                adminID: state.email,
                                password: state.password,
                                deviceToken: ""
                            )
                        ).values {}
                    }))
                }

            case .signinResponse(.success):
                state.isSigninSuccessful = true
                return .none

            case .signinResponse(.failure):
                return .none
            }
        }
    }
}

