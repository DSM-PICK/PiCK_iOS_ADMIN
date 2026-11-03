import FirebaseAnalytics
import Utility

struct FirebaseAnalyticsLogger: AnalyticsLogging {
    func logEvent(_ name: String, parameters: [String: Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}

enum AnalyticsConfiguration {
    // Firebase 는 setAnalyticsCollectionEnabled 값을 앱 재실행 후에도 유지하고 plist 값보다 우선하므로,
    // FirebaseApp.configure() 전에 매번 현재 구성 기준으로 덮어씀
    static func applyCollectionState() {
        Analytics.setAnalyticsCollectionEnabled(AppEnvironment.isProd)
    }

    // PROD 에서만 실제 로거를 연결 (그 외 구성에서는 이벤트를 만들기만 하고 보내지 않음)
    static func setup() {
        AnalyticsService.configure(logger: AppEnvironment.isProd ? FirebaseAnalyticsLogger() : nil)
    }
}
