import NeedleFoundation
import SwiftUI
import AuthDomainInterface
import SigninFeatureInterface
import ComposableArchitecture
import BaseFeature

public protocol SigninDependency: NeedleFoundation.Dependency {
    var signinUseCase: any SigninUseCase { get }
}

public final class SigninComponent: Component<SigninDependency>, SigninFactory {
    public func makeView() -> AnyView {
        AnyView(SigninView(
            store: .init(
                initialState: SigninReducer.State(),
                reducer: {
                    SigninReducer(signinUseCase: self.dependency.signinUseCase)
                }
            )
        ).trackScreen("Signin"))
    }
}
