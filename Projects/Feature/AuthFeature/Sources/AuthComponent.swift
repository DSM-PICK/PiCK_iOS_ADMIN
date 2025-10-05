import NeedleFoundation
import SwiftUI
import AuthDomainInterface
import AuthFeatureInterface
import ComposableArchitecture

public protocol AuthDependency: Dependency {
    var loginUseCase: any LoginUseCase { get }
}

public final class AuthComponent: Component<AuthDependency>, AuthFactory {
    public func makeView() -> some View {
        AuthView(
            store: .init(
                initialState: AuthReducer.State(),
                reducer: {
                    AuthReducer(loginUseCase: self.dependency.loginUseCase)
                }
            )
        )
    }
}
