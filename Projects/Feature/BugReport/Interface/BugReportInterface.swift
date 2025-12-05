import Foundation
import SwiftUI

public protocol BugReportFactory {
    func makeView() -> AnyView
}
