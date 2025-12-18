import NeedleFoundation
import SwiftUI
import AcceptFeatureInterface
import ComposableArchitecture
import AcceptDomainInterface

public protocol AcceptDependency: NeedleFoundation.Dependency {
    var getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol { get }
    var getApplicationsByFloorUseCase: any GetApplicationsByFloorUseCaseProtocol { get }
    var getClassroomMovesUseCase: any GetClassroomMovesUseCaseProtocol { get }
    var getEarlyReturnByGradeUseCase: any GetEarlyReturnByGradeUseCaseProtocol { get }
    var updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol { get }
    var updateClassroomMoveStatusUseCase: any UpdateClassroomMoveStatusUseCaseProtocol { get }
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
                                getApplicationsByFloorUseCase: self.dependency.getApplicationsByFloorUseCase,
                                getClassroomMovesUseCase: self.dependency.getClassroomMovesUseCase,
                                getEarlyReturnByGradeUseCase: self.dependency.getEarlyReturnByGradeUseCase,
                                updateApplicationStatusUseCase: self.dependency.updateApplicationStatusUseCase,
                                updateClassroomMoveStatusUseCase: self.dependency.updateClassroomMoveStatusUseCase
                            )
                        }
                    )
                )
            }
        )
    }
}
