import SwiftUI
import ComposableArchitecture

public protocol PlanFactory {
    func makePlanView() -> AnyView
}
