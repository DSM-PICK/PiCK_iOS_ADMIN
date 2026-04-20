import ComposableArchitecture
import AuthDomainInterface

@Reducer
public struct SecretKeyReducer: Reducer {
    private let secretKeyUseCase: any SecretKeyUseCase

    public init(secretKeyUseCase: any SecretKeyUseCase) {
        self.secretKeyUseCase = secretKeyUseCase
    }

    @ObservableState
    public struct State: Equatable {
        public var secretKey = ""
        public var isSigninSuccessful = false
        public var errorMessage: String?
        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case nextButtonTapped
        case secretKeyResponse(TaskResult<Bool>)
        case clearError
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .nextButtonTapped:
                return performSecretKey(with: state)
            case let .secretKeyResponse(.success(isValid)):
                state.isSigninSuccessful = isValid
                if !isValid { state.errorMessage = "올바른 시크릿 키를 입력해주세요" }
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
                    var response = false
                    for try await result in secretKeyUseCase.execute(
                        req: .init(secretKey: state.secretKey)
                    ).values {
                        response = result
                    }
                    return response
                }
            ))
        }
    }
}
