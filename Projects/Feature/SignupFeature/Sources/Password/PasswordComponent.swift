import NeedleFoundation
import SwiftUI
import AuthDomainInterface
import SignupFeatureInterface
import ComposableArchitecture

public protocol PasswordDependency: NeedleFoundation.Dependency {}

public final class PasswordComponent: Component<PasswordDependency>, PasswordFactory {
    public func makeView(secretKey: String, accountId: String, code: String) -> AnyView {
        AnyView(
            PasswordView(
                store: .init(
                    initialState: PasswordReducer.State(
                        secretKey: secretKey,
                        accountId: accountId,
                        code: code
                    ),
                    reducer: {
                        PasswordReducer()
                    }
                )
            )
        )
    }
}
