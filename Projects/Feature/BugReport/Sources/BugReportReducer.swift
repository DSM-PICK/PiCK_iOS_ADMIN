import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Foundation
import PhotosUI
import SwiftUI
import BugReportDomainInterface
import Combine

@Reducer
public struct BugReportReducer: Reducer {
    private let uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol
    private let submitBugReportUseCase: any SubmitBugReportUseCaseProtocol

    public init(
        uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol,
        submitBugReportUseCase: any SubmitBugReportUseCaseProtocol
    ) {
        self.uploadBugImagesUseCase = uploadBugImagesUseCase
        self.submitBugReportUseCase = submitBugReportUseCase
    }

    @ObservableState
    public struct State: Equatable {
        public var bugLocation: String = ""
        public var bugDescription: String = ""
        public var selectedImages: [Data] = []
        public var isSubmitting: Bool = false
        public var showAlert: Bool = false
        public var alertSuccessType: SuccessType = .success
        public var alertMessage: String = ""
        public var shouldDismiss: Bool = false
        public var isSubmitButtonEnabled: Bool = false

        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case imagesSelected([Data])
        case removeImage(Int)
        case submitButtonTapped
        case uploadImagesResponse(TaskResult<[String]>)
        case submitBugReportResponse(TaskResult<Void>)
        case dismissAlert
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding:
                updateSubmitButtonState(state: &state)
                return .none

            case let .imagesSelected(images):
                state.selectedImages = images
                updateSubmitButtonState(state: &state)
                return .none

            case let .removeImage(index):
                guard index < state.selectedImages.count else { return .none }
                state.selectedImages.remove(at: index)
                updateSubmitButtonState(state: &state)
                return .none

            case .submitButtonTapped:
                guard !state.bugLocation.isEmpty && !state.bugDescription.isEmpty else {
                    return .none
                }

                state.isSubmitting = true

                if state.selectedImages.isEmpty {
                    return .publisher { [title = state.bugLocation, content = state.bugDescription] in
                        submitBugReportUseCase.execute(
                            title: title,
                            content: content,
                            fileNames: []
                        )
                        .map { Action.submitBugReportResponse(.success(())) }
                        .catch { Just(Action.submitBugReportResponse(.failure($0))) }
                    }
                } else {
                    return .publisher { [images = state.selectedImages] in
                        uploadBugImagesUseCase.execute(images: images)
                            .map { Action.uploadImagesResponse(.success($0)) }
                            .catch { Just(Action.uploadImagesResponse(.failure($0))) }
                    }
                }

            case let .uploadImagesResponse(.success(fileNames)):
                return .publisher { [title = state.bugLocation, content = state.bugDescription] in
                    submitBugReportUseCase.execute(
                        title: title,
                        content: content,
                        fileNames: fileNames
                    )
                    .map { Action.submitBugReportResponse(.success(())) }
                    .catch { Just(Action.submitBugReportResponse(.failure($0))) }
                }

            case .uploadImagesResponse(.failure):
                state.isSubmitting = false
                state.alertSuccessType = .fail
                state.alertMessage = "이미지 업로드를 실패했어요"
                state.showAlert = true
                return .none

            case .submitBugReportResponse(.success):
                state.isSubmitting = false
                state.alertSuccessType = .success
                state.alertMessage = "버그 제보가 완료되었습니다"
                state.showAlert = true
                state.shouldDismiss = true
                state.bugLocation = ""
                state.bugDescription = ""
                state.selectedImages = []
                state.isSubmitButtonEnabled = false
                return .none

            case .submitBugReportResponse(.failure):
                state.isSubmitting = false
                state.alertSuccessType = .fail
                state.alertMessage = "버그 제보를 실패했어요"
                state.showAlert = true
                return .none

            case .dismissAlert:
                state.showAlert = false
                return .none
            }
        }
    }

    private func updateSubmitButtonState(state: inout State) {
        state.isSubmitButtonEnabled = !state.bugLocation.isEmpty && !state.bugDescription.isEmpty
    }
}
