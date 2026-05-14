import NeedleFoundation
import SwiftUI
import AllTabFeatureInterface
import ComposableArchitecture
import AllTabDomainInterface
import AuthDomainInterface
import BugReportFeatureInterface
import CheckSelfStudyTeacherFeatureInterface
import ChangePasswordFeatureInterface
import ClassroomMoveListFeatureInterface
import OutListFeatureInterface
import OutingHistoryFeatureInterface
import SelfStudyCheckFeatureInterface

public protocol AllTabDependency: NeedleFoundation.Dependency {
    var getMyNameUseCase: any GetMyNameUseCaseProtocol { get }
    var authRepository: any AuthRepository { get }
    var checkSelfStudyTeacherFactory: any CheckSelfStudyTeacherFactory { get }
    var bugReportFactory: any BugReportFactory { get }
    var changePasswordFactory: any ChangePasswordFactory { get }
    var newPasswordFactory: any NewPasswordFactory { get }
    var selfStudyCheckFactory: any SelfStudyCheckFactory { get }
    var outListFactory: any OutListFactory { get }
    var classroomMoveListFactory: any ClassroomMoveListFactory { get }
    var outingHistoryFactory: any OutingHistoryFactory { get }
}

public final class AllTabComponent: Component<AllTabDependency>, AllTabFactory {
    public func makeView() -> AnyView {
        AnyView(
            AllTabView(
                store: .init(
                    initialState: AllTabReducer.State(),
                    reducer: {
                        AllTabReducer(
                            getMyNameUseCase: self.dependency.getMyNameUseCase,
                            authRepository: self.dependency.authRepository
                        )
                    }
                ),
                checkSelfStudyTeacherFactory: dependency.checkSelfStudyTeacherFactory,
                bugReportFactory: dependency.bugReportFactory,
                changePasswordFactory: dependency.changePasswordFactory,
                newPasswordFactory: dependency.newPasswordFactory,
                selfStudyCheckFactory: dependency.selfStudyCheckFactory,
                outListFactory: dependency.outListFactory,
                classroomMoveListFactory: dependency.classroomMoveListFactory,
                outingHistoryFactory: dependency.outingHistoryFactory
            )
        )
    }
}
