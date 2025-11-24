import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import AcceptDomainInterface

public struct AcceptView: View {
    @State private var isApplyBottomSheetPresented = false
    @State private var isClassroomBottomSheetPresented = false
    @State private var selectedOption: ApplyBottomSheet.SelectionOption = .outgoing
    @State private var selectedClassroom: ClassroomBottomSheet.ClassroomSelection = ClassroomBottomSheet.ClassroomSelection(grade: nil, classNum: nil)
    let store: StoreOf<AcceptReducer>

    public init(store: StoreOf<AcceptReducer>) {
        self.store = store
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

                        Text("0월 0일")
                            .pickText(type: .body2, textColor: .Gray.gray700)
                    }
                    .padding(.leading, 24)

                    Spacer()

                    AcceptActionButtons(
                        onAccept: {
                            // 수락 액션
                        },
                        onReject: {
                            // 거절 액션
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
                    Text("\(selectedOption == .outgoing ? "외출" : "교실 이동") 신청한 학생")
                        .pickText(type: .body2, textColor: .Gray.gray600)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ClassroomFilterButton(
                        selectedClassroom: selectedClassroom.displayText,
                        onTap: { isClassroomBottomSheetPresented = true }
                    )
                }
                .padding(.top, 10)
                .padding(.leading, 24)
                .padding(.trailing, 24)

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewStore.applications) { application in
                            AcceptStudentCell(
                                studentNumber: "\(application.grade)\(application.classNum)\(String(format: "%02d", application.num))",
                                studentName: application.userName,
                                startTime: application.start,
                                endTime: application.end,
                                activityType: "외출",
                                reason: application.reason
                            )
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
                ApplyBottomSheet(isPresented: $isApplyBottomSheetPresented) { option in
                    selectedOption = option
                }
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.5)])
                .presentationDragIndicator(.hidden)
            }
            .sheet(isPresented: $isClassroomBottomSheetPresented) {
                ClassroomBottomSheet(isPresented: $isClassroomBottomSheetPresented) { classroom in
                    selectedClassroom = classroom

                    let grade = classroom.grade ?? 5
                    let classNum = classroom.classNum ?? 5
                    viewStore.send(.fetchApplications(grade: grade, classNum: classNum))
                }
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.5)])
                .presentationDragIndicator(.hidden)
            }
            .onAppear {
                viewStore.send(.fetchApplications(grade: 5, classNum: 5))
            }
        }
    }
}
