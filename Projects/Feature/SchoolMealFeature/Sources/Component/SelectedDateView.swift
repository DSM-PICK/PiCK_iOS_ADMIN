import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

struct SelectedDateView: View {
    let date: Date

    var body: some View {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일"
        let formatted = formatter.string(from: date)
        let today = formatter.string(from: Date())

        var text = AttributedString(today == formatted ? "오늘 \(formatted)" : formatted)
        text.foregroundColor = Color.Normal.black
        if let range = text.range(of: "오늘") {
            text[range].foregroundColor = Color.Primary.primary500
        }

        return Text(text)
    }
}
