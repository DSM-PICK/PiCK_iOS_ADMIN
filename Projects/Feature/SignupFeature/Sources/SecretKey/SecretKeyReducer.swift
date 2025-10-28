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
        public init() {}
    }

    public enum Action {
        case secretKeyChanged(String)
        case nextButtonTapped
        case secretKeyResponse(TaskResult<Void>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .secretKeyChanged(secretKey):
                state.secretKey = secretKey
                return .none
            case .nextButtonTapped:
                return performSecretKey(with: state)
            case .secretKeyResponse(.success):
                state.isSigninSuccessful = true
                return .none
            case .secretKeyResponse(.failure):
                return .none
            }
        }
    }
}

extension SecretKeyReducer {
    private func performSecretKey(with state: State) -> Effect<Action> {
        .run { send in
            await send(.secretKeyResponse(
                await TaskResult {
                    for try await _ in secretKeyUseCase.execute(
                        req: .init(
                            secretKey: state.secretKey
                        )
                    ).values {}
                }
            ))
        }
    }
}
