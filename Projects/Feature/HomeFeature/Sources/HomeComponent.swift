import NeedleFoundation
import SwiftUI
import HomeFeatureInterface
import ComposableArchitecture
import HomeDomainInterface
import AllTabDomainInterface
import AcceptDomainInterface
import AllTabFeatureInterface
import PlanFeatureInterface
import SchoolMealFeatureInterface
import AcceptFeatureInterface
import ClassroomMoveListDomainInterface
import OutListDomainInterface

public protocol HomeDependency: NeedleFoundation.Dependency {
    var getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol { get }
    var getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol { get }

    var getSelfStudyAndClassroomUseCase: any GetSelfStudyAndClassroomUseCase { get }

    var getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol { get }
    var updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol { get }
    var getEarlyReturnByGradeUseCase: any GetEarlyReturnByGradeUseCaseProtocol { get }
    var updateEarlyReturnStatusUseCase: any UpdateEarlyReturnStatusUseCaseProtocol { get }

    var getClassroomMoveByFloorUseCase: any GetClassroomMoveByFloorUseCase { get }
    var getOutListUseCase: any GetOutListUseCase { get }
    var getEarlyReturnUseCase: any GetEarlyReturnUseCase { get }

    var allTabFactory: any AllTabFactory { get }
    var planFactory: any PlanFactory { get }
    var schoolMealFactory: any SchoolMealFactory { get }
    var acceptFactory: any AcceptFactory { get }
}

public final class HomeComponent: Component<HomeDependency>, HomeFactory {
    public func makeView() -> AnyView {
        AnyView(
            HomeFeature(
                store: .init(
                    initialState: HomeReducer.State(),
                    reducer: {
                        HomeReducer(
                            getSelfStudyDirectorUseCase: self.dependency.getSelfStudyDirectorUseCase,
                            getAdminSelfStudyInfoUseCase: self.dependency.getAdminSelfStudyInfoUseCase,
                            getSelfStudyAndClassroomUseCase: self.dependency.getSelfStudyAndClassroomUseCase,
                            getAllApplicationsUseCase: self.dependency.getAllApplicationsUseCase,
                            updateApplicationStatusUseCase: self.dependency.updateApplicationStatusUseCase,
                            getEarlyReturnByGradeUseCase: self.dependency.getEarlyReturnByGradeUseCase,
                            updateEarlyReturnStatusUseCase: self.dependency.updateEarlyReturnStatusUseCase,
                            getClassroomMoveByFloorUseCase: self.dependency.getClassroomMoveByFloorUseCase,
                            getOutListUseCase: self.dependency.getOutListUseCase,
                            getEarlyReturnUseCase: self.dependency.getEarlyReturnUseCase
                        )
                    }
                ),
                allTabFactory: self.dependency.allTabFactory,
                planFactory: self.dependency.planFactory,
                schoolMealFactory: self.dependency.schoolMealFactory,
                acceptFactory: self.dependency.acceptFactory
            )
        )
    }
}
