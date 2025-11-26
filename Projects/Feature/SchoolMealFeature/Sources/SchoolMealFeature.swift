import SwiftUI
import ComposableArchitecture

public struct SchoolMealFeature: View {
    let store: Store<SchoolMealReducer.State, SchoolMealReducer.Action>

    public init(
        store: Store<SchoolMealReducer.State, SchoolMealReducer.Action>
    ) {
        self.store = store
    }

    public var body: some View {
        SchoolMealView(store: store)
    }
}
