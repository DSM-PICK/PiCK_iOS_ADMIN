import Foundation

public struct SecretKeyRequestParams: Encodable {
    public let secretKey: String

    public init(
        secretKey: String
    ) {
        self.secretKey = secretKey
    }

    enum CodingKeys: String, CodingKey {
        case secretKey = "secret_key"
    }
}
