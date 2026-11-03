import NeedleFoundation
import SwiftUI
import OutListFeatureInterface
import ComposableArchitecture
import OutListDomainInterface
import BaseFeature

public protocol OutListDependency: NeedleFoundation.Dependency {
    var getOutListUseCase: any GetOutListUseCase { get }
    var returnStudentsUseCase: any ReturnStudentsUseCase { get }
    var getEarlyReturnUseCase: any GetEarlyReturnUseCase { get }
}

public final class OutListComponent: Component<OutListDependency>, OutListFactory {
    public func makeView() -> AnyView {
        AnyView(
            OutListView(
                store: .init(
                    initialState: OutListReducer.State(),
                    reducer: {
                        OutListReducer(
                            getOutListUseCase: self.dependency.getOutListUseCase,
                            returnStudentsUseCase: self.dependency.returnStudentsUseCase,
                            getEarlyReturnUseCase: self.dependency.getEarlyReturnUseCase
                        )
                    }
                )
            ).trackScreen("OutList")
        )
    }
}
