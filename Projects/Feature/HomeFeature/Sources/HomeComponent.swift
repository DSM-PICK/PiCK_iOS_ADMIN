
import NeedleFoundation
import SwiftUI
import HomeFeatureInterface
import ComposableArchitecture

public protocol HomeDependency: NeedleFoundation.Dependency {
}

public final class HomeComponent: Component<HomeDependency>, HomeFactory {
    public func makeView() -> AnyView {
        AnyView(HomeFeature(
            store: .init(
                initialState: HomeReducer.State(),
                reducer: {
                    HomeReducer()
                }
            )
        ))
    }
}
