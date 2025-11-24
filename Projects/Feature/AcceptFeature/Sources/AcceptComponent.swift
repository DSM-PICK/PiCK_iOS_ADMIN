import NeedleFoundation
import SwiftUI
import AcceptFeatureInterface
import ComposableArchitecture
import AcceptDomainInterface

public protocol AcceptDependency: NeedleFoundation.Dependency {
    var getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol { get }
    var getClassroomMovesUseCase: any GetClassroomMovesUseCaseProtocol { get }
    var updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol { get }
}

public final class AcceptComponent: Component<AcceptDependency>, AcceptFactory {
    public func makeView() -> AnyView {
        AnyView(
            NavigationView {
                AcceptView(
                    store: .init(
                        initialState: AcceptReducer.State(),
                        reducer: {
                            AcceptReducer(
                                getAllApplicationsUseCase: self.dependency.getAllApplicationsUseCase,
                                getClassroomMovesUseCase: self.dependency.getClassroomMovesUseCase,
                                updateApplicationStatusUseCase: self.dependency.updateApplicationStatusUseCase
                            )
                        }
                    )
                )
            }
        )
    }
}
