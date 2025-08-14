import Foundation

public struct LoginRequestParams: Encodable {
    public let adminId: String
    public let password: String
    public let deviceToken: String

    public init(
        adminId: String,
        password: String,
        deviceToken: String
    ) {
        self.adminId = adminId
        self.password = password
        self.deviceToken = deviceToken
    }

    enum CodingKeys: String, CodingKey {
        case adminId = "admin_id"
        case password
        case deviceToken = "device_token"
    }

}
