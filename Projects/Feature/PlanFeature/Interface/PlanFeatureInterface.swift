import Foundation

public protocol PlanFactory {
    func makePlanView() -> any PlanFeature
}

public protocol PlanFeature: Sendable {
    associatedtype ViewType
    var view: ViewType { get }
}
