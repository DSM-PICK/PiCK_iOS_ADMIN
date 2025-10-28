import NeedleFoundation
import SwiftUI
import AuthDomainInterface
import SignupFeatureInterface
import ComposableArchitecture

public protocol SecretKeyDependency: NeedleFoundation.Dependency {
    var secretKeyUseCase: any SecretKeyUseCase { get }
}

public final class SecretKeyComponent: Component<SecretKeyDependency>, SignupFactory {
    public func makeView() -> AnyView {
        AnyView(SecretKeyView(
            store: .init(
                initialState: SecretKeyReducer.State(),
                reducer: {
                    SecretKeyReducer(secretKeyUseCase: self.dependency.secretKeyUseCase)
                }
            )
        ))
    }
}
