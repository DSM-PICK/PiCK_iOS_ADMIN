import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import AcceptDomainInterface
import BaseFeature

public enum ApplicationType: String, Equatable, Hashable {
    case outgoing = "외출 수락"
    case classroomMove = "교실 이동"
    case earlyReturn = "조기 귀가"

    var title: String { rawValue }
}

public struct AcceptView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isApplyBottomSheetPresented = false
    @State private var selectedOption: ApplicationType = .outgoing
    @State private var selectedFloor: Int = 1
    @State private var showApprovePopup = false
    @State private var showRejectPopup = false
    let store: StoreOf<AcceptReducer>

    public init(store: StoreOf<AcceptReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    HStack(spacing: 16) {
                        AcceptFilterButton(
                            selectedOption: selectedOption,
                            onTap: { isApplyBottomSheetPresented = true }
                        )

                        Text(Date().koreanMonthDayString)
                            .pickText(type: .body2, textColor: .Gray.gray700)
                    }
                    .padding(.leading, 24)

                    Spacer()

                    AcceptActionButtons(
                        isEnabled: !viewStore.selectedItemIds.isEmpty,
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

                Rectangle()
                    .fill(Color.Gray.gray200)
                    .frame(height: 0.5)
                    .cornerRadius(0.5)
                    .padding(.top, 20)
                    .padding(.horizontal, 24)

                if selectedOption == .classroomMove {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { floor in
                                Button {
                                    selectedFloor = floor
                                    viewStore.send(.fetchApplicationsByFloor(floor: floor))
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
                }

                HStack(spacing: 0) {
                    Text("\(selectedOption == .outgoing ? "외출 수락" : selectedOption == .classroomMove ? "교실 이동" : "조기 귀가") 신청한 학생")
                        .pickText(type: .body2, textColor: .Gray.gray600)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.top, selectedOption == .classroomMove ? 16 : 10)
                .padding(.leading, 24)
                .padding(.trailing, 24)

                ScrollView {
                    if viewStore.studentItems.isEmpty {
                        VStack(spacing: 12) {
                            PiCKImage.blackLogo
                                .resizable()
                                .frame(width: 88, height: 91)

                            Text("아직 외출을 신청한 학생이 없어요")
                                .pickText(type: .subTitle2, textColor: .Gray.gray500)
                        }
                        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height - 400)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(viewStore.studentItems) { item in
                                switch item {
                                case .application(let application):
                                    PiCKAcceptStudentCell(
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
                                    PiCKClassroomMoveCell(
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
                                case .earlyReturn(let earlyReturn):
                                    PiCKAcceptStudentCell(
                                        studentNumber: "\(earlyReturn.grade)\(earlyReturn.classNum)\(String(format: "%02d", earlyReturn.num))",
                                        studentName: earlyReturn.userName,
                                        startTime: earlyReturn.start,
                                        endTime: "",
                                        activityType: "조기 귀가",
                                        reason: earlyReturn.reason,
                                        isSelected: viewStore.selectedItemIds.contains(earlyReturn.id),
                                        onTap: {
                                            viewStore.send(.toggleSelection(id: earlyReturn.id))
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 24)
                    }
                }

                    Spacer()
                }
                .onAppear {
                    viewStore.send(.fetchApplications(type: .outgoing, grade: 5, classNum: 5))
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
                        options: ["외출 수락", "교실 이동", "조기 귀가"],
                        onComplete: { option in
                            if option == "외출 수락" {
                                selectedOption = .outgoing
                                viewStore.send(.fetchApplications(type: .outgoing, grade: 5, classNum: 5))
                            } else if option == "교실 이동" {
                                selectedOption = .classroomMove
                                viewStore.send(.fetchApplicationsByFloor(floor: selectedFloor))
                            } else if option == "조기 귀가" {
                                selectedOption = .earlyReturn
                                viewStore.send(.fetchApplications(type: .earlyReturn, grade: 5, classNum: 5))
                            }
                        }
                    )
                    .presentationDetents([.height(400)])
                    .presentationDragIndicator(.hidden)
                }

                if showApprovePopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showApprovePopup = false
                        }

                    PiCKConfirmPopUp(
                        title: "선택한 신청을 수락하시겠습니까?",
                        explain: "수락하면 학생에게 알림이 전송됩니다.",
                        type: .accept,
                        isPresented: $showApprovePopup
                    ) { action in
                        if action == .accept {
                            viewStore.send(.approveSelectedApplications)
                        }
                    }
                }

                if showRejectPopup {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showRejectPopup = false
                        }

                    PiCKConfirmPopUp(
                        title: "선택한 신청을 거절하시겠습니까?",
                        explain: "거절하면 학생에게 알림이 전송됩니다.",
                        type: .reject,
                        isPresented: $showRejectPopup
                    ) { action in
                        if action == .accept {
                            viewStore.send(.rejectSelectedApplications)
                        }
                    }
                }

                if viewStore.showToast, let message = viewStore.toastMessage {
                    VStack {
                        Spacer()

                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.Primary.primary500)
                                .font(.system(size: 20))

                            Text(message)
                                .pickText(type: .body1, textColor: .Normal.black)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 48)
                        .background(Color.Gray.gray50)
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                viewStore.send(.hideToast)
                            }
                        }
                    }
                    .zIndex(1000)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: viewStore.showToast)
                }
            }
            .onChange(of: viewStore.shouldDismiss) { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            }
        }
    }
}

