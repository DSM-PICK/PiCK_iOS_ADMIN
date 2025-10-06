import NeedleFoundation
import SwiftUI
import AuthDomainInterface
import SignupFeatureInterface
import ComposableArchitecture

public protocol SignupDependency: NeedleFoundation.Dependency {
    var loginUseCase: any LoginUseCase { get }
}

public final class SignupComponent: Component<SignupDependency>, SignupFactory {
    public func makeView() -> AnyView {
        AnyView(SignupView(
            store: .init(
                initialState: SignupReducer.State(),
                reducer: {
                    SignupReducer(loginUseCase: self.dependency.loginUseCase)
                }
            )
        ))
    }
}
