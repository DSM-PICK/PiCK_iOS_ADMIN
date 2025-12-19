import SwiftUI
import PiCK_iOS_DesignSystem
import AcceptDomainInterface

struct AcceptCell: View {
    let studentNumber: String
    let name: String
    let type: OutgoingType
    let onAccept: () -> Void
    let onReject: () -> Void
    
    var body: some View {
        HStack(spacing: 2) {
            HStack(spacing: 8) {
                Text("\(studentNumber) \(name)")
                    .pickText(type: .subTitle2, textColor: .Normal.black)
                
                Text(type.title)
                    .pickText(type: .body2, textColor: .Primary.primary400)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .strokeBorder(Color.Primary.primary400, lineWidth: 1)
                    )
            }

            Spacer()

            HStack(spacing: 8) {
                Button(action: onAccept) {
                    Text("수락")
                        .pickText(type: .body2, textColor: .Normal.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(Color.Primary.primary500)
                        .cornerRadius(8)
                }
                
                Button(action: onReject) {
                    Text("거절")
                        .pickText(type: .body2, textColor: .Normal.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(Color.Error.error)
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
