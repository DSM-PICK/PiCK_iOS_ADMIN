import SwiftUI
import PiCK_iOS_DesignSystem

struct AcceptActionButtons: View {
    let isEnabled: Bool
    let onAccept: () -> Void
    let onReject: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button {
                onAccept()
            } label: {
                Text("수락")
                    .pickText(type: .body2, textColor: .Normal.white)
                    .frame(width: 65, height: 34)
                    .background(isEnabled ? Color.Primary.primary900 : Color.Gray.gray400)
                    .cornerRadius(8)
            }
            .disabled(!isEnabled)

            Button {
                onReject()
            } label: {
                Text("거절")
                    .pickText(type: .body2, textColor: .Normal.white)
                    .frame(width: 65, height: 34)
                    .background(isEnabled ? Color.Error.error : Color.Gray.gray400)
                    .cornerRadius(8)
            }
            .disabled(!isEnabled)
        }
    }
}
