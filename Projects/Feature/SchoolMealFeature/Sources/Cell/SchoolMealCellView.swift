import SwiftUI
import PiCK_iOS_DesignSystem

struct SchoolMealCellView: View {
    let mealTime: String
    let menu: [String]
    let kcal: String

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            VStack(spacing: 16) {
                Text(mealTime)
                    .pickText(type: .subTitle1, textColor: .Primary.primary700)

                if !menu.isEmpty {
                    Text(kcal)
                        .pickText(type: .caption2, textColor: .Normal.white)
                        .frame(width: 75, height: 22)
                        .background(Color.Primary.primary500)
                        .cornerRadius(12)
                }
            }
            .frame(width: 140)

            Spacer()

            Text(menu.isEmpty ? "급식이 없습니다" : menu.joined(separator: "\n"))
                .pickText(type: .label1, textColor: .Normal.black)
                .multilineTextAlignment(.leading)
                .frame(width: 200)
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 140)
        .padding(.vertical, 10)
        .background(Color.Background.background)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.Primary.primary50, lineWidth: 2)
        )
    }
}
