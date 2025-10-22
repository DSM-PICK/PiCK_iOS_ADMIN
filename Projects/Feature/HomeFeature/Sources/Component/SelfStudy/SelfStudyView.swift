import SwiftUI
import PiCK_iOS_DesignSystem

public struct SelfStudyView: View {

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("1월 23일 화요일")
                .pickText(type: .body3)
                .padding(.top, 14)
                .padding(.leading, 20)
            
            Spacer()
            
            Text("선생님은 층 자습감독 입니다")
                .pickText(type: .body2)
                .padding(.bottom, 14)
                .padding(.leading, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.Gray.gray50)
        .cornerRadius(8)
    }
}
