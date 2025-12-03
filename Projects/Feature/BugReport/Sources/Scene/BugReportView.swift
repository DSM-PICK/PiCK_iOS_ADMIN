import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import PhotosUI

public struct BugReportView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<BugReportReducer>
    @State private var selectedItems: [PhotosPickerItem] = []

    public init(store: StoreOf<BugReportReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.Background.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            PiCKTextField(
                                text: viewStore.binding(
                                    get: \.bugLocation,
                                    send: { .bugLocationChanged($0) }
                                ),
                                placeholder: "예: 홈 화면, 로그인 화면 등",
                                titleText: "어디서 버그가 발생했나요?"
                            )

                            PiCKTextField(
                                text: viewStore.binding(
                                    get: \.bugDescription,
                                    send: { .bugDescriptionChanged($0) }
                                ),
                                placeholder: "버그에 대해 자세히 설명해주세요",
                                titleText: "버그에 대해 설명해주세요"
                            )

                            VStack(alignment: .leading, spacing: 12) {
                                Text("버그 사진을 첨부해주세요")
                                    .pickText(type: .label1, textColor: .Normal.black)

                                PhotosPicker(
                                    selection: $selectedItems,
                                    maxSelectionCount: 3,
                                    matching: .images
                                ) {
                                    HStack {
                                        Image(systemName: "photo")
                                            .foregroundColor(.Gray.gray500)
                                        Text("사진 선택 (\(viewStore.selectedImages.count)/3)")
                                            .pickText(type: .caption2, textColor: .Gray.gray500)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(height: 40)
                                    .background(Color.Gray.gray50)
                                    .cornerRadius(4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.Gray.gray300, lineWidth: 1)
                                    )
                                }
                                .onChange(of: selectedItems) { newItems in
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

                                if !viewStore.selectedImages.isEmpty {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(Array(viewStore.selectedImages.enumerated()), id: \.offset) { index, imageData in
                                                if let uiImage = UIImage(data: imageData) {
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
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                    }

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
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.Normal.black)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("버그 제보")
                        .pickText(type: .subTitle1, textColor: .Normal.black)
                }
            }
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
}
