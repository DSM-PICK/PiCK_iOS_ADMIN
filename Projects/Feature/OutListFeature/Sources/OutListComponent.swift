import NeedleFoundation
import SwiftUI
import OutListFeatureInterface
import ComposableArchitecture
import OutListDomainInterface

public protocol OutListDependency: NeedleFoundation.Dependency { }

public final class OutListComponent: Component<OutListDependency>, OutListFactory {
    public func makeOutListView() -> AnyView {
        AnyView(
            OutListView(
                store: .init(
                    initialState: OutListReducer.State(),
                    reducer: {
                        OutListReducer()
                    }
                )
            )
        )
    }
}
