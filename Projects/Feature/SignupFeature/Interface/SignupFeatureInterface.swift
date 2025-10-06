import Foundation
import SwiftUI

public protocol SignupFactory {
    func makeView() -> AnyView
}
