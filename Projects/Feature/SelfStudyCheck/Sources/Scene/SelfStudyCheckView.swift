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

    public init(store: StoreOf<SelfStudyCheckReducer>) {
        self.store = store
    }

    private func statusColor(_ status: String) -> Color {
        switch status {
        case "출석":
            return .Primary.primary500
        case "외출", "무단":
            return .Error.error
        case "이동", "현체":
            return .Primary.primary500
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
                                        .pickText(type: .body1, textColor: .Gray.gray800)

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

                    Spacer()
                }
                .onAppear {
                    viewStore.send(.fetchStudents)
                }
                .navigationBarBackButtonHidden(true)
                .toolbar(.hidden, for: .navigationBar)
                .toolbar(.hidden, for: .tabBar)
                .sheet(isPresented: $isClassBottomSheetPresented) {
                    PiCK_iOS_DesignSystem.SinglePickerBottomSheet(
                        isPresented: $isClassBottomSheetPresented,
                        title: "학년/반을 선택해주세요",
                        options: generateClassOptions(),
                        onComplete: { option in
                            if let (grade, classNum) = parseClassOption(option) {
                                viewStore.send(.selectGradeAndClass(grade: grade, classNum: classNum))
                            }
                        }
                    )
                    .presentationDetents([.height(400)])
                    .presentationDragIndicator(.hidden)
                }
                .sheet(isPresented: $isStatusBottomSheetPresented) {
                    PiCK_iOS_DesignSystem.SinglePickerBottomSheet(
                        isPresented: $isStatusBottomSheetPresented,
                        title: "출결 상태를 선택해주세요",
                        options: ["출석", "이동", "현체", "외출", "귀가", "무단", "결과", "취업중"],
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

    private func generateClassOptions() -> [String] {
        var options: [String] = []
        for grade in 1...3 {
            for classNum in 1...4 {
                options.append("\(grade)학년 \(classNum)반")
            }
        }
        return options
    }

    private func parseClassOption(_ option: String) -> (Int, Int)? {
        let components = option.components(separatedBy: " ")
        guard components.count == 2,
              let gradeStr = components[0].first,
              let grade = Int(String(gradeStr)),
              let classStr = components[1].first,
              let classNum = Int(String(classStr)) else {
            return nil
        }
        return (grade, classNum)
    }
}
