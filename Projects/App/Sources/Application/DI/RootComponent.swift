import NeedleFoundation
import SwiftUI
import OnboardingFeatureInterface

protocol RootDependency: Dependency {
    var onboardingFactory: any OnboardingFactory { get }
}

final class RootComponent: Component<RootDependency> {
    func makeView() -> some View {
        dependency.onboardingFactory.makeView()
    }
}
