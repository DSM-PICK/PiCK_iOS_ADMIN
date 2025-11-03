import Foundation

public struct SignupRequestParams: Encodable {
    public let accountId: String
    public let password: String
    public let name: String
    public let grade: Int
    public let classNum: Int
    public let code: String
    public let deviceToken: String
    public let secretKey: String

    public init(accountId: String, password: String, name: String, grade: Int, classNum: Int, code: String, deviceToken: String, secretKey: String) {
        self.accountId = accountId
        self.password = password
        self.name = name
        self.grade = grade
        self.classNum = classNum
        self.code = code
        self.deviceToken = deviceToken
        self.secretKey = secretKey
    }

    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case password
        case name
        case grade
        case classNum = "class_num"
        case code
        case deviceToken = "device_token"
        case secretKey = "secret_key"
    }
}
