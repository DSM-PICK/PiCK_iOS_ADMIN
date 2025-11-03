import Foundation

public struct EmailSendRequestParams: Encodable {
    public let mail: String
    public let title: String
    public let message: String

    public init(mail: String, title: String, message: String) {
        self.mail = mail
        self.title = title
        self.message = message
    }
}
