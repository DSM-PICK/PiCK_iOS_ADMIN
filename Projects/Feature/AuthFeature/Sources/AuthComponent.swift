import NeedleFoundation
import SwiftUI
import AuthDomainInterface
import AuthFeatureInterface
import ComposableArchitecture

public protocol AuthDependency: NeedleFoundation.Dependency {
    var loginUseCase: any LoginUseCase { get }
}

public final class AuthComponent: Component<AuthDependency>, AuthFactory {
    public func makeView() -> AnyView {
        AnyView(AuthView(
            store: .init(
                initialState: AuthReducer.State(),
                reducer: {
                    AuthReducer(loginUseCase: self.dependency.loginUseCase)
                }
            )
        ))
    }
}
