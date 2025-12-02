import SwiftUI
import ComposableArchitecture

public protocol OutListFactory {
    func makeOutListView() -> AnyView
}
