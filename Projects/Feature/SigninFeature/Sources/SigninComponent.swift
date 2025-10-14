import NeedleFoundation
import SwiftUI
import AuthDomainInterface
import SigninFeatureInterface
import ComposableArchitecture

public protocol SigninDependency: NeedleFoundation.Dependency {
    var loginUseCase: any LoginUseCase { get }
}

public final class SigninComponent: Component<SigninDependency>, SigninFactory {
    public func makeView() -> AnyView {
        AnyView(SigninView(
            store: .init(
                initialState: SigninReducer.State(),
                reducer: {
                    SigninReducer(loginUseCase: self.dependency.loginUseCase)
                }
            )
        ))
    }
}
