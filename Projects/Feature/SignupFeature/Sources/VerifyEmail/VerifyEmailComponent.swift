import NeedleFoundation
import SwiftUI
import AuthDomainInterface
import SignupFeatureInterface
import ComposableArchitecture

public protocol VerifyEmailDependency: NeedleFoundation.Dependency {
    var secretKeyUseCase: any SecretKeyUseCase { get }
}

public final class VerifyEmailComponent: Component<VerifyEmailDependency>, VerifyEmailFactory {
    public func makeView(secretKey: String) -> AnyView {
        AnyView(
            VerifyEmailView(
                store: .init(
                    initialState: VerifyEmailReducer.State(secretKey: secretKey),
                    reducer: {
                        VerifyEmailReducer()
                    }
                )
            )
        )
    }
}
