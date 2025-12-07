import SwiftUI
import ComposableArchitecture

public protocol ClassroomMoveListFactory {
    func makeView() -> AnyView
}
