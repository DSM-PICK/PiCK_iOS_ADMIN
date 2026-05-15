import Foundation
import SwiftUI

public protocol ChangePasswordFeatureInterface {}

public protocol ChangePasswordFactory {
    func makeView() -> AnyView
}

public protocol NewPasswordFactory {
    func makeView(accountId: String, code: String, onSuccess: @escaping () -> Void) -> AnyView
}
