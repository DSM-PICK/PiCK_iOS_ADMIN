import SwiftUI
import ComposableArchitecture

public protocol OutingHistoryFactory {
    func makeView() -> AnyView
}
