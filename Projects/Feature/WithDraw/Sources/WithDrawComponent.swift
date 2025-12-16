import NeedleFoundation
import SwiftUI
import WithDrawFeatureInterface
import ComposableArchitecture

public protocol WithDrawDependency: NeedleFoundation.Dependency {
}

public final class WithDrawComponent: Component<WithDrawDependency>, WithDrawFactory {
    public func makeView() -> AnyView {
        AnyView(
            WithDrawFeature(
                store: .init(
                    initialState: WithDrawReducer.State(),
                    reducer: {
                        WithDrawReducer()
                    }
                )
            )
        )
    }
}
