import SwiftUI
import PiCK_iOS_DesignSystem
import HomeDomainInterface
import Utility

public struct SelfStudyView: View {
    public let adminMessage: String?

    public init(adminMessage: String?) {
        self.adminMessage = adminMessage
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Date().toKoreanDateString())
                .pickText(type: .body2)
                .padding(.top, 14)
                .padding(.leading, 20)
            
            Spacer()
            
            if let message = adminMessage {
                Text(highlightedMessage(message))
                    .pickText(type: .body1)
                    .padding(.bottom, 14)
                    .padding(.leading, 20)
            } else {
                Text("자습감독 정보를 불러오는 중입니다")
                    .pickText(type: .body1, textColor: Color.Normal.black)
                    .padding(.bottom, 14)
                    .padding(.leading, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.Gray.gray50)
        .cornerRadius(8)
    }
}

extension SelfStudyView {
    private func highlightedMessage(_ text: String) -> AttributedString {
        var attributed = AttributedString(text)
        attributed.foregroundColor = Color.Normal.black

        let pattern = #"\d층 자습감독"#

        if let regex = try? NSRegularExpression(pattern: pattern) {
            let nsText = text as NSString
            let matches = regex.matches(
                in: text,
                range: NSRange(location: 0, length: nsText.length)
            )

            for match in matches {
                if let range = Range(match.range, in: attributed) {
                    attributed[range].foregroundColor = Color.Primary.primary500
                }
            }
        }

        return attributed
    }
}
