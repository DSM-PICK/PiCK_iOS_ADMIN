import Foundation
import SwiftUI

public protocol InfoSettingFactory {
    func makeView(secretKey: String, accountId: String, code: String, password: String) -> AnyView
}
