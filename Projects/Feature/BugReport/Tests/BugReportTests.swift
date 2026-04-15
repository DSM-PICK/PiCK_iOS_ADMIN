import XCTest
import Combine
import ComposableArchitecture
import BugReportDomainInterface
import Utility
@testable import BugReportFeature

@MainActor
final class BugReportTests: XCTestCase {
    func testBugLocationBinding_UpdatesStateAndKeepsSubmitDisabledWithoutDescription() async {
        let store = makeStore()

        await store.send(
            .binding(BindingAction<BugReportReducer.State>.allCasePaths.bugLocation.embed("메인"))
        ) {
            $0.bugLocation = "메인"
            $0.isSubmitButtonEnabled = false
        }
    }

    func testBugDescriptionBinding_EnablesSubmitWhenLocationExists() async {
        let store = makeStore(initialState: state(bugLocation: "메인"))

        await store.send(
            .binding(
                BindingAction<BugReportReducer.State>.allCasePaths.bugDescription.embed("버튼이 눌리지 않아요")
            )
        ) {
            $0.bugDescription = "버튼이 눌리지 않아요"
            $0.isSubmitButtonEnabled = true
        }
    }

    func testImagesSelected_StoresImagesAndPreservesSubmitStateCalculation() async {
        let imageData = Data([1, 2, 3])
        let store = makeStore(initialState: state(bugLocation: "메인", bugDescription: "설명"))

        await store.send(.imagesSelected([imageData])) {
            $0.selectedImages = [imageData]
            $0.isSubmitButtonEnabled = true
        }
    }

    func testSubmitSuccessWithoutImages_ShowsSuccessAndResetsForm() async {
        let store = makeStore(
            uploadUseCase: UploadBugImagesUseCaseSpy(),
            submitUseCase: SubmitBugReportUseCaseSpy { _, _, _ in
                Just(())
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            },
            initialState: state(bugLocation: "메인", bugDescription: "설명", isSubmitButtonEnabled: true)
        )

        await store.send(.submitButtonTapped) {
            $0.isSubmitting = true
        }
        await store.receive(
            {
                if case .submitBugReportResponse(.success) = $0 {
                    return true
                }
                return false
            }
        ) {
            $0.isSubmitting = false
            $0.alertSuccessType = .success
            $0.alertMessage = "버그 제보가 완료되었습니다"
            $0.showAlert = true
            $0.shouldDismiss = true
            $0.bugLocation = ""
            $0.bugDescription = ""
            $0.selectedImages = []
            $0.isSubmitButtonEnabled = false
        }
    }

    private func makeStore(
        uploadUseCase: any UploadBugImagesUseCaseProtocol = UploadBugImagesUseCaseSpy(),
        submitUseCase: any SubmitBugReportUseCaseProtocol = SubmitBugReportUseCaseSpy(),
        initialState: BugReportReducer.State = .init()
    ) -> TestStore<BugReportReducer.State, BugReportReducer.Action> {
        TestStore(initialState: initialState) {
            BugReportReducer(
                uploadBugImagesUseCase: uploadUseCase,
                submitBugReportUseCase: submitUseCase
            )
        }
    }

    private func state(
        bugLocation: String = "",
        bugDescription: String = "",
        isSubmitButtonEnabled: Bool = false
    ) -> BugReportReducer.State {
        var state = BugReportReducer.State()
        state.bugLocation = bugLocation
        state.bugDescription = bugDescription
        state.isSubmitButtonEnabled = isSubmitButtonEnabled
        return state
    }
}

private final class UploadBugImagesUseCaseSpy: UploadBugImagesUseCaseProtocol {
    private let executeHandler: ([Data]) -> AnyPublisher<[String], Error>

    init(
        executeHandler: @escaping ([Data]) -> AnyPublisher<[String], Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(images: [Data]) -> AnyPublisher<[String], Error> {
        executeHandler(images)
    }
}

private final class SubmitBugReportUseCaseSpy: SubmitBugReportUseCaseProtocol {
    private let executeHandler: (String, String, [String]) -> AnyPublisher<Void, Error>

    init(
        executeHandler: @escaping (String, String, [String]) -> AnyPublisher<Void, Error> = { _, _, _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(title: String, content: String, fileNames: [String]) -> AnyPublisher<Void, Error> {
        executeHandler(title, content, fileNames)
    }
}
