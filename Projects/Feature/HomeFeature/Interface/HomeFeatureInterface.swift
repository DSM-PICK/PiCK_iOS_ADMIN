import Foundation
import SwiftUI

public protocol HomeFactory {
    func makeView() -> AnyView
}