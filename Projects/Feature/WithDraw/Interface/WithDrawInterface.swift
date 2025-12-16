import Foundation
import SwiftUI

public protocol WithDrawFactory {
    func makeView() -> AnyView
}
