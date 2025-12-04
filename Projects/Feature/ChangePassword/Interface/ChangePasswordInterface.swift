import Foundation
import SwiftUI

public protocol ChangePasswordFactory {
    func makeView() -> AnyView
}

public protocol NewPasswordFactory {
    func makeView(accountId: String, code: String) -> AnyView
}
