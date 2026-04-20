import Foundation
import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

public struct ClassroomMoveListView: View {
    @Environment(\.dismiss) var dismiss
    @Perception.Bindable var store: StoreOf<ClassroomMoveListReducer>
    @State private var isCurrentTypeBottomSheetPresented = false
    @State private var isClassroomBottomSheetPresented = false
    @State private var gradeValue: String = "전체"
    @State private var classNumValue: String = "전체"

    public init(store: StoreOf<ClassroomMoveListReducer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        (Text(verbatim: todayString) + Text(" 교실 이동자"))
                            .pickText(type: .heading4, textColor: .Normal.black)
                            .padding(.leading, 24)

                        Spacer()

                        ClassroomFilterButton(
                            selectedClassroom: store.currentType.displayText,
                            onTap: { isCurrentTypeBottomSheetPresented = true }
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

                    if store.currentType == .floor {
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach([1, 2, 3, 4, 5], id: \.self) { floor in
                                        Button {
                                            store.send(.fetchFloor(floor))
                                        } label: {
                                            Text("\(floor)층")
                                                .pickText(
                                                    type: .body1,
                                                    textColor: store.selectedFloor == floor
                                                        ? .Primary.primary500
                                                        : .Gray.gray600
                                                )
                                                .frame(width: 114, height: 32)
                                                .background(
                                                    store.selectedFloor == floor
                                                    ? Color.Primary.primary50
                                                    : Color.clear
                                                )
                                                .cornerRadius(8)
                                        }
                                        .id(floor)
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                            .onAppear {
                                proxy.scrollTo(3, anchor: .center)
                            }
                        }
                        .padding(.top, 16)
                    } else {
                        HStack {
                            Spacer()
                            ClassroomFilterButton(
                                selectedClassroom: "\(gradeValue)-\(classNumValue)",
                                onTap: { isClassroomBottomSheetPresented = true }
                            )
                            .padding(.trailing, 24)
                        }
                        .padding(.top, 16)
                    }

                    ScrollView {
                        if store.studentItems.isEmpty {
                            VStack(spacing: 12) {
                                PiCKImage.blackLogo
                                    .resizable()
                                    .frame(width: 88, height: 91)

                                Text("아직 교실 이동을 한 학생이 없어요")
                                    .pickText(type: .subTitle2, textColor: .Gray.gray500)
                            }
                            .frame(
                                maxWidth: .infinity,
                                minHeight: UIScreen.main.bounds.height - 400
                            )
                        } else {
                            VStack(spacing: 16) {
                                ForEach(store.studentItems, id: \.id) { item in
                                    PiCKClassroomMoveCell(
                                        studentNumber:
                                            "\(item.grade)\(item.classNum)\(String(format: "%02d", item.num))",
                                        studentName: item.userName,
                                        startPeriod: item.start,
                                        endPeriod: item.end,
                                        currentClassroom: "\(item.grade)학년 \(item.classNum)반",
                                        moveToClassroom: item.classroomName,
                                        isSelected: false,
                                        onTap: {}
                                    )
                                }
                            }
                            .padding(.top, 20)
                            .padding(.horizontal, 24)
                        }

                        Spacer()
                    }
                }
                .onAppear {
                    gradeValue = displayText(for: store.selectedGrade)
                    classNumValue = displayText(for: store.selectedClassNum)
                    store.send(.onAppear)
                }
                .navigationTitle("교실 이동 현황")
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
                .sheet(isPresented: $isCurrentTypeBottomSheetPresented) {
                    PiCK_iOS_DesignSystem.SinglePickerBottomSheet(
                        isPresented: $isCurrentTypeBottomSheetPresented,
                        title: "필터를 선택해주세요",
                        options: ["층으로", "교실로"],
                        onComplete: { option in
                            store.currentType = typeFromString(option)
                        }
                    )
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.hidden)
                }
                .sheet(isPresented: $isClassroomBottomSheetPresented) {
                    PiCK_iOS_DesignSystem.DualPickerBottomSheet(
                        isPresented: $isClassroomBottomSheetPresented,
                        firstValue: $gradeValue,
                        secondValue: $classNumValue,
                        title: "교실을 선택해주세요",
                        firstLabel: "학년",
                        secondLabel: "반",
                        firstOptions: ["전체", "1", "2", "3"],
                        secondOptions: ["전체", "1", "2", "3", "4"],
                        onComplete: { grade, classNum in
                            let isAllSelected = (grade == "전체") || (classNum == "전체")

                            let finalGrade = isAllSelected ? "전체" : grade
                            let finalClassNum = isAllSelected ? "전체" : classNum

                            gradeValue = finalGrade
                            classNumValue = finalClassNum

                            store.send(
                                .fetchClassroom(
                                    grade: classroomFromDisplayText(finalGrade),
                                    classNum: classroomFromDisplayText(finalClassNum)
                                )
                            )
                        }
                    )
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.hidden)
                }
            }
        }
    }
}

extension ClassroomMoveListView {
    private var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일"
        return formatter.string(from: Date())
    }

    private func typeFromString(_ text: String) -> ClassroomMoveListReducer.ClassroomMoveListType {
        switch text {
        case "층으로": return .floor
        case "교실로": return .classroom
        default: return .floor
        }
    }

    private func classroomFromDisplayText(_ text: String) -> Int {
        switch text {
        case "전체": return 5
        case "1": return 1
        case "2": return 2
        case "3": return 3
        case "4": return 4
        default: return 5
        }
    }

    private func displayText(for value: Int) -> String {
        value == 5 ? "전체" : "\(value)"
    }
}
