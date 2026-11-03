import Foundation

// 이벤트 로깅 창구. 앱이 PROD 에서만 logger 를 설정하므로, 그 외 구성에서는 아무것도 보내지 않음
public enum AnalyticsService {
    private static let lock = NSLock()
    private static var logger: AnalyticsLogging?

    public static func configure(logger: AnalyticsLogging?) {
        lock.lock()
        defer { lock.unlock() }
        self.logger = logger
    }

    public static func log(_ event: AnalyticsEvent) {
        lock.lock()
        let logger = self.logger
        lock.unlock()

        logger?.logEvent(event.name, parameters: event.parameters)
    }
}
