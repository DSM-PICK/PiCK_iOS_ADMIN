import SwiftUI
import PiCK_iOS_DesignSystem

struct AcceptStudentCell: View {
    let studentNumber: String
    let studentName: String
    let startTime: String
    let endTime: String
    let activityType: String
    let reason: String

    var body: some View {
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
        .background(Color.Gray.gray50)
        .cornerRadius(12)
    }
}
