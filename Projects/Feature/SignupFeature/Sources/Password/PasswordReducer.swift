import ComposableArchitecture
import Foundation
import AuthDomainInterface

@Reducer
public struct PasswordReducer: Reducer {
    @ObservableState
    public struct State: Equatable {
        public var secretKey = ""
        public var accountId = ""
        public var code = ""
        public var password = ""
        public var passwordConfirm = ""
        public var errorMessage: String? = nil
        public var isSuccessful = false

        public init(secretKey: String = "", accountId: String = "", code: String = "") {
            self.secretKey = secretKey
            self.accountId = accountId
            self.code = code
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case nextButtonTapped
        case clearError
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .nextButtonTapped:
                let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&()])[A-Za-z\\d!@#$%^&()]{8,30}$"
                let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

                if state.password !=  state.passwordConfirm {
                    state.errorMessage = "비밀번호 일치하지 않습니다"
                } else if !passwordTest.evaluate(with: state.password) {
                    state.errorMessage = "8~30자 영문자, 숫자, 특수문자 포함하세요"
                } else {
                    state.isSuccessful = true
                }
                return .none
            case .clearError:
                state.errorMessage = nil
                return .none
            }
        }
    }
}
