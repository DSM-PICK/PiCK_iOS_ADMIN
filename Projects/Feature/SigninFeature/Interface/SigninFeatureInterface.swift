import Foundation
import SwiftUI

public protocol SigninFactory {
    func makeView() -> AnyView
}
