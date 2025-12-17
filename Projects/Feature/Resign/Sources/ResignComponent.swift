import NeedleFoundation
import SwiftUI
import ResignFeatureInterface
import ComposableArchitecture

public protocol ResignDependency: NeedleFoundation.Dependency {
}

public final class ResignComponent: Component<ResignDependency>, ResignFactory {
    public func makeView() -> AnyView {
        AnyView(
            ResignFeature(
                store: .init(
                    initialState: ResignReducer.State(),
                    reducer: {
                        ResignReducer()
                    }
                )
            )
        )
    }
}
