
import Foundation

import ComposableArchitecture
import FirebaseMessaging

import Domain

@Reducer
public struct LoginFeature {
    
    private let loginUseCase: LoginUseCase
    
    public init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    @ObservableState
    public struct State: Equatable {
        var id: String = ""
        var password: String = ""
        var idErrorDescription: String = ""
        var passwordErrorDescription: String = ""
        var isButtonEnabled: Bool = false
    }
    
    public enum Action {
        case updateID(String)
        case updatePassword(String)
        case loginButtonDidTap
        case signUpButtonDidTap
        case loginResponse(TaskResult<Void>)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .updateID(id):
                state.id = id
                state.isButtonEnabled = !state.id.isEmpty && !state.password.isEmpty
                return .none
                
            case let .updatePassword(password):
                state.password = password
                state.isButtonEnabled = !state.id.isEmpty && !state.password.isEmpty
                return .none
                
            case .loginButtonDidTap:
                let id = state.id
                let password = state.password
                return .run { send in
                    await send(
                        .loginResponse(
                            await TaskResult {
                                try await loginUseCase.execute(
                                    req: .init(
                                        adminId: id,
                                        password: password,
                                        deviceToken: Messaging.messaging().fcmToken ?? ""
                                    )
                                )
                            }
                        )
                    )
                }
                
            case let .loginResponse(.success(response)):
                // TODO: Tab으로 이동
                return .none
                
            case let .loginResponse(.failure(error)):
                if let error = error as? AuthError {
                    switch error {
                    case .idMismatch:
                        state.idErrorDescription = error.errorDescription ?? ""
                    case .passwordMismatch:
                        state.passwordErrorDescription = error.errorDescription ?? ""
                    }
                }
                return .none
                
            case .signUpButtonDidTap:
                // TODO: 회원가입으로 이동
                return .none
            }
        }
    }
}
