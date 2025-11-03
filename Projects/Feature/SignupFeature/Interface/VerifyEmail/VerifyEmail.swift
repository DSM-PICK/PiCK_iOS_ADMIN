import Foundation
import SwiftUI

public protocol VerifyEmailFactory {
    func makeView(secretKey: String) -> AnyView
}
