import SwiftUI
import PiCK_iOS_DesignSystem

struct AcceptActionButtons: View {
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
                    .background(Color.Primary.primary900)
                    .cornerRadius(8)
            }

            Button {
                onReject()
            } label: {
                Text("거절")
                    .pickText(type: .body2, textColor: .Normal.white)
                    .frame(width: 65, height: 34)
                    .background(Color.Error.error)
                    .cornerRadius(8)
            }
        }
    }
}
