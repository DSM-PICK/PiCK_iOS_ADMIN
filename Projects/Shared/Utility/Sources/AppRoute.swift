
import Foundation

public enum AppRoute: Hashable {
    case onboarding
    case signin
    case secretKey
    case email(secretKey: String)
    case password(secretKey: String, accountId: String, code: String)
    case home
}
