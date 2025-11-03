import SwiftUI
import ComposableArchitecture

public struct PlanFeature: View {
    let store: Store<PlanReducer.State, PlanReducer.Action>

    public init(
        store: Store<PlanReducer.State, PlanReducer.Action>
    ) {
        self.store = store
    }

    public var body: some View {
        PlanView(store: store)
    }
}
