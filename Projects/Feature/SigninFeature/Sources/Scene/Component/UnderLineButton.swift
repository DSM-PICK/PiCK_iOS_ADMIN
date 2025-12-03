import SwiftUI
import PiCK_iOS_DesignSystem

struct UnderLineButton: View {
    let prefixText: String
    let buttonText: String
    let action: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Text(prefixText)
                .foregroundColor(Color.Gray.gray900)
                .pickText(type: .body1)

            Button(action: action) {
                Text(buttonText)
                    .foregroundColor(Color.Primary.primary500)
                    .pickText(type: .body1)
                    .underline()
            }
        }
    }
}
