import Foundation
import SwiftUI

public protocol PasswordFactory {
    func makeView(secretKey: String, accountId: String, code: String) -> AnyView
}
