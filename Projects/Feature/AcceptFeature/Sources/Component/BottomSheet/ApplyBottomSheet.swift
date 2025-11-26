import SwiftUI
import PiCK_iOS_DesignSystem

struct ApplyBottomSheet: View {
    @Binding var isPresented: Bool
    let onSelect: (SelectionOption) -> Void

    enum SelectionOption: String {
        case outgoing = "외출"
        case classroom = "교실 이동"
    }

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.Gray.gray300)
                .frame(width: 40, height: 4)
                .cornerRadius(2)
                .padding(.top, 12)

            Text("신청 종류 선택")
                .pickText(type: .subTitle1, textColor: .Normal.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 24)
                .padding(.horizontal, 24)

            VStack(spacing: 12) {
                optionButton(.outgoing)
                optionButton(.classroom)
            }
            .padding(.top, 20)
            .padding(.horizontal, 24)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }

    @ViewBuilder
    private func optionButton(_ option: SelectionOption) -> some View {
        Button {
            onSelect(option)
            isPresented = false
        } label: {
            Text(option.rawValue)
                .pickText(type: .body1, textColor: .Normal.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 56)
                .padding(.horizontal, 16)
                .background(Color.Gray.gray50)
                .cornerRadius(8)
        }
    }
}
