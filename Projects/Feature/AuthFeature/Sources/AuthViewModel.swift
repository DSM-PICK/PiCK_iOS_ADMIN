import Foundation
import AuthDomainInterface

class AuthViewModel: ObservableObject {
    private let loginUseCase: any LoginUseCase

    init(loginUseCase: any LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
}
