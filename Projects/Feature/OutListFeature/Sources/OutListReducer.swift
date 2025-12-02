import ComposableArchitecture
import OutListDomainInterface
import Foundation

public struct OutListReducer: Reducer {

    public init() {}

    public struct State: Equatable {}
    public enum Action {}

    public func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {}
}
