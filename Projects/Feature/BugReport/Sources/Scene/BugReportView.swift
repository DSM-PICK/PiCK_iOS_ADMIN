import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture

public struct BugReportView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<BugReportReducer>

    public init(store: StoreOf<BugReportReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.Background.background
                    .ignoresSafeArea()

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

                            Button(action: {
                                // TODO: 이미지 선택 기능 구현
                            }) {
                                HStack {
                                    Image(systemName: "photo")
                                        .foregroundColor(.Gray.gray500)
                                    Text("사진 선택")
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
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
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
        }
    }
}
