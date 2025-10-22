
import SwiftUI

public struct SelfStudyView: View {

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("날짜") // Placeholder for date
                .padding(.top, 14)
                .padding(.leading, 20)
                .font(.body) // Placeholder for Body3

            Text("선생님은 층 자습감독 입니다") // Placeholder for teacher and floor
                .font(.title2) // Placeholder for Body2, size 16
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.gray) // Placeholder for gray 500
    }
}
