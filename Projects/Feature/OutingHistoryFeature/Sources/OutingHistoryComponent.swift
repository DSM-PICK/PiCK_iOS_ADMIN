import NeedleFoundation
import SwiftUI
import OutingHistoryFeatureInterface
import ComposableArchitecture
import OutingHistoryDomainInterface

public protocol OutingHistoryDependency: NeedleFoundation.Dependency {
    var getOutingHistoryUseCase: GetOutingHistoryUseCase { get }
}

public final class OutingHistoryComponent: Component<OutingHistoryDependency>, OutingHistoryFactory {
    public func makeView() -> AnyView {
        AnyView(
            OutingHistoryView(
                store: .init(
                    initialState: OutingHistoryReducer.State(),
                    reducer: {
                        OutingHistoryReducer(
                            getOutingHistoryUseCase: self.dependency.getOutingHistoryUseCase
                        )
                    }
                )
            )
        )
    }
}
