import Foundation
import Combine
import ComposableArchitecture
import ChangePasswordDomainInterface

@Reducer
public struct NewPasswordReducer: Reducer {
    private let passwordChangeUseCase: any PasswordChangeUseCase
    private let accountId: String
    private let code: String

    public init(
        passwordChangeUseCase: any PasswordChangeUseCase,
        accountId: String,
        code: String
    ) {
        self.passwordChangeUseCase = passwordChangeUseCase
        self.accountId = accountId
        self.code = code
    }

    @ObservableState
    public struct State: Equatable {
        public var newPassword = ""
        public var newPasswordCheck = ""
        public var errorMessage: String?
        public var isChangeSuccessful = false
        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case changeButtonTapped
        case passwordChangeResponse(TaskResult<Void>)
    }

    public var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                state.errorMessage = nil
                return .none

            case .changeButtonTapped:
                guard !state.newPassword.isEmpty && !state.newPasswordCheck.isEmpty else {
                    state.errorMessage = "모든 필드를 입력해주세요"
                    return .none
                }

                if state.newPassword != state.newPasswordCheck {
                    state.errorMessage = "비밀번호가 일치하지 않습니다"
                    return .none
                }

                let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&()])[A-Za-z\\d!@#$%^&()]{8,30}$"
                let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
                guard passwordTest.evaluate(with: state.newPassword) else {
                    state.errorMessage = "8~30자 영문자, 숫자, 특수문자를 포함하세요"
                    return .none
                }

                return performPasswordChange(password: state.newPassword)

            case .passwordChangeResponse(.success):
                state.isChangeSuccessful = true
                state.errorMessage = nil
                return .none

            case .passwordChangeResponse(.failure(let error)):
                state.errorMessage = error.localizedDescription
                return .none
            }
        }
    }

    private func performPasswordChange(password: String) -> Effect<Action> {
        .publisher {
            passwordChangeUseCase.execute(
                req: .init(
                    password: password,
                    adminId: accountId,
                    code: code
                )
            )
            .map { Action.passwordChangeResponse(.success(())) }
            .catch { Just(Action.passwordChangeResponse(.failure($0))) }
        }
    }
}
