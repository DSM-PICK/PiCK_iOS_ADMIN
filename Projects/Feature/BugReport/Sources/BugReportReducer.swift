import ComposableArchitecture
import Foundation
import PhotosUI
import SwiftUI
import BugReportDomainInterface

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

    public struct State: Equatable {
        public var bugLocation: String = ""
        public var bugDescription: String = ""
        public var selectedImages: [Data] = []
        public var isSubmitting: Bool = false
        public var showSuccessAlert: Bool = false
        public var isSubmitButtonEnabled: Bool = false

        public init() {}
    }

    public enum Action {
        case bugLocationChanged(String)
        case bugDescriptionChanged(String)
        case imagesSelected([Data])
        case removeImage(Int)
        case submitButtonTapped
        case uploadImagesResponse(TaskResult<[String]>)
        case submitBugReportResponse(TaskResult<Void>)
        case dismissSuccessAlert
        case updateSubmitButtonState
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .bugLocationChanged(text):
                state.bugLocation = text
                return .send(.updateSubmitButtonState)

            case let .bugDescriptionChanged(text):
                state.bugDescription = text
                return .send(.updateSubmitButtonState)

            case let .imagesSelected(images):
                state.selectedImages = images
                return .send(.updateSubmitButtonState)

            case let .removeImage(index):
                guard index < state.selectedImages.count else { return .none }
                state.selectedImages.remove(at: index)
                return .send(.updateSubmitButtonState)

            case .submitButtonTapped:
                guard !state.bugLocation.isEmpty && !state.bugDescription.isEmpty else {
                    return .none
                }

                state.isSubmitting = true

                if state.selectedImages.isEmpty {
                    return .run { [title = state.bugLocation, content = state.bugDescription] send in
                        await send(.submitBugReportResponse(
                            await TaskResult {
                                try await submitBugReportUseCase.execute(
                                    title: title,
                                    content: content,
                                    fileNames: []
                                )
                            }
                        ))
                    }
                } else {
                    return .run { [images = state.selectedImages] send in
                        await send(.uploadImagesResponse(
                            await TaskResult {
                                try await uploadBugImagesUseCase.execute(images: images)
                            }
                        ))
                    }
                }

            case let .uploadImagesResponse(.success(fileNames)):
                return .run { [title = state.bugLocation, content = state.bugDescription] send in
                    await send(.submitBugReportResponse(
                        await TaskResult {
                            try await submitBugReportUseCase.execute(
                                title: title,
                                content: content,
                                fileNames: fileNames
                            )
                        }
                    ))
                }

            case let .uploadImagesResponse(.failure(error)):
                state.isSubmitting = false
                return .none

            case .submitBugReportResponse(.success):
                state.isSubmitting = false
                state.showSuccessAlert = true
                state.bugLocation = ""
                state.bugDescription = ""
                state.selectedImages = []
                return .none

            case let .submitBugReportResponse(.failure(error)):
                state.isSubmitting = false
                return .none

            case .dismissSuccessAlert:
                state.showSuccessAlert = false
                return .none

            case .updateSubmitButtonState:
                state.isSubmitButtonEnabled = !state.bugLocation.isEmpty && !state.bugDescription.isEmpty
                return .none
            }
        }
    }
}
