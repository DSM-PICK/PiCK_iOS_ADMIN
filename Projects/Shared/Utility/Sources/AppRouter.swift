import SwiftUI
import Foundation

public final class AppRouter: ObservableObject {
    @Published public var path: [AppRoute] = []

    public init() {}

    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
