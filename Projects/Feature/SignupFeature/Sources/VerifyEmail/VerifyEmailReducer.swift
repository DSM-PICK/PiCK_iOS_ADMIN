import ComposableArchitecture
import AuthDomainInterface

public struct VerifyEmailReducer: Reducer {
    private let emailSendUseCase: any EmailSendUseCase

    public init(emailSendUseCase: any EmailSendUseCase) {
        self.emailSendUseCase = emailSendUseCase
    }

    public struct State: Equatable {
        public var secretKey = ""
        public var email = ""
        public var code = ""
        public var errorMessage: String? = nil

        public init(secretKey: String) {
            self.secretKey = secretKey
        }
    }

    public enum Action {
        case emailChanged(String)
        case codeChanged(String)
        case verificationButtonTapped
        case emailSendResponse(TaskResult<Void>)
        case clearError
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
            case .verificationButtonTapped:
                return performEmailSend(with: state)
            case .emailSendResponse(.success):
                return .none
            case .emailSendResponse(.failure(let error)):
                let authError = error as? AuthDomainInterface.EmailError ?? .clientError
                state.errorMessage = authError.errorDescription
                return .none
            case .clearError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}

extension VerifyEmailReducer {
    private func performEmailSend(with state: State) -> Effect<Action> {
        .run { send in
            await send(.emailSendResponse(
                await TaskResult {
                    for try await _ in emailSendUseCase.execute(
                        req: .init(
                            mail: state.email,
                            title: "회원가입 인증",
                            message: ""
                        )
                    ).values {}
                }
            ))
        }
    }
}
