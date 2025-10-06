import NeedleFoundation
import SwiftUI
import SigninFeatureInterface

protocol RootDependency: Dependency {
    var signinFactory: any SigninFactory { get }
}

final class RootComponent: Component<RootDependency> {
    func makeView() -> some View {
        dependency.signinFactory.makeView()
    }
}
