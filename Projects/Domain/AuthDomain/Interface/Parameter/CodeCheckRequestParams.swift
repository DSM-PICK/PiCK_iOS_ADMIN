import Foundation

public struct CodeCheckRequestParams: Encodable {
    public let email: String
    public let code: String

    public init(email: String, code: String) {
        self.email = email
        self.code = code
    }
}
