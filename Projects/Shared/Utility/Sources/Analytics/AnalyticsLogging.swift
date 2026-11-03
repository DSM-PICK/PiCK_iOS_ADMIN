import Foundation

// 실제 전송 구현(Firebase)은 앱 타깃에 있고, Feature 모듈은 이 프로토콜만 알면 됨
public protocol AnalyticsLogging {
    func logEvent(_ name: String, parameters: [String: Any]?)
}
