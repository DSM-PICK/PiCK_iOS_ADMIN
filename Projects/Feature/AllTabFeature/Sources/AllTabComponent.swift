import NeedleFoundation
import SwiftUI
import AllTabFeatureInterface
import ComposableArchitecture
import AllTabDomainInterface
import AuthDomainInterface
import CheckSelfStudyTeacherDomainInterface
import BugReportDomainInterface

public protocol AllTabDependency: NeedleFoundation.Dependency {
    var getMyNameUseCase: any GetMyNameUseCaseProtocol { get }
    var authRepository: any AuthRepository { get }
    var fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol { get }
    var uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol { get }
    var submitBugReportUseCase: any SubmitBugReportUseCaseProtocol { get }
    var emailSendUseCase: any EmailSendUseCase { get }
    var codeCheckUseCase: any CodeCheckUseCase { get }
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
                codeCheckUseCase: codeCheckUseCase
            )
        )
    }
}
