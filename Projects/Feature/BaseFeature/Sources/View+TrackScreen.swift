import SwiftUI
import Utility

public extension View {
    // 화면이 나타날 때 GA screen_view 를 기록 (PROD 가 아니면 AnalyticsService 가 아무것도 보내지 않음)
    func trackScreen(_ name: String) -> some View {
        onAppear {
            AnalyticsService.log(.screenView(name: name))
        }
    }
}
