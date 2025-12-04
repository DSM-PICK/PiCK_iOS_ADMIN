import Foundation

public struct PasswordChangeRequestParams: Encodable {
    public let password: String
    public let adminId: String
    public let code: String

    enum CodingKeys: String, CodingKey {
        case password
        case adminId = "admin_id"
        case code
    }

    public init(password: String, adminId: String, code: String) {
        self.password = password
        self.adminId = adminId
        self.code = code
    }
}
