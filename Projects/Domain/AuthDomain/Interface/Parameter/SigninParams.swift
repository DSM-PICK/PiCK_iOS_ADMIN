import Foundation

public struct SigninRequestParams: Encodable {
    public let adminID: String
    public let password: String
    public let deviceToken: String

    public init(
        adminID: String,
        password: String,
        deviceToken: String
    ) {
        self.adminID = adminID
        self.password = password
        self.deviceToken = deviceToken
    }

    enum CodingKeys: String, CodingKey {
        case adminID = "admin_id"
        case password
        case deviceToken = "device_token"
    }
}
