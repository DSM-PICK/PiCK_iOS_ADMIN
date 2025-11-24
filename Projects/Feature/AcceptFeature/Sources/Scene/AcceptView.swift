import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import AcceptDomainInterface

public struct AcceptView: View {
    @State private var isApplyBottomSheetPresented = false
    @State private var isClassroomBottomSheetPresented = false
    @State private var selectedOption: PiCK_iOS_DesignSystem.ApplyBottomSheet.SelectionOption = .outgoing
    @State private var selectedGrade: Int = 1
    @State private var selectedClassNum: Int = 1
    @State private var isAllClassrooms: Bool = true
    let store: StoreOf<AcceptReducer>

    private var displayClassroomText: String {
        isAllClassrooms ? "전체" : "\(selectedGrade)학년 \(selectedClassNum)반"
    }

    public init(store: StoreOf<AcceptReducer>) {
        self.store = store
    }

    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: Date())
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    HStack(spacing: 16) {
                        AcceptFilterButton(
                            selectedOption: selectedOption,
                            onTap: { isApplyBottomSheetPresented = true }
                        )

                        Text(currentDateString)
                            .pickText(type: .body2, textColor: .Gray.gray700)
                    }
                    .padding(.leading, 24)

                    Spacer()

                    AcceptActionButtons(
                        isEnabled: !viewStore.selectedItemIds.isEmpty,
                        onAccept: {
                            viewStore.send(.approveSelectedApplications)
                        },
                        onReject: {
                            viewStore.send(.rejectSelectedApplications)
                        }
                    )
                    .padding(.trailing, 24)
                }
                .padding(.top, 24)

                Rectangle()
                    .fill(Color.Gray.gray200)
                    .frame(height: 0.5)
                    .cornerRadius(0.5)
                    .padding(.top, 20)
                    .padding(.horizontal, 24)

                HStack(spacing: 0) {
                    Text("\(selectedOption == .outgoing ? "외출 수락" : "교실 이동") 신청한 학생")
                        .pickText(type: .body2, textColor: .Gray.gray600)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ClassroomFilterButton(
                        selectedClassroom: displayClassroomText,
                        onTap: { isClassroomBottomSheetPresented = true }
                    )
                }
                .padding(.top, 10)
                .padding(.leading, 24)
                .padding(.trailing, 24)

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewStore.studentItems) { item in
                            switch item {
                            case .application(let application):
                                AcceptStudentCell(
                                    studentNumber: "\(application.grade)\(application.classNum)\(String(format: "%02d", application.num))",
                                    studentName: application.userName,
                                    startTime: application.start,
                                    endTime: application.end,
                                    activityType: "외출 수락",
                                    reason: application.reason,
                                    isSelected: viewStore.selectedItemIds.contains(application.id),
                                    onTap: {
                                        viewStore.send(.toggleSelection(id: application.id))
                                    }
                                )
                            case .classroomMove(let move):
                                ClassroomMoveCell(
                                    studentNumber: "\(move.grade)\(move.classNum)\(String(format: "%02d", move.num))",
                                    studentName: move.userName,
                                    startPeriod: move.start,
                                    endPeriod: move.end,
                                    currentClassroom: "\(move.grade)학년 \(move.classNum)반",
                                    moveToClassroom: move.classroomName,
                                    isSelected: viewStore.selectedItemIds.contains(move.id),
                                    onTap: {
                                        viewStore.send(.toggleSelection(id: move.id))
                                    }
                                )
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 24)
                }

                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    PiCKNavigationBar()
                        .padding(.leading, 8)
                }
            }
            .sheet(isPresented: $isApplyBottomSheetPresented) {
                PiCK_iOS_DesignSystem.ApplyBottomSheet(isPresented: $isApplyBottomSheetPresented) { option in
                    selectedOption = option
                    let type: AcceptReducer.ApplicationType = option == .outgoing ? .outgoing : .classroomMove
                    let grade = isAllClassrooms ? 5 : selectedGrade
                    let classNum = isAllClassrooms ? 5 : selectedClassNum
                    viewStore.send(.fetchApplications(type: type, grade: grade, classNum: classNum))
                }
            }
            .sheet(isPresented: $isClassroomBottomSheetPresented) {
                ClassroomSelectionBottomSheet(
                    isPresented: $isClassroomBottomSheetPresented,
                    selectedGrade: $selectedGrade,
                    selectedClassNum: $selectedClassNum
                ) { isAll, grade, classNum in
                    isAllClassrooms = isAll
                    if !isAll {
                        selectedGrade = grade
                        selectedClassNum = classNum
                    }
                    let type: AcceptReducer.ApplicationType = selectedOption == .outgoing ? .outgoing : .classroomMove
                    let fetchGrade = isAll ? 5 : grade
                    let fetchClassNum = isAll ? 5 : classNum
                    viewStore.send(.fetchApplications(type: type, grade: fetchGrade, classNum: fetchClassNum))
                }
                .presentationDetents([.height(450)])
                .presentationDragIndicator(.hidden)
            }
            .onAppear {
                viewStore.send(.fetchApplications(type: .outgoing, grade: 5, classNum: 5))
            }
        }
    }
}
