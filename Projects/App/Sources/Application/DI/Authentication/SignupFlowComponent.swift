import NeedleFoundation
import SwiftUI
import SignupFeature
import SignupFeatureInterface

public protocol SignupFlowDependency: NeedleFoundation.Dependency {}

public final class SignupFlowComponent: Component<SignupFlowDependency>,
    SecretKeyFactory,
    VerifyEmailFactory,
    PasswordFactory,
    InfoSettingFactory
{
    public func makeView() -> AnyView {
        SecretKeyComponent(parent: self).makeView()
    }

    public func makeView(secretKey: String) -> AnyView {
        VerifyEmailComponent(parent: self).makeView(secretKey: secretKey)
    }

    public func makeView(secretKey: String, accountId: String, code: String) -> AnyView {
        PasswordComponent(parent: self).makeView(secretKey: secretKey, accountId: accountId, code: code)
    }

    public func makeView(secretKey: String, accountId: String, code: String, password: String) -> AnyView {
        InfoSettingComponent(parent: self).makeView(
            secretKey: secretKey,
            accountId: accountId,
            code: code,
            password: password
        )
    }
}
