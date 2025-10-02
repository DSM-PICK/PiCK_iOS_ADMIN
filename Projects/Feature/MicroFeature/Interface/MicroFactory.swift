import SwiftUI
import Moordinator

public protocol MicroFactory {
    func makeView() -> AnyView
}

public final class MicroFactoryImpl: MicroFactory {
    public func makeView() -> AnyView {
        AnyView(MicroView(store: .init()))
    }
}
