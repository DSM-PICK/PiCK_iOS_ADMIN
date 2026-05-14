import NeedleFoundation
import SwiftUI
import ComposableArchitecture
import AllTabFeature
import AllTabFeatureInterface
import AllTabDomainInterface
import AuthDomainInterface
import BugReportFeature
import CheckSelfStudyTeacherFeature
import ChangePasswordFeature
import OutListFeature
import SelfStudyCheckFeature
import ClassroomMoveListFeature
import OutingHistoryFeature

public protocol AllTabDependency: NeedleFoundation.Dependency {
    var getMyNameUseCase: any GetMyNameUseCaseProtocol { get }
    var authRepository: any AuthRepository { get }
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
                checkSelfStudyTeacherFactory: CheckSelfStudyTeacherComponent(parent: self),
                bugReportFactory: BugReportComponent(parent: self),
                changePasswordFactory: ChangePasswordComponent(parent: self),
                newPasswordFactory: NewPasswordComponent(parent: self),
                selfStudyCheckFactory: SelfStudyCheckComponent(parent: self),
                outListFactory: OutListComponent(parent: self),
                classroomMoveListFactory: ClassroomMoveListComponent(parent: self),
                outingHistoryFactory: OutingHistoryComponent(parent: self)
            )
        )
    }
}
