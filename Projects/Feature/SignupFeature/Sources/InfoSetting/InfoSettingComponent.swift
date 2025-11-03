import NeedleFoundation
import SwiftUI
import AuthDomainInterface
import SignupFeatureInterface
import ComposableArchitecture

public protocol InfoSettingDependency: NeedleFoundation.Dependency {
    var signupUseCase: any SignupUseCase { get }
}

public final class InfoSettingComponent: Component<InfoSettingDependency>, InfoSettingFactory {
    public func makeView(secretKey: String, accountId: String, code: String, password: String) -> AnyView {
        AnyView(
            InfoSettingView(
                store: StoreOf<InfoSettingReducer>(
                    initialState: InfoSettingReducer.State(
                        secretKey: secretKey,
                        accountId: accountId,
                        code: code,
                        password: password
                    ),
                    reducer: {
                        InfoSettingReducer(signupUseCase: self.dependency.signupUseCase)
                    }
                )
            )
        )
    }
}
