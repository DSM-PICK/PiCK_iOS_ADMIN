import SwiftUI
import PiCK_iOS_DesignSystem

struct AcceptStudentCell: View {
    let studentNumber: String
    let studentName: String
    let startTime: String
    let endTime: String
    let activityType: String
    let reason: String
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
                        Text("\(startTime) - \(endTime) (\(activityType))")
                            .pickText(type: .body2, textColor: .Gray.gray900)
                    }
                    .padding(.top, 12)

                    Spacer()
                }

                Text(reason)
                    .pickText(type: .body2, textColor: .Gray.gray900)
                    .padding(.top, 10)
                    .padding(.horizontal, 16)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 79)
            .background(isSelected ? Color.Primary.primary100.opacity(0.2) : Color.Gray.gray50)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(isSelected ? Color.Primary.primary100 : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
