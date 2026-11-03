import NeedleFoundation
import SwiftUI
import OnboardingFeatureInterface
import ComposableArchitecture
import BaseFeature

public protocol OnboardingDependency: NeedleFoundation.Dependency {
}

public final class OnboardingComponent: Component<OnboardingDependency>, OnboardingFactory {
    public func makeView() -> AnyView {
        AnyView(OnboardingView(
            store: .init(
                initialState: OnboardingReducer.State(),
                reducer: {
                    OnboardingReducer()
                }
            )
        ).trackScreen("Onboarding"))
    }
}
