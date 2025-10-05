import NeedleFoundation
import SwiftUI
import AuthFeatureInterface

protocol RootDependency: Dependency {
    var authFactory: any AuthFactory { get }
}

final class RootComponent: Component<RootDependency> {
    func makeView() -> some View {
        dependency.authFactory.makeView()
    }
}
