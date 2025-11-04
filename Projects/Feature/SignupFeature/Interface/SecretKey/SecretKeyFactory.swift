import Foundation
import SwiftUI

public protocol SecretKeyFactory {
    func makeView() -> AnyView
}
