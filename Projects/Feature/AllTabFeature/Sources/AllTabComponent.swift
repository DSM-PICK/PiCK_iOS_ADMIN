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
                submitBugReportUseCase: submitBugReportUseCase
            )
        )
    }
}
