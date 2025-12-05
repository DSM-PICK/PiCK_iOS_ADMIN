import SwiftUI
import ComposableArchitecture
import CheckSelfStudyTeacherDomainInterface
import BugReportDomainInterface

public struct AllTabFeature: View {
    let store: Store<AllTabReducer.State, AllTabReducer.Action>
    let fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol
    let uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol
    let submitBugReportUseCase: any SubmitBugReportUseCaseProtocol

    public init(
        store: Store<AllTabReducer.State, AllTabReducer.Action>,
        fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol,
        uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol,
        submitBugReportUseCase: any SubmitBugReportUseCaseProtocol
    ) {
        self.store = store
        self.fetchSelfStudyTeacherUseCase = fetchSelfStudyTeacherUseCase
        self.uploadBugImagesUseCase = uploadBugImagesUseCase
        self.submitBugReportUseCase = submitBugReportUseCase
    }

    public var body: some View {
        AllTabView(
            store: store,
            fetchSelfStudyTeacherUseCase: fetchSelfStudyTeacherUseCase,
            uploadBugImagesUseCase: uploadBugImagesUseCase,
            submitBugReportUseCase: submitBugReportUseCase
        )
    }
}
