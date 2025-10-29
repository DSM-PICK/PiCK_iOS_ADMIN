import ComposableArchitecture
import AuthDomainInterface

public struct SecretKeyReducer: Reducer {
    private let secretKeyUseCase: any SecretKeyUseCase

    public init(secretKeyUseCase: any SecretKeyUseCase) {
        self.secretKeyUseCase = secretKeyUseCase
    }

    public struct State: Equatable {
        public var secretKey = ""
        public var isSigninSuccessful = false
        public var errorMessage: String? = nil
        public init() {}
    }

    public enum Action {
        case secretKeyChanged(String)
        case nextButtonTapped
        case secretKeyResponse(TaskResult<Bool>)
        case clearError
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .secretKeyChanged(secretKey):
                state.secretKey = secretKey
                return .none
            case .nextButtonTapped:
                return performSecretKey(with: state)
            case let .secretKeyResponse(.success(isValid)):
                state.isSigninSuccessful = isValid
                return .none
            case let .secretKeyResponse(.failure(error)):
                let authError = error as? AuthDomainInterface.AuthError ?? .clientError
                state.errorMessage = authError.errorDescription
                return .none
            case .clearError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}

extension SecretKeyReducer {
    private func performSecretKey(with state: State) -> Effect<Action> {
        .run { send in
            await send(.secretKeyResponse(
                await TaskResult<Bool> {
                    for try await _ in secretKeyUseCase.execute(
                        req: .init(secretKey: state.secretKey)
                    ).values {}
                    return true
                }
            ))
        }
    }
}
