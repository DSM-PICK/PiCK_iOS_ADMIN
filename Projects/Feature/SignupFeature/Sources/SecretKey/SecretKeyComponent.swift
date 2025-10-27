import NeedleFoundation
import SwiftUI
import AuthDomainInterface
import SignupFeatureInterface
import ComposableArchitecture

public protocol SecretKeyDependency: NeedleFoundation.Dependency {
    var signinUseCase: any SigninUseCase { get }
}

public final class SecretKeyComponent: Component<SecretKeyDependency>, SignupFactory {
    public func makeView() -> AnyView {
        AnyView(SecretKeyView(
            store: .init(
                initialState: SecretKeyReducer.State(),
                reducer: {
                    SecretKeyReducer(signinUseCase: self.dependency.signinUseCase)
                }
            )
        ))
    }
}
