import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import BaseFeature

public struct CheckSelfStudyTeacherView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<CheckSelfStudyTeacherReducer>

    public init(store: StoreOf<CheckSelfStudyTeacherReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.Normal.black)
                    }

                    Spacer()

                    Text("자습 감독 선생님 확인")
                        .pickText(type: .subTitle1, textColor: .Normal.black)

                    Spacer()

                    // Placeholder for symmetry
                    Color.clear
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.white)

                Divider()
                    .background(Color.Gray.gray200)

                if viewStore.isLoading {
                    Spacer()

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .Primary.primary500))

                    Spacer()
                } else if viewStore.teachers.isEmpty {
                    Spacer()

                    VStack(spacing: 12) {
                        PiCKImage.blackLogo
                            .resizable()
                            .frame(width: 88, height: 91)

                        Text("자습 감독 선생님 정보가 없어요")
                            .pickText(type: .subTitle2, textColor: .Gray.gray500)
                    }

                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewStore.teachers, id: \.self) { teacher in
                                HStack(spacing: 16) {
                                    Circle()
                                        .fill(Color.Primary.primary100)
                                        .frame(width: 48, height: 48)
                                        .overlay(
                                            Text(String(teacher.prefix(1)))
                                                .pickText(type: .subTitle1, textColor: .Primary.primary500)
                                        )

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(teacher)
                                            .pickText(type: .subTitle2, textColor: .Normal.black)

                                        Text("자습 감독")
                                            .pickText(type: .body2, textColor: .Gray.gray600)
                                    }

                                    Spacer()
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.Gray.gray200, lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 24)
                    }
                }
            }
            .background(Color.Gray.gray50)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
