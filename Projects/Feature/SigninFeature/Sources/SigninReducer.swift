import ComposableArchitecture
import Foundation
import AuthDomainInterface
import Core

@Reducer
public struct SigninReducer: Reducer {
    private let signinUseCase: any SigninUseCase

    public init(signinUseCase: any SigninUseCase) {
        self.signinUseCase = signinUseCase
    }

    @ObservableState
    public struct State: Equatable {
        public var email = ""
        public var password = ""
        public var isSigninSuccessful = false
        public var isLoading = false
        public var errorMessage: String?
        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case signinButtonTapped
        case signinResponse(TaskResult<Void>)
        case clearError
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .signinButtonTapped:
                state.isLoading = true
                return performSignin(with: state)

            case .signinResponse(.success):
                state.isLoading = false
                state.isSigninSuccessful = true
                return .none

            case let .signinResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = parseErrorMessage(from: error)
                return .none

            case .clearError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}

extension SigninReducer {
    private func performSignin(with state: State) -> Effect<Action> {
        .run { send in
            let deviceToken = UserDefaultStorage.shared.get(forKey: .deviceToken) as? String

            await send(.signinResponse(
                await TaskResult {
                    for try await _ in signinUseCase.execute(
                        req: .init(
                            adminID: state.email,
                            password: state.password,
                            deviceToken: deviceToken
                        )
                    ).values {}
                }
            ))
        }
    }

    private func parseErrorMessage(from error: Error) -> String {
        if let pickError = error as? PiCKError {
            return pickError.localizedDescription
        }
        if error is URLError {
            return "네트워크 연결을 확인해주세요"
        }

        return error.localizedDescription
    }
}
