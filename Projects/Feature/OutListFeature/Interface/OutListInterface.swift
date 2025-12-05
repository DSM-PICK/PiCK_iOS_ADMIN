import SwiftUI
import ComposableArchitecture

public protocol OutListFactory {
    func makeView() -> AnyView
}
