import SwiftUI
import PiCK_iOS_DesignSystem

struct AcceptFilterButton: View {
    let selectedOption: ApplicationType
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 4) {
                Text(selectedOption.title)
                    .pickText(type: .subTitle1, textColor: .Normal.black)

                Image(systemName: "chevron.down")
                    .font(.system(size: 12))
                    .foregroundColor(.Gray.gray800)
            }
            .frame(width: 117, height: 46)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.Gray.gray200, lineWidth: 1)
            )
        }
    }
}
