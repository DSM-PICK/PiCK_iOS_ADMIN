import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import PhotosUI

public struct BugReportView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<BugReportReducer>
    @State private var selectedItems: [PhotosPickerItem] = []
    @FocusState private var isDescriptionFocused: Bool

    public init(store: StoreOf<BugReportReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                customNavigationBar

                ScrollView {
                    formContent(viewStore: viewStore)
                }

                submitButton(viewStore: viewStore)
            }
            .background(Color.Background.background)
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .alert("제보 완료", isPresented: viewStore.binding(
                get: \.showSuccessAlert,
                send: .dismissSuccessAlert
            )) {
                Button("확인") {
                    dismiss()
                }
            } message: {
                Text("버그 제보가 성공적으로 완료되었습니다.")
            }
        }
    }

    private var customNavigationBar: some View {
        HStack {
            backButton
            Spacer()
            titleText
            Spacer()
            Color.clear
                .frame(width: 44, height: 44)
        }
        .frame(height: 56)
        .padding(.horizontal, 20)
        .background(Color.Background.background)
    }

    private func formContent(viewStore: ViewStore<BugReportReducer.State, BugReportReducer.Action>) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            bugLocationField(viewStore: viewStore)
            bugDescriptionTextView(viewStore: viewStore)
            bugImageSection(viewStore: viewStore)
        }
        .padding(.horizontal, 24)
        .padding(.top, 28)
    }

    private func bugLocationField(viewStore: ViewStore<BugReportReducer.State, BugReportReducer.Action>) -> some View {
        PiCKTextField(
            text: viewStore.binding(
                get: \.bugLocation,
                send: { .bugLocationChanged($0) }
            ),
            placeholder: "예: 메인, 외출 신청",
            titleText: "어디서 버그가 발생했나요?"
        )
    }

    private func bugDescriptionTextView(viewStore: ViewStore<BugReportReducer.State, BugReportReducer.Action>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("버그에 대해 설명해주세요")
                .pickText(type: .label1, textColor: .Normal.black)

            ZStack(alignment: .topLeading) {
                TextEditor(text: viewStore.binding(
                    get: \.bugDescription,
                    send: { .bugDescriptionChanged($0) }
                ))
                .pickText(type: .caption2, textColor: .Normal.black)
                .frame(height: 120)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.Gray.gray50)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isDescriptionFocused ? Color.Primary.primary500 : .clear, lineWidth: 1)
                )
                .scrollContentBackground(.hidden)
                .focused($isDescriptionFocused)

                if viewStore.bugDescription.isEmpty {
                    Text("자세히 입력해주세요")
                        .pickText(type: .caption2, textColor: .Gray.gray500)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }
            }
        }
    }

    private func bugImageSection(viewStore: ViewStore<BugReportReducer.State, BugReportReducer.Action>) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("버그 사진을 첨부해주세요")
                .pickText(type: .label1, textColor: .Normal.black)

            if viewStore.selectedImages.isEmpty {
                photosPickerButton(hasImages: false)
                    .onChange(of: selectedItems) { newItems in
                        handleImageSelection(newItems: newItems, viewStore: viewStore)
                    }
            } else {
                HStack(spacing: 0) {
                    photosPickerButton(hasImages: true)
                        .onChange(of: selectedItems) { newItems in
                            handleImageSelection(newItems: newItems, viewStore: viewStore)
                        }

                    selectedImagesScrollView(viewStore: viewStore)
                        .padding(.leading, 24)

                    Spacer()
                }
            }
        }
    }

    private func photosPickerButton(hasImages: Bool) -> some View {
        PhotosPicker(
            selection: $selectedItems,
            maxSelectionCount: 3,
            matching: .images
        ) {
            if hasImages {
                PiCKImage.image
                    .resizable()
                    .frame(width: 28, height: 28)
                    .frame(width: 100, height: 100)
                    .background(Color.Gray.gray50)
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.Gray.gray600, style: StrokeStyle(lineWidth: 1, dash: [5]))
                    )
            } else {
                VStack(spacing: 8) {
                    PiCKImage.image
                        .resizable()
                        .frame(width: 28, height: 28)

                    Text("사진을 첨부해주세요.")
                        .pickText(type: .caption2, textColor: .Gray.gray500)

                    Spacer()
                }
                .padding(.top, 22)
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .background(Color.Gray.gray50)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.Gray.gray600, style: StrokeStyle(lineWidth: 1, dash: [5]))
                )
            }
        }
    }

    private func selectedImagesScrollView(viewStore: ViewStore<BugReportReducer.State, BugReportReducer.Action>) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(viewStore.selectedImages.enumerated()), id: \.offset) { index, imageData in
                    if let uiImage = UIImage(data: imageData) {
                        imagePreview(uiImage: uiImage, index: index, viewStore: viewStore)
                    }
                }
            }
        }
    }

    private func imagePreview(uiImage: UIImage, index: Int, viewStore: ViewStore<BugReportReducer.State, BugReportReducer.Action>) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Button(action: {
                viewStore.send(.removeImage(index))
                selectedItems.remove(at: index)
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
            }
            .padding(4)
        }
    }

    private func handleImageSelection(newItems: [PhotosPickerItem], viewStore: ViewStore<BugReportReducer.State, BugReportReducer.Action>) {
        Task {
            var images: [Data] = []
            for item in newItems {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data),
                   let compressedData = uiImage.jpegData(compressionQuality: 0.1) {
                    images.append(compressedData)
                }
            }
            viewStore.send(.imagesSelected(images))
        }
    }

    private func submitButton(viewStore: ViewStore<BugReportReducer.State, BugReportReducer.Action>) -> some View {
        PiCKButton(
            buttonText: viewStore.isSubmitting ? "제보 중..." : "제보하기",
            isEnabled: viewStore.isSubmitButtonEnabled && !viewStore.isSubmitting,
            action: {
                viewStore.send(.submitButtonTapped)
            }
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.Normal.black)
        }
    }

    private var titleText: some View {
        Text("버그 제보")
            .pickText(type: .subTitle1, textColor: .Normal.black)
    }
}
