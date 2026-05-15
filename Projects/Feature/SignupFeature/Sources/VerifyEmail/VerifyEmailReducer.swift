import Foundation
import ComposableArchitecture
import AuthDomainInterface

@Reducer
public struct VerifyEmailReducer: Reducer {
    private let emailSendUseCase: any EmailSendUseCase
    private let codeCheckUseCase: any CodeCheckUseCase

    public init(emailSendUseCase: any EmailSendUseCase, codeCheckUseCase: any CodeCheckUseCase) {
        self.emailSendUseCase = emailSendUseCase
        self.codeCheckUseCase = codeCheckUseCase
    }

    @ObservableState
    public struct State: Equatable {
        public var secretKey = ""
        public var email = ""
        public var code = ""
        public var isSuccessful = false
        public var errorMessage: String?

        public init(secretKey: String) {
            self.secretKey = secretKey
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case verificationButtonTapped
        case nextButtonTapped
        case emailSendResponse(TaskResult<Void>)
        case codeCheckResponse(TaskResult<Bool>)
        case clearError
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .verificationButtonTapped:
                return performEmailSend(with: state)
            case .nextButtonTapped:
                return performCodeCheck(with: state)
            case .emailSendResponse(.success):
                return .none
            case let .emailSendResponse(.failure(error)):
                state.errorMessage = parseErrorMessage(from: error)
                return .none
            case let .codeCheckResponse(.success(isValid)):
                state.isSuccessful = isValid
                if !isValid { state.errorMessage = "올바른 인증코드를 입력해주세요" }
                return .none
            case let .codeCheckResponse(.failure(error)):
                state.errorMessage = parseErrorMessage(from: error)
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
            await send(
                .emailSendResponse(
                    await TaskResult {
                        for try await _ in emailSendUseCase.execute(
                            req: .init(
                                mail: state.email,
                                title: "회원가입 인증",
                                message: "회원가입 인증"
                            )
                        ).values {}
                    }
                )
            )
        }
    }

    private func performCodeCheck(with state: State) -> Effect<Action> {
        .run { send in
            await send(
                .codeCheckResponse(
                    await TaskResult<Bool> {
                        var response = false
                        for try await result in codeCheckUseCase.execute(
                            req: .init(
                                email: state.email,
                                code: state.code
                            )
                        ).values { response = result }
                        return response
                    }
                )
            )
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
