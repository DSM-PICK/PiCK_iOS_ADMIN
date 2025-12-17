import NeedleFoundation
import SwiftUI
import AllTabFeatureInterface
import ComposableArchitecture
import AllTabDomainInterface
import AuthDomainInterface
import CheckSelfStudyTeacherDomainInterface
import BugReportDomainInterface
import ChangePasswordDomainInterface
import SelfStudyCheckDomainInterface
import OutListDomainInterface
import ClassroomMoveListDomainInterface
import OutingHistoryDomainInterface

public protocol AllTabDependency: NeedleFoundation.Dependency {
    var getMyNameUseCase: any GetMyNameUseCaseProtocol { get }
    var authRepository: any AuthRepository { get }
    var fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol { get }
    var uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol { get }
    var submitBugReportUseCase: any SubmitBugReportUseCaseProtocol { get }
    var emailSendUseCase: any EmailSendUseCase { get }
    var codeCheckUseCase: any CodeCheckUseCase { get }
    var passwordChangeUseCase: any PasswordChangeUseCase { get }
    var getStudentAttendanceUseCase: any GetStudentAttendanceUseCase { get }
    var saveAttendanceUseCase: any SaveAttendanceUseCase { get }
    var getOutListUseCase: any GetOutListUseCase { get }
    var returnStudentsUseCase: any ReturnStudentsUseCase { get }
    var getEarlyReturnUseCase: any GetEarlyReturnUseCase { get }
    var getClassroomMoveByFloorUseCase: any GetClassroomMoveByFloorUseCase { get }
    var getClassroomMoveByClassroomUseCase: any GetClassroomMoveByClassroomUseCase { get }
    var getOutingHistoryUseCase: any GetOutingHistoryUseCase { get }
}

public final class AllTabComponent: Component<AllTabDependency>, AllTabFactory {
    public var fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol {
        dependency.fetchSelfStudyTeacherUseCase
    }

    public var uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol {
        dependency.uploadBugImagesUseCase
    }

    public var submitBugReportUseCase: any SubmitBugReportUseCaseProtocol {
        dependency.submitBugReportUseCase
    }

    public var emailSendUseCase: any EmailSendUseCase {
        dependency.emailSendUseCase
    }

    public var codeCheckUseCase: any CodeCheckUseCase {
        dependency.codeCheckUseCase
    }

    public var passwordChangeUseCase: any PasswordChangeUseCase {
        dependency.passwordChangeUseCase
    }

    public func makeView() -> AnyView {
        AnyView(
            AllTabFeature(
                store: .init(
                    initialState: AllTabReducer.State(),
                    reducer: {
                        AllTabReducer(
                            getMyNameUseCase: self.dependency.getMyNameUseCase,
                            authRepository: self.dependency.authRepository
                        )
                    }
                ),
                fetchSelfStudyTeacherUseCase: fetchSelfStudyTeacherUseCase,
                uploadBugImagesUseCase: uploadBugImagesUseCase,
                submitBugReportUseCase: submitBugReportUseCase,
                emailSendUseCase: emailSendUseCase,
                codeCheckUseCase: codeCheckUseCase,
                passwordChangeUseCase: passwordChangeUseCase,
                getStudentAttendanceUseCase: self.dependency.getStudentAttendanceUseCase,
                saveAttendanceUseCase: self.dependency.saveAttendanceUseCase,
                getOutListUseCase: self.dependency.getOutListUseCase,
                returnStudentsUseCase: self.dependency.returnStudentsUseCase,
                getEarlyReturnUseCase: self.dependency.getEarlyReturnUseCase,
                getClassroomMoveByFloorUseCase: self.dependency.getClassroomMoveByFloorUseCase,
                getClassroomMoveByClassroomUseCase: self.dependency.getClassroomMoveByClassroomUseCase,
                getOutingHistoryUseCase: self.dependency.getOutingHistoryUseCase
            )
        )
    }
}
