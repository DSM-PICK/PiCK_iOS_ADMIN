import SwiftUI
import ComposableArchitecture

public struct PlanFeature: View {
    let store: StoreOf<PlanReducer>

    public init(
        store: StoreOf<PlanReducer>
    ) {
        self.store = store
    }

    public var body: some View {
        PlanView(store: store)
    }
}
