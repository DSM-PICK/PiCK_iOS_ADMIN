import NeedleFoundation
import SwiftUI
import OutingHistoryFeatureInterface
import ComposableArchitecture
import OutingHistoryDomainInterface

public protocol OutingHistoryDependency: NeedleFoundation.Dependency {}

public final class OutingHistoryComponent: Component<OutingHistoryDependency>, OutingHistoryFactory {
    public func makeView() -> AnyView {
        AnyView(
            OutingHistoryView(
                store: .init(
                    initialState: OutingHistoryReducer.State(),
                    reducer: {
                        OutingHistoryReducer()
                    }
                )
            )
        )
    }
}
