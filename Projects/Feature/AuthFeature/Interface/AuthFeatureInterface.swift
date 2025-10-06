import Foundation
import SwiftUI

public protocol AuthFactory {
    func makeView() -> AnyView
}
