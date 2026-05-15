import NeedleFoundation
import SwiftUI
import BugReportFeatureInterface
import ComposableArchitecture
import BugReportDomainInterface

public protocol BugReportDependency: NeedleFoundation.Dependency {
    var uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol { get }
    var submitBugReportUseCase: any SubmitBugReportUseCaseProtocol { get }
}

public final class BugReportComponent: Component<BugReportDependency>, BugReportFactory {
    public func makeView() -> AnyView {
        AnyView(
            BugReportView(
                store: .init(
                    initialState: BugReportReducer.State(),
                    reducer: {
                        BugReportReducer(
                            uploadBugImagesUseCase: self.dependency.uploadBugImagesUseCase,
                            submitBugReportUseCase: self.dependency.submitBugReportUseCase
                        )
                    }
                )
            )
        )
    }
}
