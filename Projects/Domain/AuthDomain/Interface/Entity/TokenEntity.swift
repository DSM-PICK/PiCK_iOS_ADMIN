import Foundation

public struct TokenEntity: Equatable {
    public let accessToken: String
    public let refreshToken: String
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
