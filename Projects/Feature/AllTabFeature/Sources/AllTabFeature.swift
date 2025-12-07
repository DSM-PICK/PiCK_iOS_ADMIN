import SwiftUI
import ComposableArchitecture
import CheckSelfStudyTeacherDomainInterface
import BugReportDomainInterface
import AuthDomainInterface

public struct AllTabFeature: View {
    let store: Store<AllTabReducer.State, AllTabReducer.Action>
    let fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol
    let uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol
    let submitBugReportUseCase: any SubmitBugReportUseCaseProtocol
    let emailSendUseCase: any EmailSendUseCase
    let codeCheckUseCase: any CodeCheckUseCase

    public init(
        store: Store<AllTabReducer.State, AllTabReducer.Action>,
        fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol,
        uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol,
        submitBugReportUseCase: any SubmitBugReportUseCaseProtocol,
        emailSendUseCase: any EmailSendUseCase,
        codeCheckUseCase: any CodeCheckUseCase
    ) {
        self.store = store
        self.fetchSelfStudyTeacherUseCase = fetchSelfStudyTeacherUseCase
        self.uploadBugImagesUseCase = uploadBugImagesUseCase
        self.submitBugReportUseCase = submitBugReportUseCase
        self.emailSendUseCase = emailSendUseCase
        self.codeCheckUseCase = codeCheckUseCase
    }

    public var body: some View {
        AllTabView(
            store: store,
            fetchSelfStudyTeacherUseCase: fetchSelfStudyTeacherUseCase,
            uploadBugImagesUseCase: uploadBugImagesUseCase,
            submitBugReportUseCase: submitBugReportUseCase,
            emailSendUseCase: emailSendUseCase,
            codeCheckUseCase: codeCheckUseCase
        )
    }
}
