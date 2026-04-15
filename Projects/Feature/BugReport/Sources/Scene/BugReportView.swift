import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import PhotosUI

public struct BugReportView: View {
    @Environment(\.dismiss) var dismiss
    @Perception.Bindable var store: StoreOf<BugReportReducer>
    @State private var selectedItems: [PhotosPickerItem] = []
    @FocusState private var isDescriptionFocused: Bool

    public init(store: StoreOf<BugReportReducer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                VStack(spacing: 0) {
                    customNavigationBar

                    ScrollView {
                        formContent
                    }

                    submitButton
                }
                .background(Color.Background.background)
                .navigationBarHidden(true)
                .toolbar(.hidden, for: .tabBar)
                
                if store.showAlert {
                    VStack {
                        Spacer()
                        PiCKDisappearAlert(
                            successType: store.alertSuccessType,
                            message: store.alertMessage
                        )
                        .onDisappear {
                            store.send(.dismissAlert)
                            if store.shouldDismiss {
                                dismiss()
                            }
                        }
                        .padding(.bottom, 40)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(999)
                }
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

    private var formContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            bugLocationField
            bugDescriptionTextView
            bugImageSection
        }
        .padding(.horizontal, 24)
        .padding(.top, 28)
    }

    private var bugLocationField: some View {
        PiCKTextField(
            text: $store.bugLocation,
            placeholder: "예: 메인, 외출 신청",
            titleText: "어디서 버그가 발생했나요?"
        )
    }

    private var bugDescriptionTextView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("버그에 대해 설명해주세요")
                .pickText(type: .label1, textColor: .Normal.black)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $store.bugDescription)
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

                if store.bugDescription.isEmpty {
                    Text("자세히 입력해주세요")
                        .pickText(type: .caption2, textColor: .Gray.gray500)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .allowsHitTesting(false)
                }
            }
        }
    }

    private var bugImageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("버그 사진을 첨부해주세요")
                .pickText(type: .label1, textColor: .Normal.black)

            if store.selectedImages.isEmpty {
                photosPickerButton(hasImages: false)
                    .onChange(of: selectedItems) { newItems in
                        handleImageSelection(newItems: newItems)
                    }
            } else {
                HStack(spacing: 0) {
                    photosPickerButton(hasImages: true)
                        .onChange(of: selectedItems) { newItems in
                            handleImageSelection(newItems: newItems)
                        }

                    selectedImagesScrollView
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

    private var selectedImagesScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(store.selectedImages.enumerated()), id: \.offset) { index, imageData in
                    if let uiImage = UIImage(data: imageData) {
                        imagePreview(uiImage: uiImage, index: index)
                    }
                }
            }
        }
    }

    private func imagePreview(uiImage: UIImage, index: Int) -> some View {
        ZStack(alignment: .topTrailing) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Button(action: {
                store.send(.removeImage(index))
                selectedItems.remove(at: index)
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.black.opacity(0.6)))
            }
            .padding(4)
        }
    }

    private func handleImageSelection(newItems: [PhotosPickerItem]) {
        Task {
            var images: [Data] = []
            for item in newItems {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data),
                   let compressedData = uiImage.jpegData(compressionQuality: 0.1) {
                    images.append(compressedData)
                }
            }
            store.send(.imagesSelected(images))
        }
    }

    private var submitButton: some View {
        PiCKButton(
            buttonText: store.isSubmitting ? "제보 중..." : "제보하기",
            isEnabled: store.isSubmitButtonEnabled && !store.isSubmitting,
            action: {
                store.send(.submitButtonTapped)
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
