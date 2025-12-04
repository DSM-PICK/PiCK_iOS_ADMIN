import NeedleFoundation
import SwiftUI
import AuthDomainInterface
import ChangePasswordDomainInterface
import ChangePasswordFeatureInterface
import ComposableArchitecture

public protocol ChangePasswordDependency: NeedleFoundation.Dependency {
    var emailSendUseCase: any EmailSendUseCase { get }
    var codeCheckUseCase: any CodeCheckUseCase { get }
}

public final class ChangePasswordComponent: Component<ChangePasswordDependency>, ChangePasswordFactory {
    public func makeView() -> AnyView {
        AnyView(ChangePasswordView(
            store: .init(
                initialState: ChangePasswordReducer.State(),
                reducer: {
                    ChangePasswordReducer(
                        emailSendUseCase: self.dependency.emailSendUseCase,
                        codeCheckUseCase: self.dependency.codeCheckUseCase
                    )
                }
            )
        ))
    }
}

public protocol NewPasswordDependency: NeedleFoundation.Dependency {
    var passwordChangeUseCase: any PasswordChangeUseCase { get }
}

public final class NewPasswordComponent: Component<NewPasswordDependency>, NewPasswordFactory {
    public func makeView(accountId: String, code: String) -> AnyView {
        AnyView(NewPasswordView(
            store: .init(
                initialState: NewPasswordReducer.State(),
                reducer: {
                    NewPasswordReducer(
                        passwordChangeUseCase: self.dependency.passwordChangeUseCase,
                        accountId: accountId,
                        code: code
                    )
                }
            )
        ))
    }
}
