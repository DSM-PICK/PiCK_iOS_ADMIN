import SwiftUI
import AcceptFeature
import PiCK_iOS_DesignSystem
import ComposableArchitecture

public struct SelfStudyCheckView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<SelfStudyCheckReducer>

    public init(store: StoreOf<SelfStudyCheckReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.Gray.gray800)
                            .font(.system(size: 20))
                    }
                    .padding(.leading, 24)

                    Spacer()
                }
                .padding(.top, 16)

                HStack(spacing: 16) {
                    Text(Date().koreanMonthDayString)
                        .pickText(type: .subTitle2, textColor: .Gray.gray800)

                    Text("출결")
                        .pickText(type: .body2, textColor: .Gray.gray700)
                }
                .padding(.leading, 24)
                .padding(.top, 20)

                Rectangle()
                    .fill(Color.Gray.gray200)
                    .frame(height: 0.5)
                    .cornerRadius(0.5)
                    .padding(.top, 20)
                    .padding(.horizontal, 24)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(SelfStudyCheckReducer.Period.allCases, id: \.self) { period in
                            Button {
                                viewStore.send(.selectPeriod(period))
                            } label: {
                                Text(period.title)
                                    .pickText(
                                        type: .body1,
                                        textColor: viewStore.selectedPeriod == period ? .Primary.primary500 : .Gray.gray600
                                    )
                                    .frame(width: 114, height: 32)
                                    .background(
                                        viewStore.selectedPeriod == period
                                        ? Color.Primary.primary50
                                        : Color.clear
                                    )
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 16)

                HStack(spacing: 0) {
                    Text("\(viewStore.selectedPeriod.title) 학생 출결")
                        .pickText(type: .body2, textColor: .Gray.gray600)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, 16)
                .padding(.leading, 24)
                .padding(.trailing, 24)

                ScrollView {
                    if viewStore.studentItems.isEmpty {
                        VStack(spacing: 12) {
                            PiCKImage.blackLogo
                                .resizable()
                                .frame(width: 88, height: 91)

                            Text("출결 정보가 없습니다")
                                .pickText(type: .subTitle2, textColor: .Gray.gray500)
                        }
                        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height - 400)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(viewStore.studentItems) { item in
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(item.grade)\(item.classNum)\(String(format: "%02d", item.num))")
                                            .pickText(type: .subTitle2, textColor: .Gray.gray800)

                                        Text(item.userName)
                                            .pickText(type: .body2, textColor: .Gray.gray600)
                                    }

                                    Spacer()

                                    Text(item.status)
                                        .pickText(type: .body1, textColor: .Primary.primary500)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.Primary.primary50)
                                        .cornerRadius(8)
                                }
                                .padding(16)
                                .background(Color.Gray.gray50)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 24)
                    }
                }

                Spacer()
            }
            .onAppear {
                viewStore.send(.fetchStudents)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
