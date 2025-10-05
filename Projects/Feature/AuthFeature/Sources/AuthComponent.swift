import NeedleFoundation
import SwiftUI
import AuthDomainInterface
import AuthFeatureInterface

public protocol AuthDependency: Dependency {
    var loginUseCase: any LoginUseCase { get }
}

public final class AuthComponent: Component<AuthDependency>, AuthFactory {
    public func makeView() -> some View {
        AuthView(
            viewModel: .init(
                loginUseCase: self.dependency.loginUseCase
            )
        )
    }
}
