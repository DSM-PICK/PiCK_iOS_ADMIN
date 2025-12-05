import Foundation
import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

public struct OutListView: View {
    @State private var isApplyBottomSheetPresented = false
    let store: StoreOf<OutListReducer>

    public init(store: StoreOf<OutListReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        let titleText = (Text(verbatim: todayString) + Text(" 외출자"))
                            .pickText(type: .heading4, textColor: .Normal.black)
                            .padding(.leading, 24)
                        
                        titleText

                        Spacer()

                        ClassroomFilterButton(
                            selectedClassroom: floorDisplayText(viewStore.currentFloor),
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

                    Group {
                        if viewStore.isLoading {
                            VStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else if viewStore.studentItems.isEmpty {
                            VStack {
                                Spacer()
                                VStack(spacing: 12) {
                                    PiCKImage.blackLogo
                                        .resizable()
                                        .frame(width: 88, height: 91)

                                    Text("아직 외출을 신청한 학생이 없어요")
                                        .pickText(type: .subTitle2, textColor: .Gray.gray500)
                                }
                                Spacer()
                            }
                        } else {
                            let items = viewStore.studentItems

                            ScrollView {
                                VStack(spacing: 16) {
                                    ForEach(items, id: \.id) { student in
                                        let studentNumber = "\(student.grade)\(student.classNum)\(String(format: "%02d", student.num))"
                                        let isSelected = viewStore.selectedStudents.contains(student.id)

                                        PiCKAcceptStudentCell(
                                            studentNumber: studentNumber,
                                            studentName: student.userName,
                                            startTime: student.start,
                                            endTime: student.end,
                                            activityType: "외출 수락",
                                            reason: student.reason,
                                            isSelected: isSelected,
                                            onTap: { viewStore.send(.studentTapped(student.id)) }
                                        )
                                    }
                                }
                                .padding(.top, 20)
                                .padding(.horizontal, 24)
                            }
                        }
                    }

                    PiCKButton(
                        buttonText: "복귀 시키기",
                        isEnabled: !viewStore.selectedStudents.isEmpty,
                        height: 45,
                        action: {
                            viewStore.send(.returnStudents)
                        }
                    )
                    .padding(.vertical, 10)
                    .padding(.horizontal, 24)
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .sheet(isPresented: $isApplyBottomSheetPresented) {
                    PiCK_iOS_DesignSystem.SinglePickerBottomSheet(
                        isPresented: $isApplyBottomSheetPresented,
                        title: "층을 선택해주세요",
                        options: ["전체", "2층", "3층", "4층"],
                        onComplete: { option in
                            let floor = floorFromDisplayText(option)
                            viewStore.send(.floorChanged(floor))
                        }
                    )
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.hidden)
                }
                .navigationTitle("외출자 목록")
                .navigationBarTitleDisplayMode(.inline)

                if viewStore.showAlert {
                    PiCKDisappearAlert(
                        successType: viewStore.alertSuccessType,
                        message: viewStore.alertMessage
                    )
                    .onDisappear {
                        viewStore.send(.dismissAlert)
                    }
                }
            }
        }
    }
}

extension OutListView {
    private var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일"
        return formatter.string(from: Date())
    }

    private func floorDisplayText(_ floor: Int) -> String {
        switch floor {
        case 5: return "전체"
        case 2: return "2층"
        case 3: return "3층"
        case 4: return "4층"
        default: return "전체"
        }
    }

    private func floorFromDisplayText(_ text: String) -> Int {
        switch text {
        case "2층": return 2
        case "3층": return 3
        case "4층": return 4
        default: return 5
        }
    }
}
