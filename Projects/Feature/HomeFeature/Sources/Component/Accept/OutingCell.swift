import SwiftUI
import PiCK_iOS_DesignSystem
import OutListDomainInterface

struct OutingCell: View {
    let studentNumber: String
    let name: String
    var type: OutgoingType

    var body: some View {
        HStack(spacing: 2) {
                Text("\(studentNumber) \(name)")
                    .pickText(type: .subTitle2, textColor: .Normal.black)

            Spacer()

            HStack(spacing: 8) {
                Button(action: {}) {
                    Text(type.title)
                        .pickText(
                            type: .body2,
                            textColor: .Normal.white
                        )
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(type == .outgoing ? Color.Primary.primary500 : Color.Primary.primary300)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.Gray.gray50)
        .cornerRadius(12)
    }
}

