import ComposableArchitecture
import AuthDomainInterface

public struct ChangePasswordReducer: Reducer {
    private let emailSendUseCase: any EmailSendUseCase
    private let codeCheckUseCase: any CodeCheckUseCase

    public init(
        emailSendUseCase: any EmailSendUseCase,
        codeCheckUseCase: any CodeCheckUseCase
    ) {
        self.emailSendUseCase = emailSendUseCase
        self.codeCheckUseCase = codeCheckUseCase
    }

    public struct State: Equatable {
        public var email = ""
        public var code = ""
        public var isVerificationSent = false
        public var errorMessage: String?
        public var successMessage: String?
        public var accountId: String?
        public init() {}
    }

    public enum Action {
        case emailChanged(String)
        case codeChanged(String)
        case verificationButtonTapped
        case nextButtonTapped
        case emailSendResponse(TaskResult<Void>)
        case codeCheckResponse(TaskResult<Bool>)
        case clearSuccessMessage
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .emailChanged(email):
                state.email = email
                state.errorMessage = nil
                return .none

            case let .codeChanged(code):
                state.code = code
                state.errorMessage = nil
                return .none

            case .verificationButtonTapped:
                guard !state.email.isEmpty else {
                    state.errorMessage = "이메일을 입력해주세요"
                    return .none
                }
                return sendVerificationCode(with: state)

            case .nextButtonTapped:
                guard !state.email.isEmpty && !state.code.isEmpty else {
                    state.errorMessage = "모든 필드를 입력해주세요"
                    return .none
                }
                return checkVerificationCode(with: state)

            case .emailSendResponse(.success):
                state.isVerificationSent = true
                state.errorMessage = nil
                state.successMessage = "이메일로 코드가 전송되었어요!"
                return .none

            case .emailSendResponse(.failure(let error)):
                state.errorMessage = error.localizedDescription
                state.successMessage = nil
                return .none

            case .codeCheckResponse(.success(let isValid)):
                if isValid {
                    state.accountId = state.email
                    state.errorMessage = nil
                } else {
                    state.errorMessage = "인증코드가 올바르지 않습니다"
                }
                return .none

            case .codeCheckResponse(.failure(let error)):
                state.errorMessage = error.localizedDescription
                return .none

            case .clearSuccessMessage:
                state.successMessage = nil
                return .none
            }
        }
    }

    private func sendVerificationCode(with state: State) -> Effect<Action> {
        .run { send in
            await send(.emailSendResponse(
                await TaskResult {
                    for try await _ in emailSendUseCase.execute(
                        req: .init(
                            mail: state.email,
                            title: "비밀번호 변경 인증",
                            message: "비밀번호 변경 인증"
                        )
                    ).values {}
                }
            ))
        }
    }

    private func checkVerificationCode(with state: State) -> Effect<Action> {
        .run { send in
            await send(.codeCheckResponse(
                await TaskResult {
                    for try await result in codeCheckUseCase.execute(
                        req: .init(email: state.email, code: state.code)
                    ).values {
                        return result
                    }
                    return false
                }
            ))
        }
    }
}
