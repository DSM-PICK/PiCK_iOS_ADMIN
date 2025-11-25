import SwiftUI
import PiCK_iOS_DesignSystem

struct FloorSelectionBottomSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedFloor: Int
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 100)
                .foregroundColor(.Gray.gray300)
                .frame(width: 40, height: 5)
                .padding(.top, 12)

            HStack {
                Text("층 선택")
                    .pickText(type: .label1, textColor: .Normal.black)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)

            Spacer().frame(height: 20)

            VStack(spacing: 12) {
                ForEach([2, 3, 4], id: \.self) { floor in
                    PiCKButton(
                        buttonText: "\(floor)층",
                        isEnabled: true,
                        height: 47
                    ) {
                        selectedFloor = floor
                        onSelect(floor)
                        isPresented = false
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
        }
    }
}
