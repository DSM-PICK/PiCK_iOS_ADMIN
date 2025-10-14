
import SwiftUI
import Foundation

public final class AppRouter: ObservableObject {
    @Published public var path: [AppRoute] = []

    public init() {}
}
