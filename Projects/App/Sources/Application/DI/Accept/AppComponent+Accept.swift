import NeedleFoundation
import SwiftUI
import AcceptFeature
import AcceptFeatureInterface

public protocol AcceptDependency: Dependency {}

public final class AcceptComponent: Component<AcceptDependency>, AcceptFactory {
    public func makeView() -> AnyView {
        AnyView(
            AcceptFeature().makeView()
        )
    }
}

public extension AppComponent {
    var acceptFactory: any AcceptFactory {
        AcceptComponent(parent: self)
    }
}
