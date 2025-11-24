import SwiftUI
import PiCK_iOS_DesignSystem

struct ClassroomMoveCell: View {
    let studentNumber: String
    let studentName: String
    let startPeriod: Int
    let endPeriod: Int
    let currentClassroom: String
    let moveToClassroom: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(studentNumber) \(studentName)")
                            .pickText(type: .subTitle3, textColor: .Normal.black)
                    }
                    .padding(.top, 12)
                    .padding(.leading, 16)

                    Spacer()
                        .frame(width: 12)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(startPeriod)교시 - \(endPeriod)교시")
                            .pickText(type: .body2, textColor: .Gray.gray900)
                    }
                    .padding(.top, 12)

                    Spacer()
                }

                Text("\(currentClassroom) → \(moveToClassroom)")
                    .pickText(type: .body2, textColor: .Gray.gray900)
                    .padding(.top, 10)
                    .padding(.horizontal, 16)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 79)
            .background(Color.Gray.gray50)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.Primary.primary500 : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
