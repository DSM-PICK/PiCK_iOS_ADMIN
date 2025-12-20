import Foundation
import ComposableArchitecture
import AuthDomainInterface

public struct InfoSettingReducer: Reducer {
    private let signupUseCase: any SignupUseCase

    public init(signupUseCase: any SignupUseCase) {
        self.signupUseCase = signupUseCase
    }

    public struct State: Equatable {
        public var secretKey = ""
        public var accountId = ""
        public var code = ""
        public var password = ""
        public var name = ""
        public var selectedGrade = 0
        public var selectedClass = 0
        public var isSignupSuccessful = false
        public var errorMessage: String? = nil

        public init(secretKey: String = "", accountId: String = "", code: String = "", password: String = "") {
            self.secretKey = secretKey
            self.accountId = accountId
            self.code = code
            self.password = password
        }
    }

    public enum Action {
        case nameChanged(String)
        case selectedGradeChanged(Int?)
        case selectedClassChanged(Int?)
        case finishButtonTapped
        case signupResponse(TaskResult<Void>)
        case clearError
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .nameChanged(name):
                state.name = name
                return .none
            case let .selectedGradeChanged(grade):
                state.selectedGrade = grade ?? 0
                return .none
            case let .selectedClassChanged(klass):
                state.selectedClass = klass ?? 0
                return .none
            case .finishButtonTapped:
                return performSignup(with: state)
            case .signupResponse(.success):
                state.isSignupSuccessful = true
                return .none
            case let .signupResponse(.failure(error)):
                state.errorMessage = parseErrorMessage(from: error)
                return .none
            case .clearError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}

extension InfoSettingReducer {
    private func performSignup(with state: State) -> Effect<Action> {
        .run { send in
            await send(.signupResponse(
                await TaskResult {
                    for try await _ in signupUseCase.execute(
                        req: .init(
                            accountId: state.accountId,
                            password: state.password,
                            name: state.name,
                            grade: state.selectedGrade,
                            classNum: state.selectedClass,
                            code: state.code,
                            deviceToken: "",
                            secretKey: state.secretKey)
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
