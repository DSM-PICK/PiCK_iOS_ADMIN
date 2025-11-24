import SwiftUI
import PiCK_iOS_DesignSystem

struct ClassroomFilterButton: View {
    let selectedClassroom: String
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 4) {
                Text(selectedClassroom)
                    .pickText(type: .body2, textColor: .Normal.black)

                Image(systemName: "chevron.down")
                    .font(.system(size: 10))
                    .foregroundColor(.Gray.gray800)
            }
            .frame(width: 70, height: 34)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.Gray.gray200, lineWidth: 1)
            )
        }
    }
}
