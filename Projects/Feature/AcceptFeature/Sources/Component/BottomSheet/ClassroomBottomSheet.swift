import SwiftUI
import PiCK_iOS_DesignSystem

struct ClassroomBottomSheet: View {
    @Binding var isPresented: Bool
    let onSelect: (ClassroomSelection) -> Void

    @State private var selectedGrade: Int = 1
    @State private var selectedClass: Int = 1

    struct ClassroomSelection {
        let grade: Int?
        let classNum: Int?

        var displayText: String {
            if grade == nil && classNum == nil {
                return "전체"
            } else if let grade = grade, let classNum = classNum {
                return "\(grade)학년 \(classNum)반"
            }
            return "전체"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.Gray.gray300)
                .frame(width: 40, height: 4)
                .cornerRadius(2)
                .padding(.top, 12)

            Text("교실 선택")
                .pickText(type: .subTitle1, textColor: .Normal.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                .padding(.horizontal, 24)

            Button {
                onSelect(ClassroomSelection(grade: nil, classNum: nil))
                isPresented = false
            } label: {
                Text("전체")
                    .pickText(type: .body1, textColor: .Normal.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 56)
                    .padding(.horizontal, 16)
                    .background(Color.Gray.gray50)
                    .cornerRadius(8)
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)

            HStack(spacing: 20) {
                VStack(spacing: 4) {
                    Text("학년")
                        .pickText(type: .subTitle3, textColor: .Gray.gray700)

                    Picker("학년", selection: $selectedGrade) {
                        ForEach(1...3, id: \.self) { grade in
                            Text("\(grade)")
                                .pickText(type: .body1, textColor: .Normal.black)
                                .tag(grade)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 80, height: 120)
                }

                VStack(spacing: 4) {
                    Text("반")
                        .pickText(type: .subTitle3, textColor: .Gray.gray700)

                    Picker("반", selection: $selectedClass) {
                        ForEach(1...4, id: \.self) { classNum in
                            Text("\(classNum)")
                                .pickText(type: .body1, textColor: .Normal.black)
                                .tag(classNum)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 80, height: 120)
                }
            }
            .padding(.top, 24)

            Button {
                onSelect(ClassroomSelection(grade: selectedGrade, classNum: selectedClass))
                isPresented = false
            } label: {
                Text("선택")
                    .pickText(type: .subTitle1, textColor: .white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.Primary.primary100)
                    .cornerRadius(12)
            }
            .padding(.top, 32)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
