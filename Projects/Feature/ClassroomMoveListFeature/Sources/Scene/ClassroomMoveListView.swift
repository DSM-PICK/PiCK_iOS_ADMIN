import Foundation
import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

public struct ClassroomMoveListView: View {
    let store: StoreOf<ClassroomMoveListReducer>
    @State private var isCurrentTypeBottomSheetPresented = false
    @State private var isClassroomBottomSheetPresented = false
    @State private var selectedFloor: Int = 2
    @State private var gradeValue: String = "전체"
    @State private var classNumValue: String = "전체"

    public init(store: StoreOf<ClassroomMoveListReducer>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        (Text(verbatim: todayString) + Text(" 교실 이동자"))
                            .pickText(type: .heading4, textColor: .Normal.black)
                            .padding(.leading, 24)

                        Spacer()

                        ClassroomFilterButton(
                            selectedClassroom: viewStore.currentType.displayText,
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

                    if viewStore.currentType == .floor {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach([2, 3, 4], id: \.self) { floor in
                                    Button {
                                        selectedFloor = floor
                                        viewStore.send(.fetchFloor(floor: floor))
                                    } label: {
                                        Text("\(floor)층")
                                            .pickText(
                                                type: .body1,
                                                textColor: selectedFloor == floor ? .Primary.primary500 : .Gray.gray600
                                            )
                                            .frame(width: 114, height: 32)
                                            .background(
                                                selectedFloor == floor
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

                    Spacer()
                }
                .sheet(isPresented: $isCurrentTypeBottomSheetPresented) {
                    PiCK_iOS_DesignSystem.SinglePickerBottomSheet(
                        isPresented: $isCurrentTypeBottomSheetPresented,
                        title: "필터을 선택해주세요",
                        options: ["층으로", "교실로"],
                        onComplete: { option in
                            let current = typeFromString(option)
                            viewStore.send(.currentTypeChanged(current))
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
                            viewStore.send(.fetchClassroom(grade: grade, classNum: classNum))
                        }
                    )
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.hidden)
                }
                .navigationTitle("교실 이동 현황")
                .navigationBarTitleDisplayMode(.inline)
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
}
