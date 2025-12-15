import SwiftUI
import AcceptFeature
import PiCK_iOS_DesignSystem
import ComposableArchitecture

public struct SelfStudyCheckView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<SelfStudyCheckReducer>
    @State private var isClassBottomSheetPresented = false
    @State private var isStatusBottomSheetPresented = false
    @State private var selectedStudentId: String?
    @State private var tempSelectedGrade = "1"
    @State private var tempSelectedClass = "1"

    public init(store: StoreOf<SelfStudyCheckReducer>) {
        self.store = store
    }

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "출석":
            return .Primary.primary500
        case "현체":
            return .Gray.gray300
        case "이동":
            return .Gray.gray800
        case "외출":
            return .Primary.primary500
        case "무단":
            return .Error.error
        case "귀가", "결과":
            return .Gray.gray600
        case "취업중":
            return .Primary.primary500
        default:
            return .Gray.gray600
        }
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
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

                    HStack(spacing: 0) {
                        HStack(spacing: 16) {
                            Text(Date().koreanMonthDayString)
                                .pickText(type: .label1, textColor: .Normal.black)

                            Text("출결")
                                .pickText(type: .label1, textColor: .Normal.black)
                        }
                        .padding(.leading, 24)

                        Spacer()

                        Button {
                            tempSelectedGrade = "\(viewStore.selectedGrade)"
                            tempSelectedClass = "\(viewStore.selectedClass)"
                            isClassBottomSheetPresented = true
                        } label: {
                            HStack(spacing: 8) {
                                Text("\(viewStore.selectedGrade)학년 \(viewStore.selectedClass)반")
                                    .pickText(type: .body1, textColor: .Gray.gray800)

                                Image(systemName: "chevron.down")
                                    .foregroundColor(.Gray.gray600)
                                    .font(.system(size: 12))
                            }
                            .frame(width: 103, height: 34)
                            .background(Color.Gray.gray50)
                            .cornerRadius(8)
                        }
                        .padding(.trailing, 24)
                    }
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
                        VStack(spacing: 20) {
                            ForEach(viewStore.studentItems) { item in
                                HStack(spacing: 0) {
                                    Text("\(item.grade)\(item.classNum)\(String(format: "%02d", item.num))")
                                        .pickText(type: .body1, textColor: .Normal.black)

                                    Text(" ")

                                    Text(item.userName)
                                        .pickText(type: .subTitle3, textColor: .Normal.black)

                                    Spacer()

                                    Button {
                                        selectedStudentId = item.id
                                        isStatusBottomSheetPresented = true
                                    } label: {
                                        Text(item.status)
                                            .pickText(type: .body3, textColor: .Normal.white)
                                            .frame(width: 55, height: 29)
                                            .background(statusColor(item.status))
                                            .cornerRadius(8)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 53)
                                .padding(.horizontal, 24)
                                .background(Color.Gray.gray50)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 60)

                PiCKButton(
                    buttonText: "상태 저장하기",
                    isEnabled: !viewStore.isSaving,
                    action: {
                        viewStore.send(.saveAttendance)
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                }
                .onAppear {
                    viewStore.send(.fetchStudents)
                }
                .navigationBarBackButtonHidden(true)
                .toolbar(.hidden, for: .navigationBar)
                .toolbar(.hidden, for: .tabBar)
                .sheet(isPresented: $isClassBottomSheetPresented) {
                    PiCK_iOS_DesignSystem.DualPickerBottomSheet(
                        isPresented: $isClassBottomSheetPresented,
                        firstValue: $tempSelectedGrade,
                        secondValue: $tempSelectedClass,
                        title: "학년/반을 선택해주세요",
                        firstLabel: "학년",
                        secondLabel: "반",
                        firstOptions: ["1", "2", "3"],
                        secondOptions: ["1", "2", "3", "4"],
                        onComplete: { grade, classNum in
                            if let gradeInt = Int(grade), let classInt = Int(classNum) {
                                viewStore.send(.selectGradeAndClass(grade: gradeInt, classNum: classInt))
                            }
                        }
                    )
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.hidden)
                }
                .sheet(isPresented: $isStatusBottomSheetPresented) {
                    PiCK_iOS_DesignSystem.SinglePickerBottomSheet(
                        isPresented: $isStatusBottomSheetPresented,
                        title: "출결 상태를 선택해주세요",
                        options: ["출석", "이동", "귀가", "외출", "현체", "취업중"],
                        onComplete: { status in
                            if let studentId = selectedStudentId {
                                viewStore.send(.updateStudentStatus(id: studentId, status: status))
                            }
                        }
                    )
                    .presentationDetents([.height(450)])
                    .presentationDragIndicator(.hidden)
                }
            }
        }
    }
}
