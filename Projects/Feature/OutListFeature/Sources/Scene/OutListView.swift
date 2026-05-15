import ComposableArchitecture
import Foundation
import PiCK_iOS_DesignSystem
import SwiftUI

public struct OutListView: View {
    @Environment(\.dismiss) private var dismiss
    @Perception.Bindable var store: StoreOf<OutListReducer>
    @State private var isApplyBottomSheetPresented = false

    public init(store: StoreOf<OutListReducer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        (Text(verbatim: todayString) + Text(" 외출자"))
                            .pickText(type: .heading4, textColor: .Normal.black)
                            .padding(.leading, 24)

                        Spacer()

                        ClassroomFilterButton(
                            selectedClassroom: floorDisplayText(store.currentFloor),
                            onTap: { isApplyBottomSheetPresented = true }
                        )
                        .padding(.trailing, 24)
                    }
                    .padding(.top, 24)

                    Rectangle()
                        .fill(Color.Gray.gray200)
                        .frame(height: 0.5)
                        .cornerRadius(0.5)
                        .padding(.top, 16)
                        .padding(.horizontal, 24)

                    HStack(spacing: 8) {
                        Button {
                            store.send(.fetchByType(type: .outing))
                        } label: {
                            Text("외출")
                                .pickText(
                                    type: .body1,
                                    textColor: store.currentType == .outing
                                        ? .Primary.primary500
                                        : .Gray.gray600
                                )
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                                .background(
                                    store.currentType == .outing
                                        ? Color.Primary.primary50
                                        : Color.clear
                                )
                                .cornerRadius(8)
                        }

                        Button {
                            store.send(.fetchByType(type: .earlyReturn))
                        } label: {
                            Text("조기귀가")
                                .pickText(
                                    type: .body1,
                                    textColor: store.currentType == .earlyReturn
                                        ? .Primary.primary500
                                        : .Gray.gray600
                                )
                                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                                .background(
                                    store.currentType == .earlyReturn
                                        ? Color.Primary.primary50
                                        : Color.clear
                                )
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                    Group {
                        if store.isLoading {
                            loadingView
                        } else if store.currentType == .outing && store.studentItems.isEmpty {
                            emptyStateView(message: "아직 외출을 신청한 학생이 없어요")
                        } else if store.currentType == .earlyReturn && store.earlyReturnItems.isEmpty {
                            emptyStateView(message: "아직 조기귀가를 신청한 학생이 없어요")
                        } else {
                            listView
                        }
                    }

                    if store.currentType == .outing {
                        PiCKButton(
                            buttonText: "복귀 시키기",
                            isEnabled: !store.selectedStudents.isEmpty,
                            height: 45,
                            action: {
                                store.send(.returnStudents)
                            }
                        )
                        .padding(.vertical, 10)
                        .padding(.horizontal, 24)
                    }
                }
                .onAppear {
                    store.send(.onAppear)
                }
                .sheet(isPresented: $isApplyBottomSheetPresented) {
                    PiCK_iOS_DesignSystem.SinglePickerBottomSheet(
                        isPresented: $isApplyBottomSheetPresented,
                        title: "층을 선택해주세요",
                        options: ["전체", "2층", "3층", "4층"],
                        onComplete: { option in
                            store.send(.floorChanged(floorFromDisplayText(option)))
                        }
                    )
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.hidden)
                }
                .navigationTitle("외출자 목록")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar(.hidden, for: .tabBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.Gray.gray800)
                                .font(.system(size: 20))
                        }
                    }
                }

                if store.showAlert {
                    PiCKDisappearAlert(
                        successType: store.alertSuccessType,
                        message: store.alertMessage
                    )
                    .onDisappear {
                        store.send(.dismissAlert)
                    }
                }
            }
        }
    }
}

private extension OutListView {
    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }

    @ViewBuilder
    func emptyStateView(message: String) -> some View {
        VStack {
            Spacer()
            VStack(spacing: 12) {
                PiCKImage.blackLogo
                    .resizable()
                    .frame(width: 88, height: 91)

                Text(message)
                    .pickText(type: .subTitle2, textColor: .Gray.gray500)
            }
            Spacer()
        }
    }

    var listView: some View {
        ScrollView {
            VStack(spacing: 16) {
                if store.currentType == .outing {
                    ForEach(store.studentItems, id: \.id) { student in
                        PiCKAcceptStudentCell(
                            studentNumber: formattedStudentNumber(
                                grade: student.grade,
                                classNum: student.classNum,
                                num: student.num
                            ),
                            studentName: student.userName,
                            startTime: student.start,
                            endTime: student.end,
                            activityType: "외출",
                            reason: student.reason,
                            isSelected: store.selectedStudents.contains(student.id),
                            onTap: { store.send(.studentTapped(student.id)) }
                        )
                    }
                } else {
                    ForEach(store.earlyReturnItems, id: \.id) { student in
                        PiCKAcceptStudentCell(
                            studentNumber: formattedStudentNumber(
                                grade: student.grade,
                                classNum: student.classNum,
                                num: student.num
                            ),
                            studentName: student.userName,
                            startTime: student.start,
                            endTime: "",
                            activityType: "조기귀가",
                            reason: student.reason,
                            isSelected: false,
                            onTap: {}
                        )
                    }
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)
        }
    }

    var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일"
        return formatter.string(from: Date())
    }

    func formattedStudentNumber(grade: Int, classNum: Int, num: Int) -> String {
        "\(grade)\(classNum)\(String(format: "%02d", num))"
    }

    func floorDisplayText(_ floor: Int) -> String {
        switch floor {
        case 5: return "전체"
        case 2: return "2층"
        case 3: return "3층"
        case 4: return "4층"
        default: return "전체"
        }
    }

    func floorFromDisplayText(_ text: String) -> Int {
        switch text {
        case "2층": return 2
        case "3층": return 3
        case "4층": return 4
        default: return 5
        }
    }
}
