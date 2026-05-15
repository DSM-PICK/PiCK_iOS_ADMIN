import AcceptDomainInterface
import BaseFeature
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import SwiftUI

public enum ApplicationType: String, Equatable, Hashable {
    case outgoing = "외출 수락"
    case classroomMove = "교실 이동"
    case earlyReturn = "조기 귀가"

    var title: String { rawValue }
}

public struct AcceptView: View {
    @State private var isApplyBottomSheetPresented = false
    @State private var showApprovePopup = false
    @State private var showRejectPopup = false
    @Perception.Bindable var store: StoreOf<AcceptReducer>

    public init(store: StoreOf<AcceptReducer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    header

                    Divider()
                        .overlay(Color.Gray.gray200)
                        .padding(.top, 20)
                        .padding(.horizontal, 24)

                    if store.currentType == .classroomMove {
                        classroomMoveFloorFilter
                    }

                    Text("\(store.currentType.title) 신청한 학생")
                        .pickText(type: .body2, textColor: .Gray.gray600)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, store.currentType == .classroomMove ? 16 : 10)
                        .padding(.horizontal, 24)

                    content

                    Spacer()
                }
                .onAppear {
                    sendInitialFetch()
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        PiCKNavigationBar()
                            .padding(.leading, 8)
                    }
                }
                .sheet(isPresented: $isApplyBottomSheetPresented) {
                    PiCK_iOS_DesignSystem.SinglePickerBottomSheet(
                        isPresented: $isApplyBottomSheetPresented,
                        title: "수락 항목을 선택해주세요",
                        options: [
                            ApplicationType.outgoing.rawValue,
                            ApplicationType.classroomMove.rawValue,
                            ApplicationType.earlyReturn.rawValue
                        ],
                        onComplete: handleSelection
                    )
                    .presentationDetents([.height(400)])
                    .presentationDragIndicator(.hidden)
                }

                if showApprovePopup {
                    confirmationPopup(
                        title: "선택한 신청을 수락하시겠습니까?",
                        explain: "수락하면 학생에게 알림이 전송됩니다.",
                        isReject: false,
                        isPresented: $showApprovePopup,
                        action: .approveSelectedApplications
                    )
                }

                if showRejectPopup {
                    confirmationPopup(
                        title: "선택한 신청을 거절하시겠습니까?",
                        explain: "거절하면 학생에게 알림이 전송됩니다.",
                        isReject: true,
                        isPresented: $showRejectPopup,
                        action: .rejectSelectedApplications
                    )
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

private extension AcceptView {
    var header: some View {
        HStack(spacing: 0) {
            HStack(spacing: 16) {
                AcceptFilterButton(
                    selectedOption: store.currentType,
                    onTap: { isApplyBottomSheetPresented = true }
                )

                Text(Date().koreanMonthDayString)
                    .pickText(type: .body2, textColor: .Gray.gray700)
            }
            .padding(.leading, 24)

            Spacer()

            AcceptActionButtons(
                isEnabled: !store.selectedItemIds.isEmpty,
                onAccept: {
                    showApprovePopup = true
                },
                onReject: {
                    showRejectPopup = true
                }
            )
            .padding(.trailing, 24)
        }
        .padding(.top, 24)
    }

    var classroomMoveFloorFilter: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach([1, 2, 3, 4, 5], id: \.self) { floor in
                        Button {
                            store.send(.fetchApplicationsByFloor(floor: floor))
                        } label: {
                            Text("\(floor)층")
                                .pickText(
                                    type: .body1,
                                    textColor: store.currentFloor == floor ? .Primary.primary500 : .Gray.gray600
                                )
                                .frame(width: 114, height: 32)
                                .background(
                                    store.currentFloor == floor
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
                proxy.scrollTo(store.currentFloor, anchor: .center)
            }
            .onChange(of: store.currentType) { newValue in
                guard newValue == .classroomMove else { return }
                let currentFloor = store.currentFloor
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    proxy.scrollTo(currentFloor, anchor: .center)
                }
            }
            .padding(.top, 16)
        }
    }

    var content: some View {
        ScrollView {
            if store.studentItems.isEmpty {
                VStack(spacing: 12) {
                    PiCKImage.blackLogo
                        .resizable()
                        .frame(width: 88, height: 91)

                    Text(emptyStateMessage)
                        .pickText(type: .subTitle2, textColor: .Gray.gray500)
                }
                .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height - 400)
            } else {
                VStack(spacing: 16) {
                    ForEach(store.studentItems) { item in
                        studentCell(for: item)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 24)
            }
        }
    }

    @ViewBuilder
    func studentCell(for item: AcceptReducer.StudentItem) -> some View {
        switch item {
        case let .application(application):
            applicationCell(application)
        case let .classroomMove(move):
            classroomMoveCell(move)
        case let .earlyReturn(earlyReturn):
            earlyReturnCell(earlyReturn)
        }
    }

    func applicationCell(_ application: ApplicationEntity) -> some View {
        PiCKAcceptStudentCell(
            studentNumber: formattedStudentNumber(
                grade: application.grade,
                classNum: application.classNum,
                num: application.num
            ),
            studentName: application.userName,
            startTime: application.start,
            endTime: application.end,
            activityType: ApplicationType.outgoing.rawValue,
            reason: application.reason,
            isSelected: store.selectedItemIds.contains(application.id),
            onTap: {
                store.send(.toggleSelection(id: application.id))
            }
        )
    }

    func classroomMoveCell(_ move: ClassroomMoveEntity) -> some View {
        PiCKClassroomMoveCell(
            studentNumber: formattedStudentNumber(
                grade: move.grade,
                classNum: move.classNum,
                num: move.num
            ),
            studentName: move.userName,
            startPeriod: move.start,
            endPeriod: move.end,
            currentClassroom: "\(move.grade)학년 \(move.classNum)반",
            moveToClassroom: move.classroomName,
            isSelected: store.selectedItemIds.contains(move.id),
            onTap: {
                store.send(.toggleSelection(id: move.id))
            }
        )
    }

    func earlyReturnCell(_ earlyReturn: EarlyReturnAcceptEntity) -> some View {
        PiCKAcceptStudentCell(
            studentNumber: formattedStudentNumber(
                grade: earlyReturn.grade,
                classNum: earlyReturn.classNum,
                num: earlyReturn.num
            ),
            studentName: earlyReturn.userName,
            startTime: earlyReturn.start,
            endTime: "",
            activityType: ApplicationType.earlyReturn.rawValue,
            reason: earlyReturn.reason,
            isSelected: store.selectedItemIds.contains(earlyReturn.id),
            onTap: {
                store.send(.toggleSelection(id: earlyReturn.id))
            }
        )
    }

    var emptyStateMessage: String {
        switch store.currentType {
        case .outgoing:
            "아직 외출을 신청한 학생이 없어요"
        case .classroomMove:
            "아직 교실 이동을 신청한 학생이 없어요"
        case .earlyReturn:
            "아직 조기 귀가를 신청한 학생이 없어요"
        }
    }

    func sendInitialFetch() {
        switch store.currentType {
        case .outgoing, .earlyReturn:
            store.send(
                .fetchApplications(
                    type: store.currentType,
                    grade: store.currentGrade,
                    classNum: store.currentClassNum
                )
            )
        case .classroomMove:
            store.send(.fetchApplicationsByFloor(floor: store.currentFloor))
        }
    }

    func handleSelection(_ option: String) {
        guard let selectedType = ApplicationType(rawValue: option) else { return }

        switch selectedType {
        case .classroomMove:
            store.send(.fetchApplicationsByFloor(floor: store.currentFloor))
        case .outgoing, .earlyReturn:
            store.send(
                .fetchApplications(
                    type: selectedType,
                    grade: store.currentGrade,
                    classNum: store.currentClassNum
                )
            )
        }
    }

    func formattedStudentNumber(grade: Int, classNum: Int, num: Int) -> String {
        "\(grade)\(classNum)\(String(format: "%02d", num))"
    }

    @ViewBuilder
    func confirmationPopup(
        title: String,
        explain: String,
        isReject: Bool,
        isPresented: Binding<Bool>,
        action: AcceptReducer.Action
    ) -> some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
                isPresented.wrappedValue = false
            }

        PiCKConfirmPopUp(
            title: title,
            explain: explain,
            type: isReject ? .reject : .accept,
            isPresented: isPresented
        ) { popupAction in
            if popupAction == .accept {
                store.send(action)
            }
        }
    }
}
